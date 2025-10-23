import 'package:flutter/material.dart';

class ItemwiseBillScreen extends StatefulWidget {
  const ItemwiseBillScreen({super.key});

  @override
  State<ItemwiseBillScreen> createState() => _ItemwiseBillScreenState();
}

class _ItemwiseBillScreenState extends State<ItemwiseBillScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All Items';
  List<Map<String, dynamic>> _selectedItems = [];
  
  final List<Map<String, dynamic>> _allItems = [
    {
      'id': 1,
      'name': 'Maggie Noodles',
      'category': 'Snacks',
      'price': 20.0,
      'stock': 50,
      'image': 'assets/products/maggi.png',
    },
    {
      'id': 2,
      'name': 'Coca Cola 300ml',
      'category': 'Beverages',
      'price': 40.0,
      'stock': 25,
      'image': 'assets/products/coke.png',
    },
    {
      'id': 3,
      'name': 'Parle-G Biscuits',
      'category': 'Snacks',
      'price': 10.0,
      'stock': 100,
      'image': 'assets/products/parleg.png',
    },
    {
      'id': 4,
      'name': 'Lays Chips',
      'category': 'Snacks',
      'price': 30.0,
      'stock': 75,
      'image': 'assets/products/lays.png',
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesSearch = item['name'].toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == 'All Items' || item['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _addItemToBill(Map<String, dynamic> item) {
    setState(() {
      final existingIndex = _selectedItems.indexWhere((selected) => selected['id'] == item['id']);
      if (existingIndex != -1) {
        _selectedItems[existingIndex]['quantity'] += 1;
      } else {
        _selectedItems.add({
          ...item,
          'quantity': 1,
        });
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to bill'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeItemFromBill(int index) {
    setState(() {
      if (_selectedItems[index]['quantity'] > 1) {
        _selectedItems[index]['quantity'] -= 1;
      } else {
        _selectedItems.removeAt(index);
      }
    });
  }

  double get _totalAmount {
    return _selectedItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void _generateBill() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items to generate bill'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.receipt_long, color: Color(0xFF5777B5)),
            SizedBox(width: 8),
            Text('Bill Generated'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Items: ${_selectedItems.length}'),
            const SizedBox(height: 8),
            Text('Total Amount: ₹${_totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Bill has been generated successfully!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedItems.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: const Text('New Bill'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header - Fixed
            _buildHeader(),
            
            // Search and Filter - Fixed
            _buildSearchAndFilter(),
            
            // Main Content - Flexible layout
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < 600;
                  
                  if (isSmallScreen) {
                    return Column(
                      children: [
                        // Items List - Takes remaining space after bill section
                        Expanded(
                          child: _buildItemsList(),
                        ),
                        
                        // Current Bill - Flexible height, constrained to max
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 60,
                            maxHeight: constraints.maxHeight * 0.35, // Max 35% of available height
                          ),
                          child: _buildBillSection(),
                        ),
                      ],
                    );
                  } else {
                    // Desktop layout
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildItemsList(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(left: BorderSide(color: Color(0xFFE5E7EB))),
                            ),
                            child: _buildBillSection(),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            
            return Padding(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 12 : 20, 
                isSmallScreen ? 10 : 18, 
                isSmallScreen ? 12 : 20, 
                isSmallScreen ? 12 : 24
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios, 
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Expanded(
                    child: Text(
                      'Item-wise Bill',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildSearchAndFilter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVerySmallScreen = constraints.maxWidth < 400;
        
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(isVerySmallScreen ? 12.0 : 16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                style: TextStyle(fontSize: isVerySmallScreen ? 14 : 16),
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  hintStyle: TextStyle(
                    fontSize: isVerySmallScreen ? 14 : 16,
                    color: const Color(0xFF6B7280),
                  ),
                  prefixIcon: Icon(
                    Icons.search, 
                    color: const Color(0xFF6B7280),
                    size: isVerySmallScreen ? 20 : 24,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isVerySmallScreen ? 12 : 16,
                    vertical: isVerySmallScreen ? 12 : 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5777B5), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 8 : 12),
              // Category filter
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 14 : 16,
                  color: const Color(0xFF26344F),
                ),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(
                    fontSize: isVerySmallScreen ? 14 : 16,
                    color: const Color(0xFF6B7280),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isVerySmallScreen ? 12 : 16,
                    vertical: isVerySmallScreen ? 12 : 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5777B5), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                ),
                items: ['All Items', 'Snacks', 'Beverages', 'General'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(fontSize: isVerySmallScreen ? 14 : 16),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                  _filterItems();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemsList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVerySmallScreen = constraints.maxWidth < 400;
        
        return Container(
          margin: EdgeInsets.all(isVerySmallScreen ? 6 : 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(isVerySmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5777B5).withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      color: const Color(0xFF5777B5),
                      size: isVerySmallScreen ? 18 : 20,
                    ),
                    SizedBox(width: isVerySmallScreen ? 8 : 12),
                    Expanded(
                      child: Text(
                        'Available Items (${_filteredItems.length})',
                        style: TextStyle(
                          fontSize: isVerySmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF26344F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Items List
              Expanded(
                child: _filteredItems.isEmpty
                  ? _buildEmptyItemsState(isVerySmallScreen)
                  : ListView.builder(
                      padding: EdgeInsets.all(isVerySmallScreen ? 8 : 12),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _buildItemCard(item, isVerySmallScreen);
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyItemsState(bool isVerySmallScreen) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isVerySmallScreen ? 24 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: isVerySmallScreen ? 48 : 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: isVerySmallScreen ? 12 : 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: isVerySmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: isVerySmallScreen ? 6 : 8),
            Text(
              'Try adjusting your search or filter',
              style: TextStyle(
                fontSize: isVerySmallScreen ? 14 : 16,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, bool isVerySmallScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Item icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF5777B5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.inventory_2,
              color: Color(0xFF5777B5),
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF26344F),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item['category'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      ' • Stock: ${item['stock']}',
                      style: TextStyle(
                        fontSize: 11,
                        color: item['stock'] > 10 
                          ? const Color(0xFF10B981) 
                          : item['stock'] > 0 
                            ? const Color(0xFFFF805D) 
                            : const Color(0xFFE91E63),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Price and Add button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item['price'].toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: item['stock'] > 0 ? () => _addItemToBill(item) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: item['stock'] > 0 
                    ? const Color(0xFF5777B5) 
                    : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(50, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: item['stock'] > 0 ? 1 : 0,
                ),
                child: Text(
                  item['stock'] > 0 ? 'Add' : 'Out',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedItems.isEmpty ? Colors.grey.shade300 : const Color(0xFF5777B5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header - More compact
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _selectedItems.isEmpty 
                ? Colors.grey.shade50 
                : const Color(0xFF5777B5).withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedItems.isEmpty ? Icons.shopping_cart_outlined : Icons.shopping_cart,
                  color: _selectedItems.isEmpty ? Colors.grey.shade500 : const Color(0xFF5777B5),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedItems.isEmpty 
                      ? 'Current Bill - Add items to start' 
                      : 'Current Bill (${_selectedItems.length} items)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedItems.isEmpty ? Colors.grey.shade600 : const Color(0xFF26344F),
                    ),
                  ),
                ),
                if (_selectedItems.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₹${_totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Items list or empty state - Flexible but constrained
          Flexible(
            child: _selectedItems.isEmpty
              ? Container(
                  height: 40, // Fixed small height for empty state
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Add items from above',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true, // Important: allows ListView to size itself
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: _selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = _selectedItems[index];
                    return _buildBillItemCard(item, index);
                  },
                ),
          ),
          
          // Generate Bill Button - More compact
          if (_selectedItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 4),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generateBill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5777B5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 1,
                  ),
                  child: const Text(
                    'Generate Bill',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBillItemCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name and total price
          Row(
            children: [
              Expanded(
                child: Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF26344F),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '₹${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Price per unit and quantity controls
          Row(
            children: [
              Text(
                '₹${item['price']} each',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
              
              const Spacer(),
              
              // Quantity controls
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _removeItemFromBill(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.remove,
                          size: 12,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        '${item['quantity']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF26344F),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _addItemToBill(item),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.add,
                          size: 12,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 6),
              
              // Delete button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedItems.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFE91E63),
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}