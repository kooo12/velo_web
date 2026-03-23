import 'package:flutter/material.dart';
import 'glass_container.dart';
import '../theme/app_theme.dart';

class FloatingNavbar extends StatelessWidget {
  final VoidCallback onDownloadPressed;
  final Function(String) onNavLinkPressed;

  const FloatingNavbar({
    super.key,
    required this.onDownloadPressed,
    required this.onNavLinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = MediaQuery.of(context).size.width < 900;
      final isSmallMobile = MediaQuery.of(context).size.width < 600;

      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GlassContainer(
            radius: 32,
            blur: 20,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile ? 12 : 24,
              vertical: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _logo(isSmallMobile),
                if (!isMobile) ...[
                  const SizedBox(width: 48),
                  _navLink('Home'),
                  _navLink('About'),
                  _navLink('Features'),
                  _navLink('FAQ'),
                ],
                SizedBox(width: isMobile ? 16 : 32),
                _downloadButton(isSmallMobile),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _logo(bool isSmallMobile) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.music_note, color: Colors.black, size: 20),
        ),
        if (!isSmallMobile) ...[
          const SizedBox(width: 12),
          const Text(
            'Velo Music',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _navLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () => onNavLinkPressed(label),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _downloadButton(bool isSmallMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentColor, AppTheme.accentColor.withAlpha(150)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withAlpha(100),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onDownloadPressed,
        icon: Icon(Icons.download, size: isSmallMobile ? 16 : 18),
        label: Text(isSmallMobile ? 'Get App' : 'Download'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallMobile ? 16 : 24,
            vertical: isSmallMobile ? 14 : 18,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}
