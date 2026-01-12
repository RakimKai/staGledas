import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_admin/models/korisnik.dart';
import 'package:stagledas_admin/providers/film_provider.dart';
import 'package:stagledas_admin/providers/korisnik_provider.dart';
import 'package:stagledas_admin/providers/novost_provider.dart';
import 'package:stagledas_admin/providers/recenzija_provider.dart';
import 'package:stagledas_admin/providers/reports_provider.dart';
import 'package:stagledas_admin/providers/zalba_provider.dart';
import 'package:stagledas_admin/screens/home_screen.dart';
import 'package:stagledas_admin/utils/util.dart';
import 'package:stagledas_admin/widgets/custom_button.dart';
import 'package:stagledas_admin/widgets/custom_input.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('hr', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
        ChangeNotifierProvider(create: (_) => FilmProvider()),
        ChangeNotifierProvider(create: (_) => NovostProvider()),
        ChangeNotifierProvider(create: (_) => RecenzijaProvider()),
        ChangeNotifierProvider(create: (_) => ZalbaProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'staGledas Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBg,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final korisnikProvider = context.read<KorisnikProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 550, maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Šta Gledaš?",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Admin Panel",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Dobrodošli nazad!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Unesite korisničko ime i lozinku",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 24),
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
                    CustomInput(
                      labelText: "Korisničko ime",
                      controller: _usernameController,
                      prefixIcon: Icons.person_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Korisničko ime je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomInput(
                      labelText: "Lozinka",
                      controller: _passwordController,
                      prefixIcon: Icons.lock_rounded,
                      obscuredText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lozinka je obavezna';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        buttonText: _isLoading ? "Prijava..." : "Prijavi se",
                        isDisabled: _isLoading,
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _errorMessage = null;
                              _isLoading = true;
                            });

                            var username = _usernameController.text;
                            var password = _passwordController.text;

                            Authorization.username = username;
                            Authorization.password = password;

                            try {
                              Korisnik result = await korisnikProvider.login(username, password);

                              bool? hasAdminRole = result.uloge?.any(
                                (uloga) => uloga.naziv == "Administrator",
                              );

                              if (hasAdminRole != true) {
                                setState(() {
                                  _errorMessage = "Nemate administratorska ovlaštenja.";
                                  _isLoading = false;
                                });
                                return;
                              }

                              Authorization.fullName = "${result.ime} ${result.prezime}";
                              Authorization.id = result.id;

                              if (mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                            } on Exception catch (e) {
                              setState(() {
                                _errorMessage = "Neispravno korisničko ime ili lozinka.";
                                _isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
