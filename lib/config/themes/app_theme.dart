import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color primary1Color = Color(0xFF551120);
  static const Color primary2Color = Color(0xFF881C34);
  static const Color primary3Color = Color(0xFFBB2649); 
  static const Color primary4Color = Color(0xFFDD5775);
  static const Color primary5Color = Color(0xFFE88CA0);
  static const Color primary6Color = Color(0xFFFDEEF0);

  static const Color minusMoney = Color(0xFFFF4267); 
  static const Color moneyBalance = Color(0xFFFBB8FF);

  static const Color errorColor = Color(0xFFDC2626);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFD97706);
  static const Color infoColor = Color(0xFF2255EB);

  static const Color borderColor = Color(0xFFCBCBCB);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary3Color,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodySmall: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),

        bodyLarge: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        
        titleSmall: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        
        titleMedium: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary3Color,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodySmall: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),

        bodyLarge: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        
        titleSmall: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
