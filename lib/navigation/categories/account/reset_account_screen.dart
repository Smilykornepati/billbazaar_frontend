import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrange = Color(0xFFFF805D);
  static const Color blueAccent = Color(0xFF5777B5);
  static const Color darkBlue = Color(0xFF26344F);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color lightGrey = Color(0xFF4A4A4A);
  static const Color greenAccent = Color(0xFF4CAF50);
}

class ResetAccountScreen extends StatefulWidget {
  const ResetAccountScreen({Key? key}) : super(key: key);

  @override
  State<ResetAccountScreen> createState() => _ResetAccountScreenState();
}

class _ResetAccountScreenState extends State<ResetAccountScreen> {
  Map<String, bool> resetOptions = {
    'Customer': false,
    'Category': false,
    'Product': false,
    'Bills': false,
    'Credit Details': false,
  };

  bool get hasSelectedItems => resetOptions.values.any((selected) => selected);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return Column(
            children: [
              _buildHeader(isSmallScreen),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  child: Column(
                    children: [
                      _buildWarningCard(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      _buildResetOptions(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 30 : 40),
                      _buildResetButton(isSmallScreen),
                    ],
                  ),
                ),
              ),
            ],
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
          colors: [
            Color(0xFF5777B5),
            Color(0xFF26344F),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isSmallScreen ? 12 : 16,
            isSmallScreen ? 8 : 12,
            isSmallScreen ? 12 : 16,
            isSmallScreen ? 12 : 16,
          ),
          child: Row(
            children: [
              // Back arrow
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: isSmallScreen ? 20 : 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              // Title
              Expanded(
                child: Text(
                  'Reset Account',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Warning icon
              Icon(
                Icons.warning,
                color: AppColors.primaryOrange,
                size: isSmallScreen ? 20 : 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.warning,
            color: Colors.red.shade600,
            size: isSmallScreen ? 40 : 48,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'Warning: Data Reset',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'This action will permanently delete the selected data from your account. This cannot be undone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.red.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetOptions(bool isSmallScreen) {
    return Container(
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
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Text(
              'Select Data to Reset',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF26344F),
              ),
            ),
          ),
          ...resetOptions.entries.map((entry) {
            return _buildOptionTile(entry.key, entry.value, isSmallScreen);
          }),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, bool isSelected, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF26344F),
          ),
        ),
        subtitle: Text(
          _getSubtitle(title),
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: Colors.grey[600],
          ),
        ),
        value: isSelected,
        onChanged: (bool? value) {
          setState(() {
            resetOptions[title] = value ?? false;
          });
        },
        activeColor: AppColors.primaryOrange,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 4 : 8,
        ),
      ),
    );
  }

  String _getSubtitle(String title) {
    switch (title) {
      case 'Customer':
        return 'All customer information and contact details';
      case 'Category':
        return 'Product categories and classifications';
      case 'Product':
        return 'All products, inventory, and pricing data';
      case 'Bills':
        return 'All billing history and transaction records';
      case 'Credit Details':
        return 'Customer credit information and payment history';
      default:
        return '';
    }
  }

  Widget _buildResetButton(bool isSmallScreen) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 50 : 56,
          child: ElevatedButton.icon(
            onPressed: hasSelectedItems ? _showResetConfirmation : null,
            icon: Icon(
              Icons.refresh,
              size: isSmallScreen ? 18 : 20,
            ),
            label: Text(
              'Reset Selected Data',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: hasSelectedItems ? Colors.red.shade600 : Colors.grey.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: hasSelectedItems ? 2 : 0,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Text(
          'Select at least one option to reset',
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showResetConfirmation() {
    final selectedItems = resetOptions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            
            return AlertDialog(
              title: Text(
                'Confirm Reset',
                style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to reset the following data?',
                    style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  ...selectedItems.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: isSmallScreen ? 4 : 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.red,
                          size: isSmallScreen ? 16 : 18,
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 6),
                        Text(
                          item,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'This action cannot be undone.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performReset(selectedItems);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Reset Data',
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _performReset(List<String> selectedItems) {
    // Reset the selected options
    setState(() {
      for (String item in selectedItems) {
        resetOptions[item] = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected data has been reset: ${selectedItems.join(', ')}',
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}