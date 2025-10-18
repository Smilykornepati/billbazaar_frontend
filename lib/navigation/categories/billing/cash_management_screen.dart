import 'package:flutter/material.dart';

class CashManagementScreen extends StatefulWidget {
  const CashManagementScreen({super.key});

  @override
  State<CashManagementScreen> createState() => _CashManagementScreenState();
}

class _CashManagementScreenState extends State<CashManagementScreen> {
  double _openingBalance = 5000.0;
  double _currentBalance = 5000.0;
  
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 1,
      'type': 'income',
      'description': 'Sale - Invoice #001',
      'amount': 850.0,
      'time': '10:30 AM',
      'date': '2025-01-14',
      'category': 'Sales',
    },
    {
      'id': 2,
      'type': 'expense',
      'description': 'Purchase - Inventory',
      'amount': 1200.0,
      'time': '02:15 PM',
      'date': '2025-01-14',
      'category': 'Purchase',
    },
    {
      'id': 3,
      'type': 'income',
      'description': 'Credit Collection - Raj Kumar',
      'amount': 1500.0,
      'time': '04:45 PM',
      'date': '2025-01-14',
      'category': 'Collection',
    },
    {
      'id': 4,
      'type': 'expense',
      'description': 'Store Rent',
      'amount': 2500.0,
      'time': '09:00 AM',
      'date': '2025-01-13',
      'category': 'Expense',
    },
  ];

  @override
  void initState() {
    super.initState();
    _calculateCurrentBalance();
  }

  void _calculateCurrentBalance() {
    double balance = _openingBalance;
    for (var transaction in _transactions) {
      if (transaction['type'] == 'income') {
        balance += transaction['amount'];
      } else {
        balance -= transaction['amount'];
      }
    }
    setState(() {
      _currentBalance = balance;
    });
  }

  double get _totalIncome {
    return _transactions
        .where((t) => t['type'] == 'income')
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  double get _totalExpenses {
    return _transactions
        .where((t) => t['type'] == 'expense')
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  void _addTransaction(String type, String description, double amount, String category) {
    setState(() {
      _transactions.insert(0, {
        'id': _transactions.length + 1,
        'type': type,
        'description': description,
        'amount': amount,
        'time': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
        'category': category,
      });
    });
    _calculateCurrentBalance();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${type == 'income' ? 'Income' : 'Expense'} added successfully!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _showAddTransactionDialog() {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    String selectedType = 'income';
    String selectedCategory = 'Sales';
    
    final incomeCategories = ['Sales', 'Collection', 'Other Income'];
    final expenseCategories = ['Purchase', 'Expense', 'Rent', 'Utilities', 'Other'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: ['income', 'expense'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type == 'income' ? 'Income' : 'Expense'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                      selectedCategory = selectedType == 'income' 
                          ? incomeCategories.first 
                          : expenseCategories.first;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: (selectedType == 'income' ? incomeCategories : expenseCategories)
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
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
                if (descriptionController.text.isNotEmpty && 
                    amountController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _addTransaction(
                    selectedType,
                    descriptionController.text,
                    double.parse(amountController.text),
                    selectedCategory,
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

  void _showSetOpeningBalanceDialog() {
    final balanceController = TextEditingController(text: _openingBalance.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Opening Balance'),
        content: TextField(
          controller: balanceController,
          decoration: const InputDecoration(labelText: 'Opening Balance'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (balanceController.text.isNotEmpty) {
                setState(() {
                  _openingBalance = double.parse(balanceController.text);
                });
                _calculateCurrentBalance();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening balance updated!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF805D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _generateCashReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cash Report'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportRow('Opening Balance:', '₹${_openingBalance.toStringAsFixed(2)}'),
              _buildReportRow('Total Income:', '₹${_totalIncome.toStringAsFixed(2)}'),
              _buildReportRow('Total Expenses:', '₹${_totalExpenses.toStringAsFixed(2)}'),
              const Divider(),
              _buildReportRow('Current Balance:', '₹${_currentBalance.toStringAsFixed(2)}', isTotal: true),
              const SizedBox(height: 16),
              const Text('Recent Transactions:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._transactions.take(5).map((transaction) => ListTile(
                dense: true,
                leading: Icon(
                  transaction['type'] == 'income' ? Icons.add_circle : Icons.remove_circle,
                  color: transaction['type'] == 'income' ? const Color(0xFF10B981) : const Color(0xFFE91E63),
                  size: 20,
                ),
                title: Text(transaction['description'], style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  '₹${transaction['amount']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: transaction['type'] == 'income' ? const Color(0xFF10B981) : const Color(0xFFE91E63),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report exported successfully!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5777B5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 16 : 14,
                color: isTotal ? const Color(0xFF26344F) : null,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 400;
          final isTablet = screenWidth > 600;
          
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 800 : double.infinity,
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildBalanceCards(),
                  _buildQuickActions(),
                  Expanded(child: _buildTransactionHistory()),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
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
                  'Cash Management',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              IconButton(
                onPressed: _generateCashReport,
                icon: const Icon(Icons.assessment, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildBalanceCard(
              'Current Balance',
              '₹${_currentBalance.toStringAsFixed(0)}',
              _currentBalance >= 0 ? const Color(0xFF10B981) : const Color(0xFFE91E63),
              Icons.account_balance_wallet,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildBalanceCard(
              'Total Income',
              '₹${_totalIncome.toStringAsFixed(0)}',
              const Color(0xFF10B981),
              Icons.trending_up,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildBalanceCard(
              'Total Expenses',
              '₹${_totalExpenses.toStringAsFixed(0)}',
              const Color(0xFFE91E63),
              Icons.trending_down,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, String value, Color color, IconData icon) {
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showSetOpeningBalanceDialog,
              icon: const Icon(Icons.settings, size: 20),
              label: const Text('Set Opening Balance'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5777B5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _generateCashReport,
              icon: const Icon(Icons.file_download, size: 20),
              label: const Text('Export Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26344F),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return _buildTransactionCard(transaction);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isIncome = transaction['type'] == 'income';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isIncome ? const Color(0xFF10B981) : const Color(0xFFE91E63)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isIncome ? Icons.add_circle : Icons.remove_circle,
            color: isIncome ? const Color(0xFF10B981) : const Color(0xFFE91E63),
          ),
        ),
        title: Text(
          transaction['description'],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF26344F),
          ),
        ),
        subtitle: Text(
          '${transaction['category']} • ${transaction['time']}',
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}₹${transaction['amount']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? const Color(0xFF10B981) : const Color(0xFFE91E63),
              ),
            ),
            Text(
              transaction['date'],
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}