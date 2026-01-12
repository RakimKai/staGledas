import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/korisnik.dart';
import 'package:stagledas_mobile/providers/korisnik_provider.dart';
import 'package:stagledas_mobile/screens/home_screen.dart';
import 'package:stagledas_mobile/screens/register_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/custom_button_widget.dart';
import 'package:stagledas_mobile/widgets/custom_input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late KorisnikProvider _korisnikProvider;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    _korisnikProvider = context.read<KorisnikProvider>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2FCFB),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Šta Gledaš?",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4AB3EF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Dobrodošli nazad!",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 18,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 48),

                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInputField(
                          labelText: "Korisničko ime",
                          controller: _usernameController,
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Korisničko ime je obavezno';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          labelText: "Lozinka",
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          obscuredText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lozinka je obavezna';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color(0xFF4AB3EF),
                              )
                            : CustomButtonWidget(
                                isFullWidth: true,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                buttonText: "Prijavi se",
                                onPress: _handleLogin,
                              ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Nemate nalog? Registrujte se",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF718096),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      var username = _usernameController.text;
      var password = _passwordController.text;

      Authorization.username = username;
      Authorization.password = password;

      try {
        Korisnik result = await _korisnikProvider.login(username, password);

        Authorization.fullName = result.fullName;
        Authorization.id = result.id;
        Authorization.email = result.email;
        Authorization.slika = result.slika;
        Authorization.isPremium = result.isPremium ?? false;

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      } on Exception {
        if (mounted) {
          setState(() {
            _errorMessage = "Neispravno korisničko ime ili lozinka.";
            _isLoading = false;
          });
        }
      }
    }
  }
}
