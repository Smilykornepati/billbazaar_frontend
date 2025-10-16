import 'package:flutter/material.dart';
import '../../../widgets/responsive_dialog.dart';

class BarcodeMakerScreen extends StatefulWidget {
  const BarcodeMakerScreen({super.key});

  @override
  State<BarcodeMakerScreen> createState() => _BarcodeMakerScreenState();
}

class _BarcodeMakerScreenState extends State<BarcodeMakerScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedBarcodeType = 'Code128';
  double _barcodeWidth = 2.0;
  double _barcodeHeight = 100.0;
  bool _showText = true;
  String _generatedBarcode = '';

  final List<String> _barcodeTypes = [
    'Code128',
    'Code39',
    'EAN13',
    'EAN8',
    'UPC-A',
    'UPC-E',
    'QR Code',
    'Data Matrix',
  ];

  final List<Map<String, dynamic>> _savedBarcodes = [
    {
      'id': 1,
      'text': 'BILL001',
      'type': 'Code128',
      'date': '2025-01-14',
      'isActive': true,
    },
    {
      'id': 2,
      'text': 'PROD12345',
      'type': 'Code39',
      'date': '2025-01-13',
      'isActive': true,
    },
    {
      'id': 3,
      'text': 'https://billbazar.com',
      'type': 'QR Code',
      'date': '2025-01-12',
      'isActive': false,
    },
  ];

  void _generateBarcode() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _generatedBarcode = _textController.text;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barcode generated successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter text to generate barcode'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
    }
  }

  void _saveBarcode() {
    if (_generatedBarcode.isNotEmpty) {
      setState(() {
        _savedBarcodes.insert(0, {
          'id': _savedBarcodes.length + 1,
          'text': _generatedBarcode,
          'type': _selectedBarcodeType,
          'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
          'isActive': true,
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barcode saved to library!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _printBarcode() {
    if (_generatedBarcode.isNotEmpty) {
      showResponsiveDialog(
        context: context,
        child: ResponsiveDialog(
          title: 'Print Barcode',
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
                'Send barcode to printer?',
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
              text: 'Print',
              isPrimary: true,
              icon: Icons.print,
              color: const Color(0xFFFF805D),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Barcode sent to printer!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  void _exportBarcode() {
    if (_generatedBarcode.isNotEmpty) {
      showResponsiveDialog(
        context: context,
        child: ResponsiveDialog(
          title: 'Export Barcode',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExportOption(
                icon: Icons.image,
                title: 'Export as PNG',
                subtitle: 'High quality image format',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Barcode exported as PNG!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildExportOption(
                icon: Icons.picture_as_pdf,
                title: 'Export as PDF',
                subtitle: 'Printable document format',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Barcode exported as PDF!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            ResponsiveDialogButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
              icon: Icons.close,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF5777B5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF5777B5),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF26344F),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
                    _buildBarcodeGenerator(),
                    _buildBarcodePreview(),
                    _buildActionButtons(),
                    _buildSavedBarcodes(),
                  ],
                ),
              ),
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
                isSmallScreen ? 18 : 24
              ),
              child: Row(
                children: [
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Expanded(
                    child: Text(
                      'Barcode Maker',
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Help & Tutorial'),
                          backgroundColor: Color(0xFF5777B5),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.help_outline, 
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

  Widget _buildBarcodeGenerator() {
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
              Text(
                'Generate Barcode',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF26344F),
                ),
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter text or number',
                  hintText: 'e.g., PROD12345 or 1234567890',
                  labelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                  hintStyle: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              DropdownButtonFormField<String>(
                value: _selectedBarcodeType,
                decoration: InputDecoration(
                  labelText: 'Barcode Type',
                  labelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.black,
                ),
                items: _barcodeTypes.map((type) {
                  return DropdownMenuItem(
                    value: type, 
                    child: Text(
                      type,
                      style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBarcodeType = value!;
                  });
                },
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              isSmallScreen 
                ? Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Width: ${_barcodeWidth.toInt()}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          Slider(
                            value: _barcodeWidth,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            activeColor: const Color(0xFFFF805D),
                            onChanged: (value) {
                              setState(() {
                                _barcodeWidth = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Height: ${_barcodeHeight.toInt()}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          Slider(
                            value: _barcodeHeight,
                            min: 50,
                            max: 200,
                            divisions: 6,
                            activeColor: const Color(0xFFFF805D),
                            onChanged: (value) {
                              setState(() {
                                _barcodeHeight = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Width: ${_barcodeWidth.toInt()}'),
                            Slider(
                              value: _barcodeWidth,
                              min: 1,
                              max: 5,
                              divisions: 4,
                              activeColor: const Color(0xFFFF805D),
                              onChanged: (value) {
                                setState(() {
                                  _barcodeWidth = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Height: ${_barcodeHeight.toInt()}'),
                            Slider(
                              value: _barcodeHeight,
                              min: 50,
                              max: 200,
                              divisions: 6,
                              activeColor: const Color(0xFFFF805D),
                              onChanged: (value) {
                                setState(() {
                                  _barcodeHeight = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              SwitchListTile(
                title: Text(
                  'Show Text Below Barcode',
                  style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                ),
                value: _showText,
                activeColor: const Color(0xFFFF805D),
                onChanged: (value) {
                  setState(() {
                    _showText = value;
                  });
                },
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              isSmallScreen
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _generateBarcode,
                          icon: const Icon(Icons.qr_code, size: 18),
                          label: const Text(
                            'Generate Barcode',
                            style: TextStyle(fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF805D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _generatedBarcode.isNotEmpty ? _saveBarcode : null,
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text(
                            'Save Barcode',
                            style: TextStyle(fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _generateBarcode,
                          icon: const Icon(Icons.qr_code, size: 20),
                          label: const Text('Generate Barcode'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF805D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _generatedBarcode.isNotEmpty ? _saveBarcode : null,
                          icon: const Icon(Icons.save, size: 20),
                          label: const Text('Save Barcode'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildBarcodePreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          const Text(
            'Barcode Preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: _barcodeHeight + 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _generatedBarcode.isEmpty
                ? const Center(
                    child: Text(
                      'Enter text and tap Generate to preview barcode',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Simulated barcode representation
                      Container(
                        width: 200,
                        height: _barcodeHeight,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CustomPaint(
                          painter: BarcodePainter(),
                        ),
                      ),
                      if (_showText) ...[
                        const SizedBox(height: 8),
                        Text(
                          _generatedBarcode,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _generateBarcode,
                  icon: const Icon(Icons.qr_code_2, size: 20),
                  label: const Text('Generate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF805D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _generatedBarcode.isNotEmpty ? _saveBarcode : null,
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5777B5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _generatedBarcode.isNotEmpty ? _printBarcode : null,
                  icon: const Icon(Icons.print, size: 20),
                  label: const Text('Print'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _generatedBarcode.isNotEmpty ? _exportBarcode : null,
                  icon: const Icon(Icons.file_download, size: 20),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B7280),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedBarcodes() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saved Barcodes',
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
            itemCount: _savedBarcodes.length,
            itemBuilder: (context, index) {
              final barcode = _savedBarcodes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5777B5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.qr_code,
                      color: Color(0xFF5777B5),
                    ),
                  ),
                  title: Text(
                    barcode['text'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26344F),
                    ),
                  ),
                  subtitle: Text('${barcode['type']} • ${barcode['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _textController.text = barcode['text'];
                            _selectedBarcodeType = barcode['type'];
                            _generatedBarcode = barcode['text'];
                          });
                        },
                        icon: const Icon(Icons.edit, color: Color(0xFF5777B5)),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _savedBarcodes.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Barcode deleted'),
                              backgroundColor: Color(0xFF6B7280),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete, color: Color(0xFFE91E63)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    // Draw simple barcode pattern
    for (int i = 0; i < size.width; i += 3) {
      if (i % 6 == 0) {
        canvas.drawLine(
          Offset(i.toDouble(), 0),
          Offset(i.toDouble(), size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}