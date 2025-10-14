import 'package:flutter/material.dart';

class CreditDetailsScreen extends StatefulWidget {
  const CreditDetailsScreen({super.key});

  @override
  State<CreditDetailsScreen> createState() => _CreditDetailsScreenState();
}

class _CreditDetailsScreenState extends State<CreditDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  final List<Map<String, dynamic>> _creditRecords = [
    {
      'id': 1,
      'customerName': 'Raj Kumar',
      'phone': '+91 98765 43210',
      'creditAmount': 1500.0,
      'dueDate': '2025-10-20',
      'status': 'pending',
      'items': ['Maggie Noodles x5', 'Coca Cola x3'],
      'billDate': '2025-10-10',
    },
    {
      'id': 2,
      'customerName': 'Priya Sharma',
      'phone': '+91 87654 32109',
      'creditAmount': 850.0,
      'dueDate': '2025-10-18',
      'status': 'overdue',
      'items': ['Parle-G x10', 'Lays Chips x4'],
      'billDate': '2025-10-08',
    },
    {
      'id': 3,
      'customerName': 'Suraj Singh',
      'phone': '+91 76543 21098',
      'creditAmount': 2200.0,
      'dueDate': '2025-10-25',
      'status': 'pending',
      'items': ['Mixed Items - Bulk Order'],
      'billDate': '2025-10-12',
    },
    {
      'id': 4,
      'customerName': 'Anita Verma',
      'phone': '+91 65432 10987',
      'creditAmount': 650.0,
      'dueDate': '2025-10-15',
      'status': 'paid',
      'items': ['Coca Cola x8', 'Chips x3'],
      'billDate': '2025-10-05',
    },
  ];

  List<Map<String, dynamic>> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _filteredRecords = List.from(_creditRecords);
    _searchController.addListener(_filterRecords);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _creditRecords.where((record) {
        final matchesSearch = record['customerName'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
                             record['phone'].contains(_searchController.text);
        final matchesFilter = _selectedFilter == 'All' || record['status'] == _selectedFilter.toLowerCase();
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _markAsPaid(int id) {
    setState(() {
      final index = _creditRecords.indexWhere((record) => record['id'] == id);
      if (index != -1) {
        _creditRecords[index]['status'] = 'paid';
        _filterRecords();
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment marked as received'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _sendReminder(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Reminder'),
        content: Text('Send payment reminder to ${record['customerName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder sent to ${record['customerName']}'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF805D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showCreditDetails(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Credit Details - ${record['customerName']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Customer:', record['customerName']),
              _buildDetailRow('Phone:', record['phone']),
              _buildDetailRow('Credit Amount:', '₹${record['creditAmount']}'),
              _buildDetailRow('Bill Date:', record['billDate']),
              _buildDetailRow('Due Date:', record['dueDate']),
              _buildDetailRow('Status:', record['status'].toUpperCase()),
              const SizedBox(height: 12),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...record['items'].map<Widget>((item) => Text('• $item')).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (record['status'] != 'paid')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _markAsPaid(record['id']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              child: const Text('Mark Paid'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF10B981);
      case 'overdue':
        return const Color(0xFFE91E63);
      case 'pending':
        return const Color(0xFFFF805D);
      default:
        return const Color(0xFF6B7280);
    }
  }

  double get _totalPendingCredit {
    return _creditRecords
        .where((record) => record['status'] != 'paid')
        .fold(0.0, (sum, record) => sum + record['creditAmount']);
  }

  double get _totalOverdueCredit {
    return _creditRecords
        .where((record) => record['status'] == 'overdue')
        .fold(0.0, (sum, record) => sum + record['creditAmount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSummaryCards(),
            _buildSearchAndFilter(),
            Expanded(child: _buildCreditList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCreditDialog,
        backgroundColor: const Color(0xFFFF805D),
        child: const Icon(Icons.add, color: Colors.white),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Credit Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Export functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exporting credit report...'),
                      backgroundColor: Color(0xFF5777B5),
                    ),
                  );
                },
                icon: const Icon(Icons.file_download, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Pending',
              '₹${_totalPendingCredit.toStringAsFixed(0)}',
              const Color(0xFFFF805D),
              Icons.schedule,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Overdue',
              '₹${_totalOverdueCredit.toStringAsFixed(0)}',
              const Color(0xFFE91E63),
              Icons.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Total Records',
              '${_creditRecords.length}',
              const Color(0xFF5777B5),
              Icons.receipt_long,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name or phone...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              items: ['All', 'Pending', 'Overdue', 'Paid'].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                _filterRecords();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: _filteredRecords.length,
        itemBuilder: (context, index) {
          final record = _filteredRecords[index];
          return _buildCreditCard(record);
        },
      ),
    );
  }

  Widget _buildCreditCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['customerName'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF26344F),
                        ),
                      ),
                      Text(
                        record['phone'],
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(record['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    record['status'].toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(record['status']),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount: ₹${record['creditAmount']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    Text(
                      'Due: ${record['dueDate']}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showCreditDetails(record),
                      icon: const Icon(Icons.visibility, color: Color(0xFF5777B5)),
                    ),
                    if (record['status'] != 'paid')
                      IconButton(
                        onPressed: () => _sendReminder(record),
                        icon: const Icon(Icons.notifications, color: Color(0xFFFF805D)),
                      ),
                    if (record['status'] != 'paid')
                      IconButton(
                        onPressed: () => _markAsPaid(record['id']),
                        icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCreditDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Credit Record'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Credit Amount'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Due Date'),
                  subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && 
                    phoneController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  
                  this.setState(() {
                    _creditRecords.add({
                      'id': _creditRecords.length + 1,
                      'customerName': nameController.text,
                      'phone': phoneController.text,
                      'creditAmount': double.parse(amountController.text),
                      'dueDate': '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                      'status': 'pending',
                      'items': ['New Credit Entry'],
                      'billDate': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
                    });
                    _filterRecords();
                  });
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Credit record added successfully!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}