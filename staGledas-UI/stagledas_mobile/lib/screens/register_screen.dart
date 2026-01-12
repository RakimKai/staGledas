import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/providers/korisnik_provider.dart';
import 'package:stagledas_mobile/screens/login_screen.dart';
import 'package:stagledas_mobile/screens/onboarding_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/custom_button_widget.dart';
import 'package:stagledas_mobile/widgets/custom_input_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _prezimeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late KorisnikProvider _korisnikProvider;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _korisnikProvider = context.read<KorisnikProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2FCFB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Registracija",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4AB3EF),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Kreirajte novi nalog",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomInputField(
                              labelText: "Ime",
                              controller: _imeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ime je obavezno';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomInputField(
                              labelText: "Prezime",
                              controller: _prezimeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Prezime je obavezno';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
                        labelText: "Email",
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email je obavezan';
                          }
                          if (!value.contains('@')) {
                            return 'Unesite validan email';
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
                          if (value.length < 6) {
                            return 'Lozinka mora imati najmanje 6 karaktera';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: "Potvrdi lozinku",
                        controller: _confirmPasswordController,
                        prefixIcon: Icons.lock_outline,
                        obscuredText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Lozinke se ne poklapaju';
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
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              buttonText: "Registruj se",
                              onPress: _handleRegister,
                            ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Već imate nalog? Prijavite se",
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
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        var request = {
          'ime': _imeController.text,
          'prezime': _prezimeController.text,
          'korisnickoIme': _usernameController.text,
          'email': _emailController.text,
          'lozinka': _passwordController.text,
          'lozinkaPotvrda': _confirmPasswordController.text,
        };

        var result = await _korisnikProvider.register(request);

        Authorization.username = _usernameController.text;
        Authorization.password = _passwordController.text;
        Authorization.fullName = '${result.ime} ${result.prezime}';
        Authorization.id = result.id;
        Authorization.email = result.email;

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ),
          );
        }
      } on Exception catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Greška: ${e.toString()}"),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
