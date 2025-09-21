import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart'; // Import the new login page
import 'utils/color_utils.dart';
import 'utils/typography_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Student Hub",
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0, // Fixed text scale factor
          ),
          child: child!,
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorUtils.getLightColorScheme(),
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      cardTheme: _buildCardTheme(),
      appBarTheme: _buildAppBarTheme(),
      drawerTheme: _buildDrawerTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      listTileTheme: _buildListTileTheme(),
      chipTheme: _buildChipTheme(),
      dividerTheme: _buildDividerTheme(),
      progressIndicatorTheme: _buildProgressIndicatorTheme(),
      iconTheme: _buildIconTheme(),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),
      navigationDrawerTheme: _buildNavigationDrawerTheme(),
      dialogTheme: _buildDialogTheme(),
      snackBarTheme: _buildSnackBarTheme(),
      // Accessibility enhancements
      visualDensity: VisualDensity.adaptivePlatformDensity,
      focusColor: ColorUtils.primaryBlue.withOpacity(0.12),
      hoverColor: ColorUtils.primaryBlue.withOpacity(0.08),
      splashColor: ColorUtils.primaryBlue.withOpacity(0.12),
      highlightColor: ColorUtils.primaryBlue.withOpacity(0.12),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorUtils.getDarkColorScheme(),
      textTheme: _buildTextTheme().apply(
        bodyColor: const Color(0xFFE6E1E5),
        displayColor: const Color(0xFFE6E1E5),
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      cardTheme: _buildCardTheme(),
      appBarTheme: _buildAppBarTheme(),
      drawerTheme: _buildDrawerTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      listTileTheme: _buildListTileTheme(),
      chipTheme: _buildChipTheme(),
      dividerTheme: _buildDividerTheme(),
      progressIndicatorTheme: _buildProgressIndicatorTheme(),
      iconTheme: _buildIconTheme(),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),
      navigationDrawerTheme: _buildNavigationDrawerTheme(),
      dialogTheme: _buildDialogTheme(),
      snackBarTheme: _buildSnackBarTheme(),
      // Accessibility enhancements
      visualDensity: VisualDensity.adaptivePlatformDensity,
      focusColor: ColorUtils.primaryBlueLight.withOpacity(0.12),
      hoverColor: ColorUtils.primaryBlueLight.withOpacity(0.08),
      splashColor: ColorUtils.primaryBlueLight.withOpacity(0.12),
      highlightColor: ColorUtils.primaryBlueLight.withOpacity(0.12),
    );
  }

  TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: TypographyUtils.displayLargeStyle,
      displayMedium: TypographyUtils.displayMediumStyle,
      displaySmall: TypographyUtils.displaySmallStyle,
      headlineLarge: TypographyUtils.headlineLargeStyle,
      headlineMedium: TypographyUtils.headlineMediumStyle,
      headlineSmall: TypographyUtils.headlineSmallStyle,
      titleLarge: TypographyUtils.titleLargeStyle,
      titleMedium: TypographyUtils.titleMediumStyle,
      titleSmall: TypographyUtils.titleSmallStyle,
      bodyLarge: TypographyUtils.bodyLargeStyle,
      bodyMedium: TypographyUtils.bodyMediumStyle,
      bodySmall: TypographyUtils.bodySmallStyle,
      labelLarge: TypographyUtils.labelLargeStyle,
      labelMedium: TypographyUtils.labelMediumStyle,
      labelSmall: TypographyUtils.labelSmallStyle,
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shadowColor: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(width: 1),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  CardThemeData _buildCardTheme() {
    return CardThemeData(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }

  AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      iconTheme: IconThemeData(
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        size: 24,
      ),
    );
  }

  DrawerThemeData _buildDrawerTheme() {
    return const DrawerThemeData(
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  ListTileThemeData _buildListTileTheme() {
    return const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      minLeadingWidth: 40,
      iconColor: Color(0xFF49454F),
      textColor: Color(0xFF1C1B1F),
    );
  }

  ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      backgroundColor: const Color(0xFFE0E0E0),
      selectedColor: const Color(0xFF1976D2),
      disabledColor: const Color(0xFFF5F5F5),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  DividerThemeData _buildDividerTheme() {
    return const DividerThemeData(
      thickness: 1,
      space: 1,
      color: Color(0xFFE0E0E0),
    );
  }

  ProgressIndicatorThemeData _buildProgressIndicatorTheme() {
    return const ProgressIndicatorThemeData(
      color: Color(0xFF1976D2),
      linearTrackColor: Color(0xFFE0E0E0),
      circularTrackColor: Color(0xFFE0E0E0),
    );
  }

  IconThemeData _buildIconTheme() {
    return const IconThemeData(
      size: 24,
      color: Color(0xFF49454F),
    );
  }

  FloatingActionButtonThemeData _buildFloatingActionButtonTheme() {
    return const FloatingActionButtonThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }

  BottomNavigationBarThemeData _buildBottomNavigationBarTheme() {
    return const BottomNavigationBarThemeData(
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF1976D2),
      unselectedItemColor: Color(0xFF49454F),
      backgroundColor: Color(0xFFFFFFFF),
    );
  }

  NavigationDrawerThemeData _buildNavigationDrawerTheme() {
    return const NavigationDrawerThemeData(
      elevation: 16,
      backgroundColor: Color(0xFFFFFFFF),
      indicatorColor: Color(0xFF1976D2),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  DialogThemeData _buildDialogTheme() {
    return DialogThemeData(
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Color(0xFF1C1B1F),
      ),
      contentTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF49454F),
      ),
    );
  }

  SnackBarThemeData _buildSnackBarTheme() {
    return const SnackBarThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      behavior: SnackBarBehavior.floating,
      contentTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFFFFFFF),
      ),
    );
  }
}
