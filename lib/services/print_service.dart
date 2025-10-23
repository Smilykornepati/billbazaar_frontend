import 'package:flutter/material.dart';

class PrintService {
  static PrintService? _instance;
  PrintService._internal();
  
  static PrintService get instance {
    _instance ??= PrintService._internal();
    return _instance!;
  }

  // Simulated printer settings
  String _selectedPrinter = 'POS Printer TM-T20';
  String _paperSize = '80mm';
  bool _autoCutEnabled = true;
  bool _soundEnabled = true;
  int _copies = 1;

  // Available printers (simulated)
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

  // Getters
  String get selectedPrinter => _selectedPrinter;
  String get paperSize => _paperSize;
  bool get autoCutEnabled => _autoCutEnabled;
  bool get soundEnabled => _soundEnabled;
  int get copies => _copies;
  List<Map<String, dynamic>> get availablePrinters => _availablePrinters;

  // Setters
  void setSelectedPrinter(String printer) => _selectedPrinter = printer;
  void setPaperSize(String size) => _paperSize = size;
  void setAutoCut(bool enabled) => _autoCutEnabled = enabled;
  void setSound(bool enabled) => _soundEnabled = enabled;
  void setCopies(int count) => _copies = count;

  // Main print method for bills
  Future<bool> printBill({
    required String customerName,
    required String phoneNumber,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double gstAmount,
    required double discount,
    required double total,
    required String paymentMethod,
    String businessName = 'BillBazar Store',
    String businessAddress = '123 Business Street, City',
    String businessPhone = '+91 9876543210',
    String gstNumber = 'GST123456789',
    String? logoPath, // Optional logo path
  }) async {
    try {
      // Simulate printing delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check if printer is available
      final printer = _availablePrinters.firstWhere(
        (p) => p['name'] == _selectedPrinter,
        orElse: () => {},
      );

      if (printer.isEmpty || printer['status'] != 'Connected') {
        throw Exception('Printer not available or not connected');
      }

      // Generate receipt content
      final receiptContent = _generateReceiptContent(
        customerName: customerName,
        phoneNumber: phoneNumber,
        items: items,
        subtotal: subtotal,
        gstAmount: gstAmount,
        discount: discount,
        total: total,
        paymentMethod: paymentMethod,
        businessName: businessName,
        businessAddress: businessAddress,
        businessPhone: businessPhone,
        gstNumber: gstNumber,
        logoPath: logoPath,
      );

      // Log the print job (in a real app, this would send to printer)
      debugPrint('=== PRINTING RECEIPT ===');
      debugPrint('Printer: $_selectedPrinter');
      debugPrint('Paper Size: $_paperSize');
      debugPrint('Auto Cut: $_autoCutEnabled');
      debugPrint('Copies: $_copies');
      debugPrint('Content:');
      debugPrint(receiptContent);
      debugPrint('========================');

      // Print multiple copies if needed
      for (int i = 0; i < _copies; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('Printing copy ${i + 1} of $_copies');
      }

      return true;
    } catch (e) {
      debugPrint('Print error: $e');
      return false;
    }
  }

  // Generate formatted receipt content
  String _generateReceiptContent({
    required String customerName,
    required String phoneNumber,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double gstAmount,
    required double discount,
    required double total,
    required String paymentMethod,
    required String businessName,
    required String businessAddress,
    required String businessPhone,
    required String gstNumber,
    String? logoPath,
  }) {
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final receiptNo = 'R${now.millisecondsSinceEpoch.toString().substring(8)}';

    final width = _paperSize == '58mm' ? 32 : 48;
    final separator = '=' * width;

    final buffer = StringBuffer();

    // Header with Logo
    if (logoPath != null && logoPath.isNotEmpty) {
      buffer.writeln(_centerText('[LOGO: $logoPath]', width));
      buffer.writeln('');
    }
    buffer.writeln(_centerText(businessName, width));
    buffer.writeln(_centerText(businessAddress, width));
    buffer.writeln(_centerText('Phone: $businessPhone', width));
    buffer.writeln(_centerText('GST: $gstNumber', width));
    buffer.writeln(separator);

    // Receipt info
    buffer.writeln('Receipt No: $receiptNo');
    buffer.writeln('Date: $dateStr Time: $timeStr');
    buffer.writeln('Customer: $customerName');
    if (phoneNumber.isNotEmpty) {
      buffer.writeln('Phone: $phoneNumber');
    }
    buffer.writeln(separator);

    // Items
    buffer.writeln(_formatLine('Item', 'Qty', 'Rate', 'Amount', width));
    buffer.writeln('-' * width);
    
    for (final item in items) {
      final name = item['name'].toString();
      final qty = item['quantity'].toString();
      final rate = '₹${item['price']}';
      final amount = '₹${(item['quantity'] * item['price']).toStringAsFixed(2)}';
      
      buffer.writeln(_formatItemLine(name, qty, rate, amount, width));
    }

    buffer.writeln('-' * width);

    // Totals
    buffer.writeln(_formatTotalLine('Subtotal:', '₹${subtotal.toStringAsFixed(2)}', width));
    if (discount > 0) {
      buffer.writeln(_formatTotalLine('Discount:', '-₹${discount.toStringAsFixed(2)}', width));
    }
    if (gstAmount > 0) {
      buffer.writeln(_formatTotalLine('GST (18%):', '₹${gstAmount.toStringAsFixed(2)}', width));
    }
    buffer.writeln(separator);
    buffer.writeln(_formatTotalLine('TOTAL:', '₹${total.toStringAsFixed(2)}', width));
    buffer.writeln(_formatTotalLine('Payment:', paymentMethod, width));
    buffer.writeln(separator);

    // Footer
    buffer.writeln(_centerText('Thank you for your business!', width));
    buffer.writeln(_centerText('Visit again soon', width));
    buffer.writeln('');
    buffer.writeln('Powered by BillBazar');

    return buffer.toString();
  }

  String _centerText(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    final padding = (width - text.length) ~/ 2;
    return ' ' * padding + text;
  }

  String _formatLine(String col1, String col2, String col3, String col4, int width) {
    if (width <= 32) {
      // For 58mm paper, use simpler format
      return '$col1 $col2 $col3 $col4';
    } else {
      // For 80mm paper, use formatted columns
      return '${col1.padRight(12)} ${col2.padLeft(3)} ${col3.padLeft(8)} ${col4.padLeft(10)}';
    }
  }

  String _formatItemLine(String name, String qty, String rate, String amount, int width) {
    if (width <= 32) {
      // For 58mm paper
      return '$name\n  $qty x $rate = $amount';
    } else {
      // For 80mm paper
      final truncatedName = name.length > 12 ? '${name.substring(0, 9)}...' : name;
      return '${truncatedName.padRight(12)} ${qty.padLeft(3)} ${rate.padLeft(8)} ${amount.padLeft(10)}';
    }
  }

  String _formatTotalLine(String label, String value, int width) {
    final totalWidth = width - 2;
    final labelWidth = totalWidth - value.length;
    return '${label.padRight(labelWidth)}${value.padLeft(value.length)}';
  }

  // Test print method
  Future<bool> printTest() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      debugPrint('=== TEST PRINT ===');
      debugPrint('Printer: $_selectedPrinter');
      debugPrint('Paper Size: $_paperSize');
      debugPrint('Status: Print test successful');
      debugPrint('==================');
      
      return true;
    } catch (e) {
      debugPrint('Test print error: $e');
      return false;
    }
  }

  // Check printer connection
  Future<bool> checkPrinterConnection() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final printer = _availablePrinters.firstWhere(
      (p) => p['name'] == _selectedPrinter,
      orElse: () => {},
    );

    return printer.isNotEmpty && printer['status'] == 'Connected';
  }

  // Get printer status
  String getPrinterStatus() {
    final printer = _availablePrinters.firstWhere(
      (p) => p['name'] == _selectedPrinter,
      orElse: () => {'status': 'Unknown'},
    );
    
    return printer['status'] ?? 'Unknown';
  }
}