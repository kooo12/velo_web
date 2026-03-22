import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

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
                  'Terms of Service',
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
                _sectionTitle('1. Acceptance of Terms'),
                _sectionBody(
                    'By accessing and using Velo Music ("the Service"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.'),
                _sectionTitle('2. Description of Service'),
                _sectionBody(
                    'Velo Music is a local offline music player that allows users to play audio files stored on their device. Our service includes:\n\n• Playing of local music content\n• Creating and managing local playlists\n• Offline listening capabilities\n\nWe do not provide music streaming, downloading, or cloud storage services.'),
                _sectionTitle('3. User Accounts'),
                _sectionBody(
                    'This application does not require a user account to function. All data, including playlists and preferences, is stored locally on your device. You are responsible for backing up your own data.'),
                _sectionTitle('5. Intellectual Property'),
                _sectionBody(
                    'The service and its original content, features, and functionality are owned by Velo Music. You retain all rights to the audio files stored on your device that you play using this application.'),
                _sectionTitle('6. Content Ownership'),
                _sectionBody(
                    'Velo Music is a tool for playing your own music files. We do not provide, host, or distribute any music content. You comply with all applicable copyright laws regarding the music files you store and play on your device.'),
                _sectionTitle('11. Governing Law'),
                _sectionBody(
                    'These terms shall be governed by and construed in accordance with the laws of Myanmar.'),
                _sectionTitle('12. Contact Information'),
                _sectionBody(
                    'If you have any questions about these Terms of Service, please contact me at:\n\nEmail: agkooo.ako36@gmail.com\nPhone: +959 969 687 330'),
                const SizedBox(height: 40),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
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
