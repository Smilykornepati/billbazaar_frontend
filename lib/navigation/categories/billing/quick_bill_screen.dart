import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../services/print_service.dart';
import 'additem/add_item_screen.dart';
import 'addclient/add_client_screen.dart';

class QuickBillScreen extends StatefulWidget {
  const QuickBillScreen({super.key});

  @override
  State<QuickBillScreen> createState() => _QuickBillScreenState();
}

class _QuickBillScreenState extends State<QuickBillScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController(text: 'BillBazar Store');
  String? _selectedLogo;
  final List<String> _availableLogos = [
    'assets/logos/default_logo.png',
    'assets/logos/restaurant_logo.png',
    'assets/logos/retail_logo.png',
    'assets/logos/grocery_logo.png',
  ];
  String _selectedPaymentMethod = 'Cash';
  bool _isSinglePayment = true;

  // Dynamic data
  late String _invoiceNumber;
  late String _issueDate;
  late String _dueDate;
  String? _selectedClient;

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
    return _subtotal;
  }

  void _addItem(String name, double unitPrice) {
    // Check available stock (mock data)
    final availableStock = _getAvailableStock(name);
    
    setState(() {
      // Check if item already exists
      final existingItemIndex = _items.indexWhere((item) => item['name'] == name);
      
      if (existingItemIndex != -1) {
        // Check if adding one more would exceed stock
        final newQuantity = _items[existingItemIndex]['quantity'] + 1;
        if (newQuantity > availableStock) {
          _showStockWarning(name, availableStock);
          return;
        }
        // Increase quantity if item exists
        _items[existingItemIndex]['quantity'] = newQuantity;
        _items[existingItemIndex]['totalPrice'] = 
            newQuantity * _items[existingItemIndex]['unitPrice'];
      } else {
        if (availableStock <= 0) {
          _showOutOfStockWarning(name);
          return;
        }
        // Add new item
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insufficient Stock'),
        content: Text('Only $availableStock units of $itemName are available in inventory.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showOutOfStockWarning(String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Out of Stock'),
        content: Text('$itemName is currently out of stock.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
    if (newQuantity <= 0) {
      setState(() {
        _items.removeAt(index);
      });
      return;
    }

    // Check stock availability
    final itemName = _items[index]['name'];
    final availableStock = _getAvailableStock(itemName);
    
    if (newQuantity > availableStock) {
      _showStockWarning(itemName, availableStock);
      return;
    }

    setState(() {
      _items[index]['quantity'] = newQuantity;
      _items[index]['totalPrice'] = newQuantity * _items[index]['unitPrice'];
    });
  }

  void _showLogoSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Business Logo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('No Logo'),
              onTap: () {
                setState(() {
                  _selectedLogo = null;
                });
                Navigator.pop(context);
              },
            ),
            ..._availableLogos.map((logo) => ListTile(
              leading: const Icon(Icons.image),
              title: Text(logo.split('/').last.replaceAll('.png', '')),
              onTap: () {
                setState(() {
                  _selectedLogo = logo;
                });
                Navigator.pop(context);
              },
            )),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_photo_alternate),
              title: const Text('Upload Custom Logo'),
              subtitle: const Text('(Feature coming soon)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Custom logo upload - Coming Soon!'),
                  ),
                );
              },
            ),
          ],
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

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
  }  void _showPreviewDialog() {
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
                    Expanded(
                      child: Text(
                        '${item['name']} x${item['quantity']}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
      // Prepare bill data
      final items = _items.map((item) => {
        'name': item['name'],
        'quantity': item['quantity'],
        'price': item['price'],
      }).toList();

      final subtotal = _subtotal;
      final total = _grandTotal;

      // Print the bill
      final printSuccess = await PrintService.instance.printBill(
        customerName: _selectedClient ?? 'Walk-in Customer',
        phoneNumber: '', // No phone field in this version
        items: items,
        subtotal: subtotal,
        gstAmount: 0.0, // No GST
        discount: 0.0, // No discount
        total: total,
        paymentMethod: _selectedPaymentMethod,
        businessName: _businessNameController.text.isNotEmpty 
            ? _businessNameController.text 
            : 'BillBazar Store',
        logoPath: _selectedLogo,
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
            content: Text('Failed to print bill. Please check printer connection.'),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
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
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 16 : 20, 
                isSmallScreen ? 14 : 18, 
                isSmallScreen ? 16 : 20, 
                isSmallScreen ? 18 : 24
              ),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to categories
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: isSmallScreen ? 20.0 : 24.0,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                  // Title
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
          // Editable Business Name
          Row(
            children: [
              const Text(
                'Business Name',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const Spacer(),
              Expanded(
                child: TextField(
                  controller: _businessNameController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF26344F),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter business name',
                    hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Logo Selection
          Row(
            children: [
              const Text(
                'Business Logo',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showLogoSelection,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _selectedLogo != null ? Icons.image : Icons.add_photo_alternate,
                        size: 16.0,
                        color: const Color(0xFF26344F),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        _selectedLogo != null ? 'Logo Selected' : 'Select Logo',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF26344F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
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
        // Space where discount button was removed
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
                    // Editable quantity field
                    Container(
                      width: 60.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF26344F),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        controller: TextEditingController(
                          text: '${item['quantity']}',
                        ),
                        onSubmitted: (value) {
                          final newQuantity = int.tryParse(value) ?? item['quantity'];
                          _updateItemQuantity(
                            _items.indexOf(item),
                            newQuantity
                          );
                        },
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
