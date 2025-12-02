import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:softmed24h/src/screens/home_screen.dart';
import 'package:softmed24h/src/utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy()); // Ensure path strategy is set
  await dotenv.load(
    fileName: kReleaseMode ? ".env.production" : ".env.development",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoftMed24h',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3CC878)),
        useMaterial3: true,
        fontFamily: 'Montserrat',
        extensions: const <ThemeExtension<dynamic>>[
          MyColors(
            primaryGreen: Color(0xFF3CC878),
            primaryBlue: Color(0xFF003f5c),
          ),
        ],
      ),
      home: const DoutorBeneficiosApp(), // Use the GoRouter instance
    );
  }
}
