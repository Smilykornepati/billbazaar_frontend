import 'package:flutter/material.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String? _selectedPermission;

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
                // Header with gradient and back arrow
                Container(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 20, 
                    vertical: isSmallScreen ? 12 : 16
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                      Expanded(
                        child: Text(
                          'Add Staff',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: isSmallScreen ? 12 : 20),
                          
                          // Form Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                            child: Column(
                              children: [
                                // Permission Dropdown
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 12 : 16, 
                                    vertical: isSmallScreen ? 2 : 4
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Row(
                                        children: [
                                          Icon(
                                            Icons.admin_panel_settings_outlined,
                                            color: const Color(0xFF666666),
                                            size: isSmallScreen ? 20 : 24,
                                          ),
                                          SizedBox(width: isSmallScreen ? 8 : 12),
                                          Flexible(
                                            child: Text(
                                              'Select Permission Level',
                                              style: TextStyle(
                                                color: const Color(0xFF666666),
                                                fontSize: isSmallScreen ? 14 : 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: _selectedPermission,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Color(0xFF666666),
                                      ),
                                      dropdownColor: Colors.white,
                                      style: TextStyle(
                                        color: const Color(0xFF212121),
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedPermission = newValue;
                                        });
                                      },
                                      items: <String>['Admin', 'Manager', 'Staff', 'Viewer']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 12 : 16),

                                // Staff Name Input
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 12 : 16, 
                                    vertical: isSmallScreen ? 2 : 4
                                  ),
                                  child: TextField(
                                    controller: _nameController,
                                    style: TextStyle(
                                      color: const Color(0xFF212121),
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Staff Name',
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF666666),
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                      icon: Icon(
                                        Icons.person_outline,
                                        color: const Color(0xFF666666),
                                        size: isSmallScreen ? 20 : 24,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 12 : 16),

                                // Staff Mobile Input with Country Code
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 12 : 16, 
                                    vertical: isSmallScreen ? 12 : 16
                                  ),
                                  child: Row(
                                    children: [
                                      // India Flag
                                      Image.asset(
                                        'assets/addstaff/india.png',
                                        width: isSmallScreen ? 24 : 32,
                                        height: isSmallScreen ? 18 : 24,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: isSmallScreen ? 24 : 32,
                                            height: isSmallScreen ? 18 : 24,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Icon(
                                              Icons.flag,
                                              size: isSmallScreen ? 12 : 16,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(width: isSmallScreen ? 6 : 8),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: const Color(0xFF666666),
                                        size: isSmallScreen ? 18 : 24,
                                      ),
                                      SizedBox(width: isSmallScreen ? 6 : 8),
                                      Flexible(
                                        child: Text(
                                          '+91',
                                          style: TextStyle(
                                            color: const Color(0xFF212121),
                                            fontSize: isSmallScreen ? 14 : 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isSmallScreen ? 6 : 8),
                                      Container(
                                        width: 1,
                                        height: isSmallScreen ? 20 : 24,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(width: isSmallScreen ? 6 : 8),
                                      Expanded(
                                        child: TextField(
                                          controller: _mobileController,
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                            color: const Color(0xFF212121),
                                            fontSize: isSmallScreen ? 14 : 16,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Mobile Number',
                                            hintStyle: TextStyle(
                                              color: const Color(0xFF666666),
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 24),

                                // Buttons Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF5777B5),
                                          side: const BorderSide(
                                            color: Color(0xFF5777B5),
                                            width: 1.5,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 12 : 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isSmallScreen ? 12 : 16),
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: _addStaff,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF5777B5),
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shadowColor: Colors.black.withOpacity(0.2),
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 12 : 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Add Staff',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  void _addStaff() {
    if (_nameController.text.isNotEmpty && _mobileController.text.isNotEmpty && _selectedPermission != null) {
      // Add staff logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Staff added successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}