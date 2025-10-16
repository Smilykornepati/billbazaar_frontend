import 'package:flutter/material.dart';
import '../../../widgets/responsive_dialog.dart';

class BusinessCardMakerScreen extends StatefulWidget {
  const BusinessCardMakerScreen({super.key});

  @override
  State<BusinessCardMakerScreen> createState() => _BusinessCardMakerScreenState();
}

class _BusinessCardMakerScreenState extends State<BusinessCardMakerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedTemplate = 'Template 1';
  Color _primaryColor = const Color(0xFF5777B5);

  final List<String> _templates = [
    'Template 1',
    'Template 2', 
    'Template 3',
    'Template 4',
    'Template 5',
  ];

  final List<Color> _colorOptions = [
    const Color(0xFF5777B5),
    const Color(0xFFFF805D),
    const Color(0xFF10B981),
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF2196F3),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
  ];

  final List<Map<String, dynamic>> _savedCards = [
    {
      'id': 1,
      'name': 'John Doe',
      'title': 'Store Manager',
      'company': 'A to Z Store',
      'template': 'Template 1',
      'date': '2025-01-14',
    },
    {
      'id': 2,
      'name': 'Sarah Smith',
      'title': 'Sales Executive',
      'company': 'BillBazar Solutions',
      'template': 'Template 2',
      'date': '2025-01-13',
    },
  ];

  void _saveCard() {
    if (_nameController.text.isNotEmpty && _companyController.text.isNotEmpty) {
      setState(() {
        _savedCards.insert(0, {
          'id': _savedCards.length + 1,
          'name': _nameController.text,
          'title': _titleController.text,
          'company': _companyController.text,
          'template': _selectedTemplate,
          'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Business card saved successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least name and company'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
    }
  }

  void _printCard() {
    if (_nameController.text.isNotEmpty) {
      showResponsiveDialog(
        context: context,
        child: ResponsiveDialog(
          title: 'Print Business Card',
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
                'Send business card to printer?',
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
                    content: Text('Business card sent to printer!'),
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

  void _exportCard() {
    if (_nameController.text.isNotEmpty) {
      showResponsiveDialog(
        context: context,
        child: ResponsiveDialog(
          title: 'Export Business Card',
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
                      content: Text('Business card exported as PNG!'),
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
                      content: Text('Business card exported as PDF!'),
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
    _nameController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
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
                    _buildCardEditor(),
                    _buildCardPreview(),
                    _buildActionButtons(),
                    _buildSavedCards(),
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
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Business Card Maker',
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Templates & Help'),
                      backgroundColor: Color(0xFF5777B5),
                    ),
                  );
                },
                icon: const Icon(Icons.palette, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardEditor() {
    return Container(
      margin: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'e.g., John Doe',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Job Title',
              hintText: 'e.g., Store Manager',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Company Name *',
              hintText: 'e.g., A to Z Store',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: '+91 98765 43210',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'john@example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _websiteController,
            decoration: const InputDecoration(
              labelText: 'Website',
              hintText: 'www.example.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: '123 Business Street, City',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            maxLines: 2,
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Card Preview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26344F),
                ),
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedTemplate,
                    items: _templates.map((template) {
                      return DropdownMenuItem(value: template, child: Text(template));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTemplate = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildCardTemplate(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Colors: '),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colorOptions.length,
                    itemBuilder: (context, index) {
                      final color = _colorOptions[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _primaryColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _primaryColor == color
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardTemplate() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryColor,
            _primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _nameController.text.isNotEmpty ? _nameController.text : 'Your Name',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _titleController.text.isNotEmpty ? _titleController.text : 'Your Title',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _companyController.text.isNotEmpty ? _companyController.text : 'Your Company',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                _phoneController.text.isNotEmpty ? _phoneController.text : '+91 98765 43210',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.email, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                _emailController.text.isNotEmpty ? _emailController.text : 'email@example.com',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
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
                  onPressed: _saveCard,
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text('Save Card'),
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
                  onPressed: _printCard,
                  icon: const Icon(Icons.print, size: 20),
                  label: const Text('Print'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _exportCard,
              icon: const Icon(Icons.file_download, size: 20),
              label: const Text('Export Card'),
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

  Widget _buildSavedCards() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saved Business Cards',
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
            itemCount: _savedCards.length,
            itemBuilder: (context, index) {
              final card = _savedCards[index];
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
                      Icons.business_center,
                      color: Color(0xFF5777B5),
                    ),
                  ),
                  title: Text(
                    card['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26344F),
                    ),
                  ),
                  subtitle: Text('${card['title']} • ${card['company']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _nameController.text = card['name'];
                            _titleController.text = card['title'];
                            _companyController.text = card['company'];
                            _selectedTemplate = card['template'];
                          });
                        },
                        icon: const Icon(Icons.edit, color: Color(0xFF5777B5)),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _savedCards.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Business card deleted'),
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