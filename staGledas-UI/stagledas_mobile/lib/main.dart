import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/providers/film_provider.dart';
import 'package:stagledas_mobile/providers/korisnik_provider.dart';
import 'package:stagledas_mobile/providers/novost_provider.dart';
import 'package:stagledas_mobile/providers/onboarding_provider.dart';
import 'package:stagledas_mobile/providers/pratitelji_provider.dart';
import 'package:stagledas_mobile/providers/recenzija_provider.dart';
import 'package:stagledas_mobile/providers/tmdb_provider.dart';
import 'package:stagledas_mobile/providers/watchlist_provider.dart';
import 'package:stagledas_mobile/providers/poruka_provider.dart';
import 'package:stagledas_mobile/providers/zalba_provider.dart';
import 'package:stagledas_mobile/providers/klub_filmova_provider.dart';
import 'package:stagledas_mobile/providers/klub_objave_provider.dart';
import 'package:stagledas_mobile/providers/klub_komentari_provider.dart';
import 'package:stagledas_mobile/providers/klub_lajkovi_provider.dart';
import 'package:stagledas_mobile/providers/obavijest_provider.dart';
import 'package:stagledas_mobile/providers/stripe_provider.dart';
import 'package:stagledas_mobile/services/signalr_service.dart';
import 'package:stagledas_mobile/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  try {
    final stripeKey = dotenv.env["STRIPE__PUBKEY"];
    if (stripeKey != null && stripeKey.isNotEmpty) {
      Stripe.publishableKey = stripeKey;
      Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
      Stripe.urlScheme = 'flutterstripe';
      await Stripe.instance.applySettings();
    }
  } catch (e) {}

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => KorisnikProvider()),
      ChangeNotifierProvider(create: (_) => FilmProvider()),
      ChangeNotifierProvider(create: (_) => NovostProvider()),
      ChangeNotifierProvider(create: (_) => RecenzijaProvider()),
      ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ChangeNotifierProvider(create: (_) => PratiteljiProvider()),
      ChangeNotifierProvider(create: (_) => PorukaProvider()),
      ChangeNotifierProvider(create: (_) => ZalbaProvider()),
      ChangeNotifierProvider(create: (_) => KlubFilmovaProvider()),
      ChangeNotifierProvider(create: (_) => KlubObjaveProvider()),
      ChangeNotifierProvider(create: (_) => KlubKomentariProvider()),
      ChangeNotifierProvider(create: (_) => KlubLajkoviProvider()),
      ChangeNotifierProvider(create: (_) => ObavijestProvider()),
      ChangeNotifierProvider(create: (_) => StripeProvider()),
      ChangeNotifierProvider(create: (_) => SignalRService()),
      Provider(create: (_) => TmdbProvider()),
    ],
    child: const StaGledasMobile(),
  ));
}

class StaGledasMobile extends StatelessWidget {
  const StaGledasMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sta Gledas?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D9FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
