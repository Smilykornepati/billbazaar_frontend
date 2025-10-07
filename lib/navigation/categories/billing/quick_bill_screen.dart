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

  // Mock data
  final String _invoiceNumber = '# 166';
  final String _issueDate = '25 Sep, 2025';
  final String _dueDate = '25 Sep, 2025';
  final String _subtotal = '₹165.00';
  final String _discount = '₹0.00';
  final String _grandTotal = '₹165.00';

  final List<Map<String, dynamic>> _items = [
    {'name': 'Bread', 'quantity': 1, 'unitPrice': 20.0, 'totalPrice': 20.0},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showAddItemBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddItemBottomSheet(),
    );
  }

  void _showAddClientBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddClientBottomSheet(),
    );
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
      height: 60.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5777B5), // Blue
            Color(0xFF26344F), // Dark Blue
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
    return Row(
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
            // TODO: Implement add discount functionality
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
                        setState(() {
                          if (item['quantity'] > 1) {
                            item['quantity']--;
                            item['totalPrice'] =
                                item['quantity'] * item['unitPrice'];
                          }
                        });
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
                        setState(() {
                          item['quantity']++;
                          item['totalPrice'] =
                              item['quantity'] * item['unitPrice'];
                        });
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
                  // TODO: Implement item options
                },
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.grey,
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
          _buildSummaryRow('Subtotal', _subtotal),
          const SizedBox(height: 12.0),
          _buildSummaryRow('Discount', _discount),
          const SizedBox(height: 12.0),
          _buildSummaryRow('Grand Total', _grandTotal, isTotal: true),
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
              // TODO: Implement preview functionality
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
              // TODO: Implement print bill functionality
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
