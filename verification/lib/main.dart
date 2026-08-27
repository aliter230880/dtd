import 'package:flutter/material.dart';
import 'screens/verification_screen.dart';
import 'theme/tokens.dart';

void main() => runApp(const DtdVerificationApp());

class DtdVerificationApp extends StatelessWidget {
  const DtdVerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DTD — Верификация документов',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Палитра из макетов DTD: жёлтый акцент, чёрный текст на нём.
        colorScheme: ColorScheme.fromSeed(
          seedColor: T.accentStrong,
          primary: T.accent,
          onPrimary: T.onAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: T.bg,
        fontFamily: 'Roboto',
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: T.surface,
          filled: true,
        ),
        cardTheme: const CardThemeData(elevation: 0),
      ),
      home: const VerificationScreen(),
    );
  }
}
