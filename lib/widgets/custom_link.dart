import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/design/app_colors.dart';

/// Mirrors Quake/Widgets/CustomLink.swift — a sentence where one substring
/// is rendered as a tappable, colored link.
class CustomLink extends StatelessWidget {
  final String text;
  final String linkText;
  final String linkUrl;

  const CustomLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.linkUrl,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    final index = text.indexOf(linkText);

    if (index < 0) {
      return Text(text, style: baseStyle);
    }

    final before = text.substring(0, index);
    final after = text.substring(index + linkText.length);

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: linkText,
            style: const TextStyle(
              color: AppColors.seismicAmber,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(Uri.parse(linkUrl), mode: LaunchMode.externalApplication),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
