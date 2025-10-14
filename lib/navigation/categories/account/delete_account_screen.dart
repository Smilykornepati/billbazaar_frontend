import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrange = Color(0xFFFF805D);
  static const Color blueAccent = Color(0xFF5777B5);
  static const Color darkBlue = Color(0xFF26344F);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color lightGrey = Color(0xFF4A4A4A);
  static const Color redAccent = Color(0xFFFF4444);
}

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _deleteController = TextEditingController();
  bool get isDeleteTyped => _deleteController.text.trim().toUpperCase() == 'DELETE';

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
                      _buildDangerCard(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      _buildConsequences(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      _buildConfirmationInput(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 30 : 40),
                      _buildDeleteButton(isSmallScreen),
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
                  'Delete Account',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Danger icon
              Icon(
                Icons.dangerous,
                color: Colors.red.shade400,
                size: isSmallScreen ? 20 : 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300, width: 2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.delete_forever,
            color: Colors.red.shade600,
            size: isSmallScreen ? 48 : 56,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'You are about to permanently delete your account. This action is irreversible.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.red.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsequences(bool isSmallScreen) {
    final consequences = [
      'All your business data will be permanently deleted',
      'Customer information and contact details will be lost',
      'Product inventory and pricing data will be removed',
      'Billing history and transaction records will be deleted',
      'Credit details and payment history will be erased',
      'Your subscription will be cancelled immediately',
      'You will not be able to recover your account',
    ];

    return Container(
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
            'What will happen when you delete your account?',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          ...consequences.map((consequence) => Padding(
            padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.close,
                  color: Colors.red.shade600,
                  size: isSmallScreen ? 16 : 18,
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Text(
                    consequence,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildConfirmationInput(bool isSmallScreen) {
    return Container(
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
            'Type "DELETE" to confirm',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'To confirm deletion, please type DELETE in the text field below.',
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          TextField(
            controller: _deleteController,
            onChanged: (value) => setState(() {}),
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            decoration: InputDecoration(
              hintText: 'Type DELETE here',
              hintStyle: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDeleteTyped ? Colors.red.shade600 : const Color(0xFF5777B5),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 12 : 14,
              ),
            ),
          ),
          if (isDeleteTyped) ...[
            SizedBox(height: isSmallScreen ? 8 : 12),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.red.shade600,
                  size: isSmallScreen ? 16 : 18,
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Text(
                  'Confirmation received',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeleteButton(bool isSmallScreen) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 50 : 56,
          child: ElevatedButton.icon(
            onPressed: isDeleteTyped ? _showFinalConfirmation : null,
            icon: Icon(
              Icons.delete_forever,
              size: isSmallScreen ? 18 : 20,
            ),
            label: Text(
              'Delete My Account Forever',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDeleteTyped ? Colors.red.shade600 : Colors.grey.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isDeleteTyped ? 2 : 0,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Text(
          isDeleteTyped 
              ? 'Click the button above to permanently delete your account'
              : 'Type "DELETE" above to enable the delete button',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showFinalConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red.shade600,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    'Final Warning',
                    style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'This is your last chance to cancel!',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'Once you click "Delete Forever", your account and all data will be permanently deleted. This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      height: 1.4,
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
                    _deleteAccount();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Delete Forever',
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

  void _deleteAccount() {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Deleting account...'),
            ],
          ),
        );
      },
    );

    // Simulate account deletion process
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navigate back or to login screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    _deleteController.dispose();
    super.dispose();
  }
}