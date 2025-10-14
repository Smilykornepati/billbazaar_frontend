import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'additem/add_item_screen.dart';
import 'addclient/add_client_screen.dart';

class QuickBillScreen extends StatefulWidget {
  const QuickBillScreen({super.key});

  @override
  State<QuickBillScreen> createState() => _QuickBillScreenState();
}

class _QuickBillScreenState extends State<QuickBillScreen> {
  final TextEditingController _notesController = TextEditingController();
  String _selectedPaymentMethod = 'Cash';
  bool _isSinglePayment = true;

  // Dynamic data
  late String _invoiceNumber;
  late String _issueDate;
  late String _dueDate;
  String? _selectedClient;
  double _discount = 0.0;

  List<Map<String, dynamic>> _items = [];
  List<String> _clients = [];

  @override
  void initState() {
    super.initState();
    _generateInvoiceNumber();
    _setDates();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    _invoiceNumber = '# ${now.millisecondsSinceEpoch.toString().substring(8)}';
  }

  void _setDates() {
    final now = DateTime.now();
    _issueDate = '${now.day.toString().padLeft(2, '0')} ${_getMonthName(now.month)}, ${now.year}';
    _dueDate = _issueDate; // Same day for quick bill
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  double get _subtotal {
    return _items.fold(0.0, (sum, item) => sum + item['totalPrice']);
  }

  double get _grandTotal {
    return _subtotal - _discount;
  }

  void _addItem(String name, double unitPrice) {
    setState(() {
      // Check if item already exists
      final existingItemIndex = _items.indexWhere((item) => item['name'] == name);
      if (existingItemIndex != -1) {
        // Increase quantity if item exists
        _items[existingItemIndex]['quantity']++;
        _items[existingItemIndex]['totalPrice'] = 
            _items[existingItemIndex]['quantity'] * _items[existingItemIndex]['unitPrice'];
      } else {
        // Add new item
        _items.add({
          'name': name,
          'quantity': 1,
          'unitPrice': unitPrice,
          'totalPrice': unitPrice,
        });
      }
    });
  }

  void _addClient(String name, String contact) {
    setState(() {
      if (!_clients.contains(name)) {
        _clients.add(name);
        _selectedClient = name;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _updateItemQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index]['quantity'] = newQuantity;
        _items[index]['totalPrice'] = newQuantity * _items[index]['unitPrice'];
      }
    });
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
          keyboardType: TextInputType.number,
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
          ElevatedButton(
            onPressed: () {
              final discountValue = double.tryParse(discountController.text) ?? 0;
              setState(() {
                _discount = discountValue;
              });
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invoice $_invoiceNumber'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedClient != null)
                Text('Client: $_selectedClient', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Date: $_issueDate'),
              const SizedBox(height: 16),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${item['name']} x${item['quantity']}')),
                    Text('₹${item['totalPrice'].toStringAsFixed(2)}'),
                  ],
                ),
              )),
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
                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('₹${_grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _printBill() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items to the bill'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
  }

  void _resetBill() {
    setState(() {
      _items.clear();
      _selectedClient = null;
      _discount = 0.0;
      _notesController.clear();
      _selectedPaymentMethod = 'Cash';
      _isSinglePayment = true;
      _generateInvoiceNumber();
      _setDates();
    });
  }

  void _showAddItemBottomSheet() async {
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

  void _showAddClientBottomSheet() async {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with back button and title
              _buildHeader(),
              // Main content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice Details Card
                    _buildInvoiceDetailsCard(),
                    const SizedBox(height: 20.0),
                    // Client Section
                    _buildClientSection(),
                    const SizedBox(height: 20.0),
                    // Items Section
                    _buildItemsSection(),
                    const SizedBox(height: 20.0),
                    // Summary Card
                    _buildSummaryCard(),
                    const SizedBox(height: 20.0),
                    // Payment Method Card
                    _buildPaymentMethodCard(),
                    const SizedBox(height: 20.0),
                    // Notes Section
                    _buildNotesSection(),
                    const SizedBox(height: 20.0),
                    // Action Buttons
                    _buildActionButtons(),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header with back button and title - exact match to design
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF5777B5), // Blue
            Color(0xFF26344F), // Dark Blue
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Navigate back to categories
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16.0),
              // Title
              const Expanded(
                child: Text(
                  'Quick Bill',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Invoice Details Card - exact match to design
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
          // Invoice Number
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
          // Issue Date and Due Date
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
                        _issueDate,
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
                        _dueDate,
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

  // Client Section - exact match to design
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
              onPressed: () {
                _showAddClientBottomSheet();
              },
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
                  child: Text(
                    _selectedClient!,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedClient = null;
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

  // Items Section - exact match to design
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
        // Items list
        ..._items.map((item) => _buildItemCard(item)),
        const SizedBox(height: 12.0),
        // Add item button
        ElevatedButton.icon(
          onPressed: () {
            _showAddItemBottomSheet();
          },
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
        // Add discount button
        OutlinedButton(
          onPressed: () {
            _showDiscountDialog();
          },
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

  // Item card - exact match to design
  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Item details
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
                  '${item['quantity']}x₹${item['unitPrice'].toInt()}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                const SizedBox(height: 12.0),
                // Quantity controls
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _updateItemQuantity(
                          _items.indexOf(item),
                          item['quantity'] - 1
                        );
                      },
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
                        color: Color(0xFF26344F),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _updateItemQuantity(
                          _items.indexOf(item),
                          item['quantity'] + 1
                        );
                      },
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
          // Price and options
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _removeItem(_items.indexOf(item));
                },
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
                '₹ ${item['totalPrice'].toInt()}',
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

  // Summary Card - exact match to design
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
          _buildSummaryRow('Grand Total', '₹${_grandTotal.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  // Summary row widget
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

  // Payment Method Card - exact match to design with billing icons
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
          // Payment method buttons with actual billing icons
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
          // Single/Split toggle - exact match to design
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

  // Payment button widget with actual billing icons - exact match to design
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
            // Use actual billing icon image
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
                  // Fallback to Material icon if image fails to load
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

  // Notes Section - exact match to design
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

  // Action Buttons - exact match to design
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _showPreviewDialog();
            },
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
            onPressed: () {
              _printBill();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
            ),
            child: const Text(
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
