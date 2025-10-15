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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(isSmallScreen),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildPosterEditor(isSmallScreen),
                        _buildPosterPreview(isSmallScreen),
                        _buildActionButtons(isSmallScreen),
                        _buildSavedPosters(isSmallScreen),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
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
            isSmallScreen ? 12 : 18,
            isSmallScreen ? 16 : 20,
            isSmallScreen ? 16 : 24,
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
                  'Poster Maker',
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
                      content: Text('Design Templates'),
                      backgroundColor: Color(0xFF5777B5),
                    ),
                  );
                },
                icon: Icon(
                  Icons.design_services,
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
  }

  Widget _buildPosterEditor(bool isSmallScreen) {
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
            'Poster Content',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          
          // Template and Size Selection
          if (isSmallScreen)
            // Vertical layout for small screens
            Column(
              children: [
                _buildDropdown(
                  'Template',
                  _selectedTemplate,
                  _templates,
                  (value) => setState(() => _selectedTemplate = value!),
                  isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                _buildDropdown(
                  'Size',
                  _selectedSize,
                  _sizes,
                  (value) => setState(() => _selectedSize = value!),
                  isSmallScreen,
                ),
              ],
            )
          else
            // Horizontal layout for larger screens
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Template',
                    _selectedTemplate,
                    _templates,
                    (value) => setState(() => _selectedTemplate = value!),
                    isSmallScreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    'Size',
                    _selectedSize,
                    _sizes,
                    (value) => setState(() => _selectedSize = value!),
                    isSmallScreen,
                  ),
                ),
              ],
            ),
          
          SizedBox(height: isSmallScreen ? 12 : 16),
          
          // Text Fields
          _buildTextField('Title', _titleController, isSmallScreen),
          SizedBox(height: isSmallScreen ? 8 : 12),
          _buildTextField('Subtitle', _subtitleController, isSmallScreen),
          SizedBox(height: isSmallScreen ? 8 : 12),
          _buildTextField('Description', _descriptionController, isSmallScreen, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
    bool isSmallScreen,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 8 : 12,
        ),
      ),
      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isSmallScreen, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 8 : 12,
        ),
      ),
    );
  }

  Widget _buildPosterPreview(bool isSmallScreen) {
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
              Text(
                'Live Preview',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF26344F),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6 : 8,
                  vertical: isSmallScreen ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedTemplate,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 9 : 10,
                    fontWeight: FontWeight.w500,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Container(
            width: double.infinity,
            height: isSmallScreen ? 220 : 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundColor,
                  _backgroundColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  if (_titleController.text.isNotEmpty)
                    Text(
                      _titleController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 24,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                        letterSpacing: 1.2,
                      ),
                    )
                  else
                    Text(
                      'YOUR TITLE HERE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 24,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor.withOpacity(0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                  
                  if (_subtitleController.text.isNotEmpty) ...[
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    Text(
                      _subtitleController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF26344F),
                      ),
                    ),
                  ],
                  
                  if (_descriptionController.text.isNotEmpty) ...[
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      _descriptionController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Decorative elements
                  Container(
                    width: isSmallScreen ? 60 : 80,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          
          // Color Picker
          Row(
            children: [
              Text(
                'Colors:',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF26344F),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Color(0xFFFF805D),
                      const Color(0xFF5777B5),
                      const Color(0xFF10B981),
                      const Color(0xFFE91E63),
                      const Color(0xFF9C27B0),
                      const Color(0xFF2196F3),
                      const Color(0xFF4CAF50),
                      const Color(0xFFFF9800),
                    ].map((color) {
                      final isSelected = _primaryColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => _primaryColor = color),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: isSmallScreen ? 24 : 28,
                          height: isSmallScreen ? 24 : 28,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected 
                                ? Border.all(color: Colors.grey[800]!, width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                spreadRadius: isSelected ? 2 : 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        children: [
          // Primary Action Buttons Row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: isSmallScreen ? 48 : 56,
                  child: ElevatedButton.icon(
                    onPressed: _savePoster,
                    icon: Icon(
                      Icons.save,
                      size: isSmallScreen ? 18 : 20,
                    ),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: SizedBox(
                  height: isSmallScreen ? 48 : 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.download, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Downloading poster...'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF5777B5),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.download,
                      size: isSmallScreen ? 18 : 20,
                    ),
                    label: Text(
                      'Download',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5777B5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          
          // Secondary Action Buttons Row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: isSmallScreen ? 44 : 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sharing poster...'),
                          backgroundColor: Color(0xFFFF9800),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.share,
                      size: isSmallScreen ? 16 : 18,
                    ),
                    label: Text(
                      'Share',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9800),
                      side: const BorderSide(color: Color(0xFFFF9800)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: SizedBox(
                  height: isSmallScreen ? 44 : 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _titleController.clear();
                        _subtitleController.clear();
                        _descriptionController.clear();
                        _selectedTemplate = 'Sale Poster';
                        _selectedSize = 'A4 (210x297mm)';
                        _primaryColor = const Color(0xFFFF805D);
                        _backgroundColor = Colors.white;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Poster reset successfully'),
                          backgroundColor: Color(0xFFE91E63),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.refresh,
                      size: isSmallScreen ? 16 : 18,
                    ),
                    label: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE91E63),
                      side: const BorderSide(color: Color(0xFFE91E63)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPosters(bool isSmallScreen) {
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
            'Saved Posters',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          ..._savedPosters.map((poster) => _buildPosterCard(poster, isSmallScreen)),
        ],
      ),
    );
  }

  Widget _buildPosterCard(Map<String, dynamic> poster, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poster['title'],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF26344F),
                  ),
                ),
                if (poster['subtitle'].isNotEmpty)
                  Text(
                    poster['subtitle'],
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                Text(
                  '${poster['template']} • ${poster['size']}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Editing ${poster['title']}...'),
                  backgroundColor: const Color(0xFF5777B5),
                ),
              );
            },
            icon: Icon(
              Icons.edit,
              color: const Color(0xFF5777B5),
              size: isSmallScreen ? 18 : 20,
            ),
          ),
        ],
      ),
    );
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
}