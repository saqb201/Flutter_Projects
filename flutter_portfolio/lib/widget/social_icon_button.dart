import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIconButton extends StatelessWidget {
  final String iconPath;
  final String url;

  const SocialIconButton({super.key, required this.iconPath, required this.url});

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);

    // Launch in external browser or app
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error if URL cannot be launched
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(iconPath, height: 40, width: 40),
      onPressed: _launchURL,
    );
  }
}
