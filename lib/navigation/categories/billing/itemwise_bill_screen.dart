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
        title: const Text('Bill Generated'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Items: ${_selectedItems.length}'),
            Text('Total Amount: ₹${_totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Bill has been generated successfully!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedItems.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF805D),
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
            _buildHeader(),
            _buildSearchAndFilter(),
            Expanded(
              child: Row(
                children: [
                  // Items list
                  Expanded(
                    flex: 2,
                    child: _buildItemsList(),
                  ),
                  // Selected items (bill)
                  Expanded(
                    flex: 1,
                    child: _buildBillSection(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5777B5), Color(0xFF26344F)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            const Expanded(
              child: Text(
                'Item-wise Bill',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            IconButton(
              onPressed: _generateBill,
              icon: const Icon(Icons.receipt_long, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search items...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFF5777B5)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Category filter
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            items: ['All Items', 'Snacks', 'Beverages', 'General'].map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
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
  }

  Widget _buildItemsList() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Available Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26344F),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return _buildItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.inventory_2,
            color: Color(0xFF26344F),
            size: 24,
          ),
        ),
        title: Text(
          item['name'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF26344F),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${item['category']}'),
            Text('Stock: ${item['stock']}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₹${item['price']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () => _addItemToBill(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                minimumSize: const Size(60, 30),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillSection() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Current Bill',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26344F),
              ),
            ),
          ),
          Expanded(
            child: _selectedItems.isEmpty
                ? const Center(
                    child: Text(
                      'No items added',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _selectedItems.length,
                    itemBuilder: (context, index) {
                      final item = _selectedItems[index];
                      return _buildBillItemCard(item, index);
                    },
                  ),
          ),
          if (_selectedItems.isNotEmpty) _buildBillSummary(),
        ],
      ),
    );
  }

  Widget _buildBillItemCard(Map<String, dynamic> item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF26344F),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹${item['price']} x ${item['quantity']}'),
                Text(
                  '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _removeItemFromBill(index),
                      icon: const Icon(Icons.remove, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text('${item['quantity']}'),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _addItemToBill(item),
                      icon: const Icon(Icons.add, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedItems.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete, color: Color(0xFFE91E63), size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Items:'),
              Text('${_selectedItems.length}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _generateBill,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5777B5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Generate Bill'),
            ),
          ),
        ],
      ),
    );
  }
}