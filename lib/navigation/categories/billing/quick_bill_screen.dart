import 'package:billbazar/services/print_service.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../services/bill_service.dart';
import '../../../services/printer_service_api.dart';
import '../../../widgets/responsive_dialog.dart';
import 'additem/add_item_screen.dart';
import 'addclient/add_client_screen.dart';

class QuickBillScreen extends StatefulWidget {
  const QuickBillScreen({super.key});

  @override
  State<QuickBillScreen> createState() => _QuickBillScreenState();
}

class _QuickBillScreenState extends State<QuickBillScreen> {
  final TextEditingController _notesController = TextEditingController();
  final BillService _billService = BillService();
  final PrinterServiceApi _printerService = PrinterServiceApi();

  String _selectedPaymentMethod = 'Cash';
  bool _isSinglePayment = true;
  bool _isLoading = false;

  // Dynamic data
  String _invoiceNumber = '';
  late DateTime _issueDate;
  late DateTime _dueDate;
  String? _selectedClient;
  String? _selectedClientContact;
  double _discount = 0.0;

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _clients = [];
  Map<String, dynamic>? _defaultPrinter;

  @override
  void initState() {
    super.initState();
    _generateInvoiceNumber();
    _setDates();
    _loadDefaultPrinter();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    _invoiceNumber = '# ${now.millisecondsSinceEpoch.toString().substring(8)}';
  }

  void _setDates() {
    final now = DateTime.now();
    _issueDate = now;
    _dueDate = now;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  Future<void> _loadDefaultPrinter() async {
    try {
      final printer = await _printerService.getDefaultPrinter();
      setState(() {
        _defaultPrinter = printer;
      });
    } catch (e) {
      debugPrint('Error loading default printer: $e');
    }
  }

  double get _subtotal {
    return _items.fold(0.0, (sum, item) => sum + item['totalPrice']);
  }

  double get _gstAmount {
    return _subtotal * 0.18; // 18% GST
  }

  double get _grandTotal {
    return _subtotal + _gstAmount - _discount;
  }

  void _addItem(String name, double unitPrice) {
    setState(() {
      final existingItemIndex = _items.indexWhere(
        (item) => item['name'] == name,
      );
      if (existingItemIndex != -1) {
        _items[existingItemIndex]['quantity']++;
        _items[existingItemIndex]['totalPrice'] =
            _items[existingItemIndex]['quantity'] *
            _items[existingItemIndex]['unitPrice'];
      } else {
        _items.add({
          'name': name,
          'unitPrice': unitPrice,
          'quantity': 1,
          'totalPrice': unitPrice,
        });
      }
    });
  }

  int _getAvailableStock(String itemName) {
    // Mock inventory data - in real app this would come from database
    final mockInventory = {
      'Tea': 50,
      'Coffee': 30,
      'Sugar': 100,
      'Milk': 25,
      'Bread': 15,
      'Biscuits': 0, // Out of stock
      'Rice': 200,
      'Dal': 75,
    };
    return mockInventory[itemName] ?? 10; // Default stock
  }

  void _showStockWarning(String itemName, int availableStock) {
    showResponsiveDialog(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(Icons.warning, color: Colors.orange, size: 24),
              SizedBox(width: 12),
              Text(
                'Insufficient Stock',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Only $availableStock units of $itemName are available in inventory.',
            style: const TextStyle(color: Color(0xFF4A5568), fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOutOfStockWarning(String itemName) {
    showResponsiveDialog(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(Icons.error, color: Colors.red, size: 24),
              SizedBox(width: 12),
              Text(
                'Out of Stock',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '$itemName is currently out of stock.',
            style: const TextStyle(color: Color(0xFF4A5568), fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addClient(String name, String contact) {
    setState(() {
      final clientExists = _clients.any((client) => client['name'] == name);
      if (!clientExists) {
        _clients.add({'name': name, 'contact': contact});
      }
      _selectedClient = name;
      _selectedClientContact = contact;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _updateItemQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      setState(() {
        _items.removeAt(index);
      });
    } else {
      setState(() {
        _items[index]['quantity'] = newQuantity;
        _items[index]['totalPrice'] = newQuantity * _items[index]['unitPrice'];
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showDiscountDialog() {
    final TextEditingController discountController = TextEditingController();
    discountController.text = _discount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Discount'),
        content: TextField(
          controller: discountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Discount Amount (₹)',
            hintText: 'Enter discount amount',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _resetBill() {
    setState(() {
      _items.clear();
      _selectedClient = null;
      _notesController.clear();
      _selectedPaymentMethod = 'Cash';
      _isSinglePayment = true;
      _generateInvoiceNumber();
    });
  }

  void _showPreviewDialog() {
    showResponsiveDialog(
      context: context,
      child: AlertDialog(
        title: Text('Invoice $_invoiceNumber'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedClient != null)
                  Text(
                    'Client: $_selectedClient',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (_selectedClientContact != null)
                  Text('Contact: $_selectedClientContact'),
                const SizedBox(height: 8),
                Text('Date: ${_formatDate(_issueDate)}'),
                const SizedBox(height: 16),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['name']} x${item['quantity']}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('₹${item['totalPrice'].toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text('₹${_subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Discount:'),
                    Text('₹${_discount.toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('GST (18%):'),
                    Text('₹${_gstAmount.toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹${_grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Payment: $_selectedPaymentMethod'),
                if (_notesController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Notes: ${_notesController.text}'),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _printBill() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items to the bill'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show printing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Printing bill...'),
          ],
        ),
      ),
    );

    try {
      // Prepare bill data - FIX: use 'unitPrice' instead of 'price'
      final items = _items
          .map(
            (item) => {
              'name': item['name'],
              'quantity': item['quantity'],
              'price':
                  item['unitPrice'], // Changed from item['price'] to item['unitPrice']
            },
          )
          .toList();

      final subtotal = _subtotal;
      final gstAmount = subtotal * 0.18; // 18% GST
      final discount = _discount;
      final total = _grandTotal + gstAmount;

      // Print the bill
      final printSuccess = await PrintService.instance.printBill(
        customerName: _selectedClient ?? 'Walk-in Customer',
        phoneNumber: '', // No phone field in this version
        items: items,
        subtotal: subtotal,
        gstAmount: gstAmount,
        discount: discount,
        total: total,
        paymentMethod: _selectedPaymentMethod,
      );

      // Close printing dialog
      Navigator.pop(context);

      if (printSuccess) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bill $_invoiceNumber printed successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'New Bill',
              textColor: Colors.white,
              onPressed: () {
                _resetBill();
              },
            ),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to print bill. Please check printer connection.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close printing dialog if still open
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Print error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Method to show responsive dialog
  Future<void> showResponsiveDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => ResponsiveDialog(content: child),
    );
  }

  Future<void> _showAddItemBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddItemBottomSheet(),
    );

    if (result != null) {
      _addItem(result['name'], result['unitPrice']);
    }
  }

  Future<void> _showAddClientBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddClientBottomSheet(),
    );

    if (result != null) {
      _addClient(result['name'], result['contact']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInvoiceDetailsCard(),
                        const SizedBox(height: 20.0),
                        _buildClientSection(),
                        const SizedBox(height: 20.0),
                        _buildItemsSection(),
                        const SizedBox(height: 20.0),
                        _buildSummaryCard(),
                        const SizedBox(height: 20.0),
                        _buildPaymentMethodCard(),
                        const SizedBox(height: 20.0),
                        _buildNotesSection(),
                        const SizedBox(height: 20.0),
                        _buildActionButtons(),
                        const SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5777B5), Color(0xFF26344F)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 16 : 20,
                isSmallScreen ? 14 : 18,
                isSmallScreen ? 16 : 20,
                isSmallScreen ? 18 : 24,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: isSmallScreen ? 20.0 : 24.0,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                  Expanded(
                    child: Text(
                      'Quick Bill',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18.0 : 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvoiceDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Invoice number',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _invoiceNumber,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF26344F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Issue Date',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        _formatDate(_issueDate),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF26344F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Due Date',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        _formatDate(_dueDate),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF26344F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Client',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF26344F),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _showAddClientBottomSheet,
              icon: const Icon(Icons.add, color: Colors.white, size: 16.0),
              label: const Text(
                'Add Client',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
        if (_selectedClient != null) ...[
          const SizedBox(height: 12.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.blue.shade600),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedClient!,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      if (_selectedClientContact != null &&
                          _selectedClientContact!.isNotEmpty)
                        Text(
                          _selectedClientContact!,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedClient = null;
                      _selectedClientContact = null;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.blue.shade600,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'items',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF26344F),
          ),
        ),
        const SizedBox(height: 12.0),
        ..._items.asMap().entries.map(
          (entry) => _buildItemCard(entry.value, entry.key),
        ),
        const SizedBox(height: 12.0),
        ElevatedButton.icon(
          onPressed: _showAddItemBottomSheet,
          icon: const Icon(Icons.add, color: Colors.white, size: 16.0),
          label: const Text(
            'Add item',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0,
          ),
        ),
        const SizedBox(height: 12.0),
        OutlinedButton(
          onPressed: _showDiscountDialog,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(color: Colors.grey[300]!),
          ),
          child: const Text(
            'Add Discount',
            style: TextStyle(
              color: Color(0xFF26344F),
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF26344F),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${item['quantity']}x₹${item['unitPrice'].toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _updateItemQuantity(index, item['quantity'] - 1),
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      '${item['quantity']}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF26344F),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () =>
                          _updateItemQuantity(index, item['quantity'] + 1),
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _removeItem(index),
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '₹ ${item['totalPrice'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26344F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '₹${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12.0),
          _buildSummaryRow('Discount', '₹${_discount.toStringAsFixed(2)}'),
          const SizedBox(height: 12.0),
          _buildSummaryRow('GST (18%)', '₹${_gstAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 12.0),
          _buildSummaryRow(
            'Grand Total',
            '₹${_grandTotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF26344F),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF26344F),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildPaymentButtonWithIcon(
                  'Cash',
                  'assets/billing/icons/q-1.png',
                  _selectedPaymentMethod == 'Cash',
                  () {
                    setState(() {
                      _selectedPaymentMethod = 'Cash';
                    });
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildPaymentButtonWithIcon(
                  'Upi',
                  'assets/billing/icons/q-2.png',
                  _selectedPaymentMethod == 'Upi',
                  () {
                    setState(() {
                      _selectedPaymentMethod = 'Upi';
                    });
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildPaymentButtonWithIcon(
                  'Card',
                  'assets/billing/icons/q-3.png',
                  _selectedPaymentMethod == 'Card',
                  () {
                    setState(() {
                      _selectedPaymentMethod = 'Card';
                    });
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildPaymentButtonWithIcon(
                  'Credit',
                  'assets/billing/icons/q-4.png',
                  _selectedPaymentMethod == 'Credit',
                  () {
                    setState(() {
                      _selectedPaymentMethod = 'Credit';
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSinglePayment = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: _isSinglePayment
                              ? AppColors.primaryOrange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Single',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: _isSinglePayment
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSinglePayment = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: !_isSinglePayment
                              ? AppColors.primaryOrange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Split',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: !_isSinglePayment
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButtonWithIcon(
    String label,
    String iconPath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: Image.asset(
                iconPath,
                width: 24.0,
                height: 24.0,
                fit: BoxFit.contain,
                color: isSelected ? Colors.white : null,
                colorBlendMode: isSelected ? BlendMode.srcIn : null,
                errorBuilder: (context, error, stackTrace) {
                  IconData fallbackIcon;
                  switch (label) {
                    case 'Cash':
                      fallbackIcon = Icons.account_balance_wallet;
                      break;
                    case 'Upi':
                      fallbackIcon = Icons.payment;
                      break;
                    case 'Card':
                      fallbackIcon = Icons.credit_card;
                      break;
                    case 'Credit':
                      fallbackIcon = Icons.handshake;
                      break;
                    default:
                      fallbackIcon = Icons.payment;
                  }
                  return Icon(
                    fallbackIcon,
                    color: isSelected ? Colors.white : Colors.grey,
                    size: 20.0,
                  );
                },
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF26344F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF26344F),
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Write something here....',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : _showPreviewDialog,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: const Text(
              'Preview',
              style: TextStyle(
                color: Color(0xFF26344F),
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _printBill,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Print Bill',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
