import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A class that defines all app-wide icon styles and themes.
class AppIconTheme {
  static const double smallSize = 16.0;
  static const double mediumSize = 24.0;
  static const double largeSize = 32.0;
  static const double extraLargeSize = 48.0;

  static const Color primaryColor = Color(0xFF1E293B);
  static const Color accentColor = Color(0xFFFFD600);
  static const Color disabledColor = Color(0xFFBDBDBD);

  // Game Status Colors
  static const Color openColor = Color(0xFF4CAF50);
  static const Color closedColor = Color(0xFFE53935);
  static const Color upcomingColor = Color(0xFFFFA000);

  static Widget get logo => SvgPicture.asset(
    'assets/icons/logo.svg',
    height: extraLargeSize,
    width: extraLargeSize,
  );

  static Widget buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    bool useFontAwesome = false,
    Color? color,
    bool isDisabled = false,
  }) {
    final iconWidget = useFontAwesome
        ? FaIcon(
            icon,
            color: isDisabled ? disabledColor : Colors.white,
            size: smallSize,
          )
        : Icon(
            icon,
            color: isDisabled ? disabledColor : Colors.white,
            size: smallSize,
          );

    return ElevatedButton.icon(
      onPressed: isDisabled ? null : onPressed,
      icon: iconWidget,
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? accentColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Widget buildGameStatusIcon(String status, {Key? key, String? message}) {
    IconData icon;
    Color color;

    switch (status.toLowerCase()) {
      case 'open':
        icon = FontAwesomeIcons.play;
        color = openColor;
        break;
      case 'closed':
        icon = FontAwesomeIcons.stop;
        color = closedColor;
        break;
      case 'upcoming':
        icon = FontAwesomeIcons.clock;
        color = upcomingColor;
        break;
      default:
        icon = FontAwesomeIcons.question;
        color = disabledColor;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FaIcon(
        icon,
        color: color,
        size: smallSize,
      ),
    );
  }

  static Widget buildNavigationIcon(
    IconData icon, {
    bool useFontAwesome = false,
    bool isSelected = false,
  }) {
    final color = isSelected ? accentColor : primaryColor;

    return useFontAwesome
        ? FaIcon(
            icon,
            color: color,
            size: mediumSize,
          )
        : Icon(
            icon,
            color: color,
            size: mediumSize,
          );
  }

  static Widget buildSocialIcon(
    IconData icon,
    String platform, {
    Color? color,
    double size = mediumSize,
  }) {
    return FaIcon(
      icon,
      color: color ?? _getSocialColor(platform),
      size: size,
    );
  }

  static Color _getSocialColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'telegram':
        return const Color(0xFF0088CC);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      default:
        return primaryColor;
    }
  }
}