import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _zoomController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _zoomAnimation;
  
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Zoom out effect - starts big and zooms out to normal size
    _zoomAnimation = Tween<double>(
      begin: 2.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zoomController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _startAnimations();
    
    // Check authentication and navigate
    _initializeApp();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _zoomController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _slideController.forward();
  }

  Future<void> _initializeApp() async {
    // Show splash for at least 3 seconds for branding
    await Future.delayed(const Duration(seconds: 3));
    
    try {
      // Check if user is already logged in
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (mounted) {
        if (isLoggedIn) {
          // User is logged in, go to home screen
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // User is not logged in, go to sign in screen
          Navigator.pushReplacementNamed(context, '/signin');
        }
      }
    } catch (e) {
      // If there's an error, default to sign in screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFFFF7F4), // Very light orange tint
                Color(0xFFFFF0E8), // Slightly more orange
              ],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([_fadeAnimation, _slideAnimation, _zoomAnimation]),
              builder: (context, child) {
                return Column(
                  children: [
                    // Main content area
                    Expanded(
                      child: Center(
                        child: Transform.scale(
                          scale: _zoomAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Professional App Name with gradient styling
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Color(0xFFFF805D), // Primary orange
                                      Color(0xFFFF6B4A), // Deeper orange
                                      Color(0xFF26344F), // Dark blue accent
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'BillBazar',
                                    style: TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white, // This will be masked
                                      letterSpacing: 6.0,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Elegant orange accent line
                                Container(
                                  width: 120,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Color(0xFFFF805D),
                                        Color(0xFFFF6B4A),
                                        Colors.transparent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Enhanced tagline with subtle styling
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF805D).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Color(0xFFFF805D).withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Your Smart Shopping Companion',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF26344F),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Bottom section with loading and branding
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80),
                          child: Column(
                            children: [
                              // Elegant loading indicator
                              const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF805D)),
                                ),
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Tagline as shown in image
                              Text(
                                'Discover • Shop • Enjoy',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF26344F),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Decorative dots
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF805D),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF805D).withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF805D),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Copyright as shown in image
                              Text(
                                '© 2025 BillBazar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF26344F).withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}