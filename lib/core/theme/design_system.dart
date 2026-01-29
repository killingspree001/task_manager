import 'package:flutter/material.dart';

class QuantumColors {
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color primary = Color(0xFF3B82F6);
  static const Color accent = Color(0xFFF59E0B);
  static const Color textBody = Color(0xFF94A3B8);
  static const Color textHeader = Color(0xFFF8FAFC);
  static const Color glassBorder = Color(0x33F8FAFC);
}

class QuantumTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: QuantumColors.background,
      colorScheme: const ColorScheme.dark(
        surface: QuantumColors.background,
        onSurface: QuantumColors.textHeader,
        primary: QuantumColors.primary,
        secondary: QuantumColors.accent,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: QuantumColors.textHeader,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        bodyMedium: TextStyle(
          color: QuantumColors.textBody,
        ),
      ),
    );
  }
}

class QuantumGlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const QuantumGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: QuantumColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: QuantumColors.glassBorder),
      ),
      child: child,
    );
  }
}
