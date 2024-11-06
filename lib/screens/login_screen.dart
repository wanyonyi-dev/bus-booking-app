import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_button.dart';
import '../utils/validators.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLogin = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    if (savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = true;
      });
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    // Calculate responsive padding
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final verticalPadding = screenHeight * 0.03; // 3% of screen height

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - MediaQuery.of(context).padding.top,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            _buildHeader(screenHeight),
                            SizedBox(height: screenHeight * 0.04),
                            _buildLoginForm(screenHeight),
                            SizedBox(height: screenHeight * 0.03),
                            _buildAuthButton(screenHeight),
                            SizedBox(height: screenHeight * 0.02),
                            _buildDivider(),
                            SizedBox(height: screenHeight * 0.02),
                            _buildSocialLogin(screenHeight),
                            SizedBox(height: screenHeight * 0.02),
                            _buildToggleSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isLogin ? 'Welcome Back!' : 'Create Account',
          style: GoogleFonts.poppins(
            fontSize: screenHeight * 0.04, // Responsive font size
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          _isLogin
              ? 'Sign in to continue your journey'
              : 'Start your journey with us',
          style: GoogleFonts.poppins(
            fontSize: screenHeight * 0.02, // Responsive font size
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(double screenHeight) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          SizedBox(height: screenHeight * 0.02),
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: Validators.validatePassword,
          ),
          if (!_isLogin) ...[
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              prefixIcon: Icons.lock_outline,
              obscureText: !_isConfirmPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              validator: (value) => Validators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
          ],
          if (_isLogin) ...[
            SizedBox(height: screenHeight * 0.02),
            _buildRememberMeForgotPassword(),
          ],
        ],
      ),
    );
  }

  Widget _buildRememberMeForgotPassword() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const Text('Remember me'),
        const Spacer(),
        TextButton(
          onPressed: () {
            // Implement forgot password functionality
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton(double screenHeight) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.07, // Responsive height
      child: ElevatedButton(
        onPressed: _handleAuth,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        child: Text(
          _isLogin ? 'Login' : 'Sign Up',
          style: GoogleFonts.poppins(
            fontSize: screenHeight * 0.02, // Responsive font size
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        Text(
          'Or continue with',
          style: TextStyle(color: Colors.grey[600]),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin(double screenHeight) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: screenHeight * 0.06, // Responsive height
            child: SocialButton(
              iconPath: 'assets/icons/google.svg',
              label: 'Google',
              onPressed: _handleGoogleSignIn,
            ),
          ),
        ),
        SizedBox(width: screenHeight * 0.02),
        Expanded(
          child: SizedBox(
            height: screenHeight * 0.06, // Responsive height
            child: SocialButton(
              iconPath: 'assets/icons/facebook.svg',
              label: 'Facebook',
              onPressed: () {
                // Implement Facebook sign in
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? "Don't have an account? " : "Already have an account? ",
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
              _formKey.currentState?.reset();
              _animationController.reset();
              _animationController.forward();
            });
          },
          child: Text(
            _isLogin ? 'Sign Up' : 'Login',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAuth() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isLogin) {
          await _authService.signInWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );

          if (_rememberMe) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('email', _emailController.text);
          }
        } else {
          await _authService.registerWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
        }

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithGoogle();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}