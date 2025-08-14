import 'package:flutter/material.dart';

class AppThemes {
  static const Color primary1Color = Color(0xFF551120);
  static const Color primary2Color = Color(0xFF881C34);
  static const Color primary3Color = Color(0xFFBB2649);
  static const Color primary4Color = Color(0xFFDD5775);
  static const Color primary5Color = Color(0xFFE88CA0);

  static const Color errorColor = Color(0xFFDC2626);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFD97706);  
  static const Color infoColor = Color(0xFF2255EB);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary3Color,
    highlightColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary3Color,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary3Color,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: primary3Color,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFFF2F2F7),
      hintStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      iconColor: primary1Color,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      errorStyle: const TextStyle(
        color: Colors.red, 
        fontSize: 13,
      ),
      // Màu viền đỏ cho trạng thái bình thường
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.primary1Color, width: 1),
        borderRadius: BorderRadius.circular(
          4,
        ), 
      ),

      // Màu viền đỏ khi focus
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.primary1Color, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),

      // Màu viền đỏ khi có lỗi (nếu dùng `errorText`)
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppThemes.errorColor),
        borderRadius: BorderRadius.circular(4),
      ),

      border: UnderlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.primary1Color),
        borderRadius: BorderRadius.circular(4),
      ),

    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
      headlineLarge: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w800),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary3Color,
      unselectedItemColor: Colors.black54,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      contentTextStyle: const TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: primary1Color,
          width: 1,
        ),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: primary1Color,
      textColor: Colors.black,
      tileColor: Colors.white,
      selectedColor: primary3Color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppThemes.primary1Color,
        textStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    )
  );


  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary3Color,
    highlightColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary3Color,
      brightness: Brightness.dark,
      surface: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary3Color,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: primary3Color,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: primary1Color,
      fillColor: const Color(0xFF1E1E2C),
      hintStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 13,
      ),
      // Màu viền đỏ cho trạng thái bình thường
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.primary5Color, width: 1),
        borderRadius: BorderRadius.circular(
          4,
        ), 
      ),

      // Màu viền đỏ khi focus
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.primary5Color, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),

      // Màu viền đỏ khi có lỗi (nếu dùng `errorText`)
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppThemes.errorColor),
        borderRadius: BorderRadius.circular(4),
      ),

      border: UnderlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.primary5Color),
        borderRadius: BorderRadius.circular(4),
      ),

    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
      headlineLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: primary3Color,
      unselectedItemColor: Colors.white70,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1E1E2C),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w400),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: primary1Color,
          width: 1,
        ),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: primary1Color,
      textColor: Colors.white,
      tileColor: Colors.black,
      selectedColor: primary3Color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppThemes.primary5Color,
        textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    )
  );

}

