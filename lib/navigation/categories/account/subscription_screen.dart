import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedPlanIndex = 0; // Default to first plan (Monthly)

  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'title': 'Monthly (Starter Plan)',
      'duration': '1 Month',
      'originalPrice': 199,
      'discountedPrice': 99,
      'isSelected': true,
      'badge': null,
    },
    {
      'title': '6-Months (Most Popular)',
      'duration': '6 Month',
      'originalPrice': 899,
      'discountedPrice': 499,
      'isSelected': false,
      'badge': 'Most Popular',
    },
    {
      'title': '1-Year (Best Discount)',
      'duration': '12 Month',
      'originalPrice': 1899,
      'discountedPrice': 899,
      'isSelected': false,
      'badge': 'Best Discount',
    },
    {
      'title': '3-Years (Best Discount)',
      'duration': '36 Month',
      'originalPrice': 3600,
      'discountedPrice': 2499,
      'isSelected': false,
      'badge': 'Best Discount',
    },
  ];

  final List<String> premiumFeatures = [
    'Create Unlimited Bills',
    'Staff Management',
    'Import Product Data Using Excel',
    'Delete Bill History',
    'Access To Sales Summary',
    'Access To Day Report',
    'Access To Item Wise Sales Report',
    'Priority Support',
  ];

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
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16, 
                    vertical: isSmallScreen ? 16 : 20,
                  ),
                  child: Column(
                    children: [
                      _buildGoPremiumTitle(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      _buildSubscriptionPlans(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      _buildPremiumFeatures(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 30 : 40),
                      _buildPayButton(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 16 : 20),
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
            isSmallScreen ? 12 : 16
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
              SizedBox(width: isSmallScreen ? 6.0 : 8.0),
              // Title
              Expanded(
                child: Text(
                  'Subscription',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Payment Report button
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 12,
                  vertical: isSmallScreen ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Payment Report',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoPremiumTitle(bool isSmallScreen) {
    return Column(
      children: [
        Text(
          'GO PREMIUM',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A202C),
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Container(
          width: isSmallScreen ? 50 : 60,
          height: isSmallScreen ? 3 : 4,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionPlans(bool isSmallScreen) {
    return Column(
      children: subscriptionPlans.asMap().entries.map((entry) {
        final index = entry.key;
        final plan = entry.value;
        final isSelected = selectedPlanIndex == index;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPlanIndex = index;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryOrange : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan['title'],
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A202C),
                        ),
                      ),
                    ),
                    if (plan['badge'] != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 12,
                          vertical: isSmallScreen ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan['badge'],
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Row(
                  children: [
                    Text(
                      '₹${plan['discountedPrice']}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Text(
                      '₹${plan['originalPrice']}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      plan['duration'],
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPremiumFeatures(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A202C),
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        ...premiumFeatures.map((feature) => Container(
          margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isSmallScreen ? 20 : 24,
                height: isSmallScreen ? 20 : 24,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.primaryOrange,
                  size: isSmallScreen ? 14 : 16,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Text(
                  feature,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A202C),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPayButton(bool isSmallScreen) {
    final selectedPlan = subscriptionPlans[selectedPlanIndex];
    
    return Container(
      width: double.infinity,
      height: isSmallScreen ? 50 : 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.3),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _showPaymentDialog(selectedPlan, isSmallScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Pay ₹${selectedPlan['discountedPrice']} for ${selectedPlan['duration']}',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(Map<String, dynamic> selectedPlan, bool isSmallScreen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Payment',
            style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan: ${selectedPlan['title']}',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                'Duration: ${selectedPlan['duration']}',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                'Amount: ₹${selectedPlan['discountedPrice']}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryOrange,
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
                _processPayment(selectedPlan);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
              ),
              child: Text(
                'Pay Now',
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
            ),
          ],
        );
      },
    );
  }

  void _processPayment(Map<String, dynamic> selectedPlan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment initiated for ${selectedPlan['title']}'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}