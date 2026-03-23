import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: GlassContainer(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: February 2026',
                  style: TextStyle(color: Colors.white.withAlpha(153)),
                ),
                const Divider(height: 48, color: Colors.white24),
                _sectionTitle('1. Information We Collect'),
                _sectionBody(
                    'We do not collect, store, or transmit any personal information. The application operates entirely offline and does not require an internet connection for its core functionality.'),
                _sectionTitle('2. How We Use Your Information'),
                _sectionBody(
                    'Since we do not collect any information, we do not use your information for any purpose. Your music library, playlists, and preferences are stored locally on your device.'),
                _sectionTitle('3. Information Sharing'),
                _sectionBody(
                    'We do not share any information with third parties because we do not collect any information.'),
                _sectionTitle('4. Data Security'),
                _sectionBody(
                    'Your data is stored locally on your device. The security of your data depends on the security of your device.'),
                _sectionTitle('5. Your Rights'),
                _sectionBody(
                    'You have full control over your data since it is stored on your device. You can delete or modify your data at any time.'),
                _sectionTitle('6. Cookies and Tracking'),
                _sectionBody(
                    'We do not use cookies or any tracking technologies.'),
                _sectionTitle('7. Children\'s Privacy'),
                _sectionBody(
                    'Our application is safe for children as it does not collect any personal information.'),
                _sectionTitle('9. Contact Me'),
                _sectionBody(
                    'If you have any questions about this Privacy Policy, please contact me at:\n\nEmail: agkooo.ako36@gmail.com\nPhone: +959 969 687 330\n\nWe will respond to your inquiries within 48 hours.'),
                const SizedBox(height: 40),
                TextButton.icon(
                  onPressed: () => context.go('/'),
                  icon:
                      const Icon(Icons.arrow_back, color: AppTheme.accentColor),
                  label: const Text('Back to Home',
                      style: TextStyle(color: AppTheme.accentColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.accentColor,
        ),
      ),
    );
  }

  Widget _sectionBody(String body) {
    return Text(
      body,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        height: 1.6,
      ),
    );
  }
}
