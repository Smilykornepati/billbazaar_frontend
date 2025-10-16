import 'package:flutter/material.dart';
import '../../../widgets/responsive_dialog.dart';

class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  String _selectedPrinter = 'POS Printer TM-T20';
  String _paperSize = '80mm';
  int _printDensity = 5;
  bool _autoCutEnabled = true;
  bool _soundEnabled = true;
  int _copies = 1;
  
  final List<Map<String, dynamic>> _availablePrinters = [
    {
      'name': 'POS Printer TM-T20',
      'model': 'Epson TM-T20',
      'connection': 'Bluetooth',
      'status': 'Connected',
      'paperWidth': '80mm',
      'isDefault': true,
    },
    {
      'name': 'Thermal Printer 58mm',
      'model': 'Generic 58mm',
      'connection': 'USB',
      'status': 'Offline',
      'paperWidth': '58mm',
      'isDefault': false,
    },
    {
      'name': 'Mobile Printer',
      'model': 'Portable 80mm',
      'connection': 'WiFi',
      'status': 'Ready',
      'paperWidth': '80mm',
      'isDefault': false,
    },
  ];

  final List<String> _paperSizes = ['58mm', '80mm', '110mm'];
  final List<String> _connectionTypes = ['Bluetooth', 'USB', 'WiFi', 'Ethernet'];

  void _testPrint() {
    showResponsiveDialog(
      context: context,
      child: ResponsiveDialog(
        title: 'Test Print',
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.print,
              size: 48,
              color: Color(0xFF5777B5),
            ),
            SizedBox(height: 16),
            Text(
              'Print a test receipt to verify printer settings?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF26344F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ResponsiveDialogButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            icon: Icons.close,
          ),
          ResponsiveDialogButton(
            text: 'Print Test',
            isPrimary: true,
            icon: Icons.print,
            color: const Color(0xFFFF805D),
            onPressed: () {
              Navigator.pop(context);
              _performTestPrint();
            },
          ),
        ],
      ),
    );
  }

  void _performTestPrint() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Printing test receipt...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test print completed successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    });
  }

  void _addNewPrinter() {
    final nameController = TextEditingController();
    final modelController = TextEditingController();
    String selectedConnection = 'Bluetooth';
    String selectedPaperWidth = '80mm';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Printer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Printer Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: 'Model'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedConnection,
                  decoration: const InputDecoration(labelText: 'Connection Type'),
                  items: _connectionTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedConnection = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPaperWidth,
                  decoration: const InputDecoration(labelText: 'Paper Width'),
                  items: _paperSizes.map((size) {
                    return DropdownMenuItem(value: size, child: Text(size));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaperWidth = value!;
                    });
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
                if (nameController.text.isNotEmpty && modelController.text.isNotEmpty) {
                  this.setState(() {
                    _availablePrinters.add({
                      'name': nameController.text,
                      'model': modelController.text,
                      'connection': selectedConnection,
                      'status': 'Ready',
                      'paperWidth': selectedPaperWidth,
                      'isDefault': false,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Printer added successfully!'),
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

  void _setDefaultPrinter(String printerName) {
    setState(() {
      for (var printer in _availablePrinters) {
        printer['isDefault'] = printer['name'] == printerName;
      }
      _selectedPrinter = printerName;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$printerName set as default printer'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _removePrinter(String printerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Printer'),
        content: Text('Are you sure you want to remove $printerName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _availablePrinters.removeWhere((printer) => printer['name'] == printerName);
                if (_selectedPrinter == printerName && _availablePrinters.isNotEmpty) {
                  _selectedPrinter = _availablePrinters.first['name'];
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$printerName removed'),
                  backgroundColor: const Color(0xFF6B7280),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return const Color(0xFF10B981);
      case 'ready':
        return const Color(0xFF5777B5);
      case 'offline':
        return const Color(0xFFE91E63);
      case 'error':
        return const Color(0xFFFF805D);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCurrentPrinterStatus(),
                    _buildPrintSettings(),
                    _buildAvailablePrinters(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPrinter,
        backgroundColor: const Color(0xFFFF805D),
        child: const Icon(Icons.add, color: Colors.white),
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
                isSmallScreen ? 18 : 24
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
                      'Printer Settings',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: _testPrint,
                    icon: Icon(
                      Icons.print, 
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentPrinterStatus() {
    final currentPrinter = _availablePrinters.firstWhere(
      (printer) => printer['name'] == _selectedPrinter,
      orElse: () => _availablePrinters.first,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Container(
          margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(currentPrinter['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.print,
                      color: _getStatusColor(currentPrinter['status']),
                      size: isSmallScreen ? 28 : 32,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Printer',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 12,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          currentPrinter['name'],
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF26344F),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currentPrinter['model'],
                          style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 12, 
                      vertical: isSmallScreen ? 4 : 6
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(currentPrinter['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      currentPrinter['status'],
                      style: TextStyle(
                        color: _getStatusColor(currentPrinter['status']),
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 10 : 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _testPrint,
                      icon: Icon(
                        Icons.print_outlined, 
                        size: isSmallScreen ? 18 : 20
                      ),
                      label: Text(
                        'Test Print',
                        style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5777B5),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 10 : 12
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checking printer status...'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.refresh, 
                        size: isSmallScreen ? 18 : 20
                      ),
                      label: Text(
                        'Refresh',
                        style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF805D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 10 : 12
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrintSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Print Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Paper Size
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Paper Size',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      DropdownButton<String>(
                        value: _paperSize,
                        items: _paperSizes.map((size) {
                          return DropdownMenuItem(value: size, child: Text(size));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _paperSize = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  // Print Density
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Print Density',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text('$_printDensity'),
                        ],
                      ),
                      Slider(
                        value: _printDensity.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: const Color(0xFFFF805D),
                        onChanged: (value) {
                          setState(() {
                            _printDensity = value.round();
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  // Number of Copies
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Number of Copies',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _copies > 1 ? () {
                              setState(() {
                                _copies--;
                              });
                            } : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text('$_copies'),
                          IconButton(
                            onPressed: _copies < 5 ? () {
                              setState(() {
                                _copies++;
                              });
                            } : null,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  // Auto Cut
                  SwitchListTile(
                    title: const Text('Auto Cut Paper'),
                    subtitle: const Text('Automatically cut paper after printing'),
                    value: _autoCutEnabled,
                    activeColor: const Color(0xFFFF805D),
                    onChanged: (value) {
                      setState(() {
                        _autoCutEnabled = value;
                      });
                    },
                  ),
                  
                  // Sound
                  SwitchListTile(
                    title: const Text('Print Sound'),
                    subtitle: const Text('Play sound when printing'),
                    value: _soundEnabled,
                    activeColor: const Color(0xFFFF805D),
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePrinters() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Printers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _availablePrinters.length,
            itemBuilder: (context, index) {
              final printer = _availablePrinters[index];
              return _buildPrinterCard(printer);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrinterCard(Map<String, dynamic> printer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(printer['status']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.print,
            color: _getStatusColor(printer['status']),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                printer['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF26344F),
                ),
              ),
            ),
            if (printer['isDefault'])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${printer['model']} • ${printer['connection']}'),
            Text('Paper: ${printer['paperWidth']}'),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: _getStatusColor(printer['status']),
                ),
                const SizedBox(width: 4),
                Text(
                  printer['status'],
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(printer['status']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'set_default':
                _setDefaultPrinter(printer['name']);
                break;
              case 'test_print':
                _testPrint();
                break;
              case 'remove':
                _removePrinter(printer['name']);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!printer['isDefault'])
              const PopupMenuItem(
                value: 'set_default',
                child: Row(
                  children: [
                    Icon(Icons.star, size: 16),
                    SizedBox(width: 8),
                    Text('Set as Default'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'test_print',
              child: Row(
                children: [
                  Icon(Icons.print, size: 16),
                  SizedBox(width: 8),
                  Text('Test Print'),
                ],
              ),
            ),
            if (!printer['isDefault'])
              const PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16),
                    SizedBox(width: 8),
                    Text('Remove'),
                  ],
                ),
              ),
          ],
        ),
        onTap: () {
          setState(() {
            _selectedPrinter = printer['name'];
          });
        },
      ),
    );
  }
}