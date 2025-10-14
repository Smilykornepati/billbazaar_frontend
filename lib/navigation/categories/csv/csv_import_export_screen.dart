import 'package:flutter/material.dart';

class CsvImportExportScreen extends StatefulWidget {
  final String type; // 'products' or 'customers'
  
  const CsvImportExportScreen({
    super.key,
    this.type = 'products', // Default to products
  });

  @override
  State<CsvImportExportScreen> createState() => _CsvImportExportScreenState();
}

class _CsvImportExportScreenState extends State<CsvImportExportScreen> {
  bool _isLoading = false;
  String? _selectedFile;
  
  // Sample data for demonstration
  final List<Map<String, dynamic>> _sampleProductData = [
    {
      'name': 'Sample Product 1',
      'category': 'Electronics',
      'price': '999.00',
      'stock': '50',
      'gst': '18%',
    },
    {
      'name': 'Sample Product 2', 
      'category': 'Clothing',
      'price': '599.00',
      'stock': '25',
      'gst': '12%',
    },
  ];

  final List<Map<String, dynamic>> _sampleCustomerData = [
    {
      'name': 'John Doe',
      'contact': '+91 9876543210',
      'address': '123 Main Street, City',
      'email': 'john@example.com',
    },
    {
      'name': 'Jane Smith',
      'contact': '+91 9876543211', 
      'address': '456 Oak Avenue, Town',
      'email': 'jane@example.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isProducts = widget.type == 'products';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isProducts),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildImportSection(isProducts),
                      const SizedBox(height: 20),
                      _buildExportSection(isProducts),
                      const SizedBox(height: 20),
                      _buildSampleDataSection(isProducts),
                      const SizedBox(height: 20),
                      _buildInstructionsSection(isProducts),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isProducts) {
    return Container(
      height: 100.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5777B5),
            Color(0xFF26344F),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
        child: Row(
          children: [
            // Back arrow
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                'CSV ${isProducts ? 'Products' : 'Customers'}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportSection(bool isProducts) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.file_upload,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Import CSV File',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // File selector
          GestureDetector(
            onTap: _selectFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF7FAFC),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _selectedFile ?? 'Click to select CSV file',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _selectedFile != null 
                          ? const Color(0xFF1F2937)
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Supports .csv files only',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Import button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _selectedFile != null ? _importFile : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Import Data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(bool isProducts) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.file_download,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Export CSV File',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Text(
            'Export your current ${isProducts ? 'products' : 'customers'} data to a CSV file for backup or external use.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Export options
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _exportFile(false),
                  icon: const Icon(Icons.list_alt, size: 18),
                  label: const Text('All Data'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _exportFile(true),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filtered'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSampleDataSection(bool isProducts) {
    final sampleData = isProducts ? _sampleProductData : _sampleCustomerData;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF805D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.preview,
                  color: Color(0xFFFF805D),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Sample Data Preview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Sample data table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: sampleData.first.keys.map((key) {
                      return Expanded(
                        child: Text(
                          key.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Data rows
                ...sampleData.take(2).map((row) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: row.values.map((value) {
                        return Expanded(
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Download template button
          OutlinedButton.icon(
            onPressed: _downloadTemplate,
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Download Template'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF805D),
              side: const BorderSide(color: Color(0xFFFF805D)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection(bool isProducts) {
    final instructions = isProducts
        ? [
            '1. Download the CSV template or create a file with columns: Name, Category, Price, Stock, GST',
            '2. Fill in your product data following the sample format',
            '3. Save the file as .csv format',
            '4. Use the import section above to upload your file',
            '5. Review the imported data before finalizing',
          ]
        : [
            '1. Download the CSV template or create a file with columns: Name, Contact, Address, Email',
            '2. Fill in your customer data following the sample format', 
            '3. Save the file as .csv format',
            '4. Use the import section above to upload your file',
            '5. Review the imported data before finalizing',
          ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'How to Import Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          ...instructions.map((instruction) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                instruction,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  height: 1.5,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _selectFile() {
    // Simulate file selection
    setState(() {
      _selectedFile = 'sample_${widget.type}.csv';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${_selectedFile}'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _importFile() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate import process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _selectedFile = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully imported ${widget.type} data!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  void _exportFile(bool filtered) {
    final type = filtered ? 'filtered' : 'all';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting $type ${widget.type} data...'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  void _downloadTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloaded ${widget.type} template!'),
        backgroundColor: const Color(0xFFFF805D),
      ),
    );
  }
}