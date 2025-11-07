import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:softmed24h/src/data/network/api_client.dart';
import 'package:softmed24h/src/data/network/app_exceptions.dart';
import 'package:softmed24h/src/data/services/auth_api_service.dart';
import 'package:softmed24h/src/data/services/user_api_service.dart';
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:softmed24h/src/utils/session_manager.dart';
import 'package:softmed24h/src/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: isSmallScreen
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  // --- App Bar ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            // Logo Placeholder (e.g., Image.asset('images/logo.png'))
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.go('/');
                },
                child: Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 40),
                    const SizedBox(width: 10),
                    if (!isSmallScreen)
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SoftMed24h',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Nosso plano é a sua saúde',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Cadastrar',
              width: isSmallScreen ? 120 : 200,
              height: 40,
              fontSize: isSmallScreen ? 16 : 18,
              onPressed: () {
                context.go('/cadastro');
              },
            ),
          ],
        ),
      ),
    );
  }
  // --- Desktop/Wide Layout ---

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left Side: Image and CTA Text
        Expanded(flex: 5, child: _buildImageSection(context)),
        // Right Side: Login Form
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildFormSection(context),
            ),
          ),
        ),
      ],
    );
  }

  // Left Section (Image)
  Widget _buildImageSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.accent, // Background for safety
        // Placeholder for the large image
        // image: DecorationImage(
        //   image: AssetImage('images/doctors_login.png'),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Container(
        // Apply a subtle dark overlay at the bottom for text contrast
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withAlpha(0), Colors.black.withAlpha(128)],
            stops: const [0.6, 1.0],
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Junte-se a nós com o ',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'SoftMed24h.',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Colors.black.withAlpha(128), blurRadius: 4),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Saúde Conectada: Atendimento Superior, Planos Personalizados e Inovação Tecnológica ao Seu Alcance!',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  // Right Section (Form)
  Widget _buildFormSection(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo ao SoftMed24h!',
              style: TextStyle(
                fontSize: isSmallScreen ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Preencha os campos abaixo.',
              style: TextStyle(fontSize: 18, color: AppColors.text),
            ),
            const SizedBox(height: 40),

            // Email/CPF Field
            const Text(
              'E-mail ou CPF',
              style: TextStyle(color: AppColors.text),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu e-mail ou CPF.';
                }
                // Regex for email validation
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return 'Por favor, insira um e-mail válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password Field
            const Text('Senha', style: TextStyle(color: AppColors.text)),
            const SizedBox(height: 8),
            _buildTextField(
              isPassword: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua senha.';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres.';
                }
                return null;
              },
            ),

            // Forgot Password
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.go('/forgot-password');
                  },
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: Container(
                alignment: Alignment.center,
                child: AppButton(
                  label: 'Entrar',
                  width: 200,
                  height: 40,
                  fontSize: 18,
                  onPressed: _login,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final apiClient = ApiClient();
      final authApiService = AuthApiService(apiClient);
      final userApiService = UserApiService(apiClient);
      try {
        final authResponse = await authApiService.login(
          _emailController.text,
          _passwordController.text,
        );
        await SessionManager().saveToken(authResponse.accessToken);

        final user = await userApiService.getMe();

        _showSnackBar('Login realizado com sucesso!', Colors.green);

        if (!mounted) return;
        if (!user.hasActivePayment) {
          context.go('/payment');
        } else {
          context.go('/home');
        }
      } on AppException catch (e) {
        _showSnackBar('Falha no login: ${e.message}', Colors.red);
      } catch (e) {
        _showSnackBar('Falha no login: ${e.toString()}', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  // --- Mobile/Narrow Layout ---

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top half: Form
          _buildFormSection(context),

          // Bottom half: Image and CTA (Simplified for mobile)
          SizedBox(
            height: 300, // Fixed height for the image section on mobile
            child: _buildImageSection(context),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField({
    bool isPassword = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Light grey background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscureText : false,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        style: const TextStyle(fontSize: 16, color: AppColors.text),
      ),
    );
  }
}
