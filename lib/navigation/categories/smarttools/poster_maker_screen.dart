import 'package:flutter/material.dart';

class PosterMakerScreen extends StatefulWidget {
  const PosterMakerScreen({super.key});

  @override
  State<PosterMakerScreen> createState() => _PosterMakerScreenState();
}

class _PosterMakerScreenState extends State<PosterMakerScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _selectedTemplate = 'Sale Poster';
  String _selectedSize = 'A4 (210x297mm)';
  Color _primaryColor = const Color(0xFFFF805D);
  Color _backgroundColor = Colors.white;
  String _selectedFont = 'Bold';

  final List<String> _templates = [
    'Sale Poster',
    'Product Launch',
    'Event Announcement',
    'Special Offer',
    'Grand Opening',
    'Custom Design',
  ];

  final List<String> _sizes = [
    'A4 (210x297mm)',
    'A3 (297x420mm)',
    'A5 (148x210mm)',
    'Letter (216x279mm)',
    'Legal (216x356mm)',
    'Banner (914x610mm)',
  ];

  final List<String> _fonts = [
    'Bold',
    'Regular',
    'Light',
    'Extra Bold',
  ];

  final List<Color> _colorOptions = [
    const Color(0xFFFF805D),
    const Color(0xFF5777B5),
    const Color(0xFF10B981),
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF2196F3),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
  ];

  final List<Map<String, dynamic>> _savedPosters = [
    {
      'id': 1,
      'title': 'Grand Sale',
      'subtitle': 'Up to 50% Off',
      'template': 'Sale Poster',
      'size': 'A4 (210x297mm)',
      'date': '2025-01-14',
    },
    {
      'id': 2,
      'title': 'New Store Opening',
      'subtitle': 'Special Discounts',
      'template': 'Grand Opening',
      'size': 'A3 (297x420mm)',
      'date': '2025-01-13',
    },
  ];

  void _savePoster() {
    if (_titleController.text.isNotEmpty) {
      setState(() {
        _savedPosters.insert(0, {
          'id': _savedPosters.length + 1,
          'title': _titleController.text,
          'subtitle': _subtitleController.text,
          'template': _selectedTemplate,
          'size': _selectedSize,
          'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poster saved successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for the poster'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
    }
  }

  void _printPoster() {
    if (_titleController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Print Poster'),
          content: Text('Print poster in ${_selectedSize}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Poster sent to printer!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                foregroundColor: Colors.white,
              ),
              child: const Text('Print'),
            ),
          ],
        ),
      );
    }
  }

  void _exportPoster() {
    if (_titleController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Poster'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Export as High-Quality PNG'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Poster exported as PNG!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Export as PDF'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Poster exported as PDF!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text('Export as JPEG'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Poster exported as JPEG!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _contactController.dispose();
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
                    _buildPosterEditor(),
                    _buildPosterPreview(),
                    _buildActionButtons(),
                    _buildSavedPosters(),
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Poster Maker',
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
                      content: Text('Design Templates'),
                      backgroundColor: Color(0xFF5777B5),
                    ),
                  );
                },
                icon: const Icon(Icons.design_services, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterEditor() {
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
            'Poster Content',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedTemplate,
                  decoration: const InputDecoration(
                    labelText: 'Template',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  items: _templates.map((template) {
                    return DropdownMenuItem(value: template, child: Text(template));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTemplate = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedSize,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  items: _sizes.map((size) {
                    return DropdownMenuItem(value: size, child: Text(size));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Main Title *',
              hintText: 'e.g., GRAND SALE',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _subtitleController,
            decoration: const InputDecoration(
              labelText: 'Subtitle',
              hintText: 'e.g., Up to 50% OFF',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Add details about your offer...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            maxLines: 3,
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price/Offer',
                    hintText: '₹999 only',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Info',
                    hintText: 'Phone or Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosterPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Poster Preview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26344F),
                ),
              ),
              DropdownButton<String>(
                value: _selectedFont,
                items: _fonts.map((font) {
                  return DropdownMenuItem(value: font, child: Text(font));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: _backgroundColor,
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
            child: _buildPosterTemplate(),
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

  Widget _buildPosterTemplate() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _primaryColor.withOpacity(0.1),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header with title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _titleController.text.isNotEmpty ? _titleController.text.toUpperCase() : 'YOUR TITLE HERE',
              style: TextStyle(
                fontSize: _selectedFont == 'Extra Bold' ? 24 : 20,
                fontWeight: _selectedFont == 'Light' ? FontWeight.w300 : FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          
          // Subtitle
          if (_subtitleController.text.isNotEmpty)
            Text(
              _subtitleController.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          
          const SizedBox(height: 16),
          
          // Description
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_descriptionController.text.isNotEmpty)
                    Text(
                      _descriptionController.text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Price/Offer
                  if (_priceController.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _primaryColor),
                      ),
                      child: Text(
                        _priceController.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Contact info
          if (_contactController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contact_phone, color: _primaryColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _contactController.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: _primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                  onPressed: _savePoster,
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text('Save Poster'),
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
                  onPressed: _printPoster,
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
              onPressed: _exportPoster,
              icon: const Icon(Icons.file_download, size: 20),
              label: const Text('Export Poster'),
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

  Widget _buildSavedPosters() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saved Posters',
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
            itemCount: _savedPosters.length,
            itemBuilder: (context, index) {
              final poster = _savedPosters[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF805D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.campaign,
                      color: Color(0xFFFF805D),
                    ),
                  ),
                  title: Text(
                    poster['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26344F),
                    ),
                  ),
                  subtitle: Text('${poster['template']} • ${poster['size']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _titleController.text = poster['title'];
                            _subtitleController.text = poster['subtitle'];
                            _selectedTemplate = poster['template'];
                            _selectedSize = poster['size'];
                          });
                        },
                        icon: const Icon(Icons.edit, color: Color(0xFF5777B5)),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _savedPosters.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Poster deleted'),
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