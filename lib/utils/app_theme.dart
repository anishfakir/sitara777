import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryMaroon = Color(0xFF8B0000);
  static const Color primaryColor = Color(0xFF8B0000); // Deep Maroon
  static const Color accentGold = Color(0xFFFFD700); // Rich Gold
  static const Color surfaceColor = Color(0xFFFFFFFF); // Clean White
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light Gray
  static const Color primaryTextColor = Color(0xFF333333); // Dark Gray
  static const Color secondaryTextColor = Color(0xFF666666); // Medium Gray
  static const Color onPrimaryTextColor = Color(0xFFFFFFFF); // White
  static const Color errorColor = Color(0xFFB00020); // Red
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color(0xFFFF9800); // Orange
  static const Color infoColor = Color(0xFF2196F3); // Blue
  static const Color secondaryMaroon = Color(0xFFA52A2A); // Secondary Maroon
  static const Color textPrimary = primaryTextColor;
  static const Color textSecondary = secondaryTextColor;
  static const Color background = backgroundColor;
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color pendingColor = Color(0xFFFFA500);
  // Added missing colors
  static const Color primaryGreen = Color(0xFF4CAF50); // Green
  static const Color primaryRed = Color(0xFFF44336); // Red
  static const Color primaryOrange = Color(0xFFFF9800); // Orange

  // Spacing System
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Radius System
  static const double smallRadius = 4.0;
  static const double mediumRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;
  static const double cardBorderRadius = largeRadius;
  // Added button radius
  static const double buttonRadius = largeRadius;

  // Elevation System
  static const double smallElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double largeElevation = 8.0;

  // Shadow
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0xFF000000),
    blurRadius: 4.0,
    offset: Offset(0, 2),
  );

  // Text Themes
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: primaryTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: primaryTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: secondaryTextColor,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: secondaryTextColor,
    ),
  );

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: onPrimaryTextColor,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: onPrimaryTextColor,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: onPrimaryTextColor,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: onPrimaryTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: onPrimaryTextColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: onPrimaryTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: onPrimaryTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: onPrimaryTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: onPrimaryTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: onPrimaryTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: onPrimaryTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: secondaryTextColor,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: onPrimaryTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: onPrimaryTextColor,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: secondaryTextColor,
    ),
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryMaroon,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryMaroon,
        primary: primaryMaroon,
        secondary: accentGold,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: onPrimaryTextColor,
        onSecondary: primaryTextColor,
        onSurface: primaryTextColor,
        onError: onPrimaryTextColor,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryMaroon,
        foregroundColor: onPrimaryTextColor,
        elevation: mediumElevation,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: onPrimaryTextColor,
        ),
        iconTheme: IconThemeData(
          color: onPrimaryTextColor,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: mediumElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        margin: const EdgeInsets.all(smallSpacing),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: mediumElevation,
          backgroundColor: primaryMaroon,
          foregroundColor: onPrimaryTextColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryMaroon,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryMaroon,
          side: const BorderSide(
            color: primaryMaroon,
            width: 1,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
          borderSide: BorderSide(
            color: secondaryTextColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
          borderSide: BorderSide(
            color: secondaryTextColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
          borderSide: const BorderSide(
            color: primaryMaroon,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
          borderSide: const BorderSide(
            color: errorColor,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: mediumElevation,
        backgroundColor: accentGold,
        foregroundColor: primaryTextColor,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: largeElevation,
        backgroundColor: surfaceColor,
        selectedItemColor: primaryMaroon,
        unselectedItemColor: secondaryTextColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: surfaceColor,
        elevation: largeElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(largeRadius),
            bottomRight: Radius.circular(largeRadius),
          ),
        ),
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: mediumSpacing,
          vertical: smallSpacing,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(mediumRadius)),
        ),
      ),

      // Text Theme
      textTheme: lightTextTheme,

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: secondaryTextColor.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryMaroon,
        linearTrackColor: Color(0xFFFFE4E1),
        circularTrackColor: Color(0xFFFFE4E1),
      ),
    );
  }

  // Custom Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    elevation: mediumElevation,
    backgroundColor: primaryMaroon,
    foregroundColor: onPrimaryTextColor,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(largeRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
  );

  static ButtonStyle get accentButtonStyle => ElevatedButton.styleFrom(
    elevation: mediumElevation,
    backgroundColor: accentGold,
    foregroundColor: primaryTextColor,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(largeRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
  );

  static ButtonStyle get outlineButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryMaroon,
    side: const BorderSide(
      color: primaryMaroon,
      width: 1,
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(largeRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
  );

  static ButtonStyle get button => primaryButtonStyle;
  static ButtonStyle get secondaryButtonStyle => outlineButtonStyle;

  // Custom Card Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(largeRadius),
    boxShadow: [
      BoxShadow(
        color: primaryTextColor.withValues(alpha: 0.1),
        blurRadius: mediumElevation,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get primaryCardDecoration => BoxDecoration(
    color: primaryMaroon,
    borderRadius: BorderRadius.circular(largeRadius),
    boxShadow: [
      BoxShadow(
        color: primaryTextColor.withValues(alpha: 0.1),
        blurRadius: mediumElevation,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get standardCardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(largeRadius),
    boxShadow: [
      BoxShadow(
        color: primaryTextColor.withValues(alpha: 0.1),
        blurRadius: mediumElevation,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Gradient Backgrounds
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [primaryMaroon, Color(0xFFA52A2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradient => const LinearGradient(
    colors: [accentGold, Color(0xFFFFE5B4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Custom Text Styles
  static TextStyle get heading1 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColorPrimary,
  );

  static const TextStyle bodyText1 => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: primaryTextColor,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: textColorSecondary,
  );

  static TextStyle get caption => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: secondaryTextColor,
  );

  static TextStyle get errorText => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: errorColor,
  );

  static TextStyle get successText => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: successColor,
  );

  // Custom Icon Themes
  static IconThemeData get primaryIconTheme => const IconThemeData(
    color: primaryMaroon,
    size: 24,
  );

  static IconThemeData get accentIconTheme => const IconThemeData(
    color: accentGold,
    size: 24,
  );

  static IconThemeData get errorIconTheme => const IconThemeData(
    color: errorColor,
    size: 24,
  );
}