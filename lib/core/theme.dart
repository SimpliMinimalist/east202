import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primarySeedColor = Color(0xFFFF7A21);

  static final TextTheme _appTextTheme = TextTheme(
    displayLarge: GoogleFonts.oswald(
        fontSize: 57, fontWeight: FontWeight.bold, letterSpacing: -0.25),
    displayMedium: GoogleFonts.oswald(
        fontSize: 45, fontWeight: FontWeight.bold, letterSpacing: 0.0),
    displaySmall: GoogleFonts.oswald(
        fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 0.0),
    headlineLarge: GoogleFonts.roboto(
        fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: 0.25),
    headlineMedium: GoogleFonts.roboto(
        fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 0.0),
    headlineSmall: GoogleFonts.roboto(
        fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 0.0),
    titleLarge: GoogleFonts.roboto(
        fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: GoogleFonts.roboto(
        fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall: GoogleFonts.roboto(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall: GoogleFonts.openSans(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelLarge: GoogleFonts.roboto(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    labelMedium: GoogleFonts.roboto(
        fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.0),
    labelSmall: GoogleFonts.roboto(
        fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1.5),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      brightness: Brightness.light,
    ),
    textTheme: _appTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF2F2F2),
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _appTextTheme.headlineSmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primarySeedColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: _appTextTheme.labelLarge,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primarySeedColor, width: 2.0),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (Set<WidgetState> states) => states.contains(WidgetState.selected)
            ? const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
            : const TextStyle(fontSize: 12),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      brightness: Brightness.dark,
    ),
    textTheme: _appTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _appTextTheme.headlineSmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primarySeedColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: _appTextTheme.labelLarge,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1.0,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primarySeedColor, width: 2.0),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (Set<WidgetState> states) => states.contains(WidgetState.selected)
            ? const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primarySeedColor)
            : TextStyle(fontSize: 12, color: Colors.grey.shade400),
      ),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
