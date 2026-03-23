import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:velo_web/widgets/feature_marquee.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/faq_accordion.dart';
import '../widgets/floating_navbar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _downloadKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // const SizedBox(height: 100),
                _buildHero(key: _heroKey),
                _buildAbout(key: _aboutKey),
                _buildFeatures(key: _featuresKey),
                _buildScreenshots(),
                _buildFAQ(key: _faqKey),
                _buildDownloadSection(key: _downloadKey),
                _buildContact(),
                _buildFooter(),
              ],
            ),
          ),
          FloatingNavbar(
            onDownloadPressed: () => _scrollTo(_downloadKey),
            onNavLinkPressed: (label) {
              if (label == 'Home') _scrollTo(_heroKey);
              if (label == 'About') _scrollTo(_aboutKey);
              if (label == 'Features') _scrollTo(_featuresKey);
              if (label == 'FAQ') _scrollTo(_faqKey);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHero({Key? key}) {
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isMobile
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        _heroText(),
                        const SizedBox(height: 50),
                        _heroImage(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 12, child: _heroText()),
                        const Spacer(flex: 1),
                        Expanded(flex: 10, child: _heroImage()),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _heroText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _badge('Premium Music Experience'),
        const SizedBox(height: 24),
        Text(
          'Premium-grade offline music player.',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.5,
            height: 1.1,
            color: Colors.white,
            shadows: [
              Shadow(color: AppTheme.accentColor.withAlpha(50), blurRadius: 20),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
        const SizedBox(height: 24),
        Text(
          'With sleep timer, smart library management, no Ads and responsive design. Experience music like never before with advanced features and beautiful UI.',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withAlpha(180),
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 800.ms),
        const SizedBox(height: 48),
        _gradientButton('Download Now', Icons.download,
            onPressed: () => _scrollTo(_downloadKey)),
      ],
    );
  }

  Widget _heroImage() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withAlpha(40),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/hero.png',
            fit: BoxFit.contain,
            height: 600,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                  begin: 0,
                  end: -20,
                  duration: 3.seconds,
                  curve: Curves.easeInOutSine)
          // .fadeIn(duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentColor.withAlpha(50)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _gradientButton(String label, IconData icon,
      {required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentColor, AppTheme.accentColor.withAlpha(150)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withAlpha(100),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildAbout({Key? key}) {
    return _sectionWrapper(
      key: key,
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return isMobile
            ? Column(
                children: [
                  _missionCard(),
                  const SizedBox(height: 64),
                  _aboutValuesList(),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 12, child: _missionCard()),
                  const Spacer(flex: 2),
                  Expanded(flex: 10, child: _aboutValuesList()),
                ],
              );
      }),
    );
  }

  Widget _missionCard() {
    return Container(
      padding: const EdgeInsets.all(64),
      decoration: BoxDecoration(
        color: AppTheme.forestMistStart,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OUR MISSION',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 4,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 32),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                height: 1.1,
                fontFamily: 'Outfit',
                color: Colors.white,
              ),
              children: [
                const TextSpan(text: 'Sonic Fidelity for\n'),
                TextSpan(
                  text: 'Everyone',
                  style: TextStyle(color: Colors.cyanAccent.shade400),
                ),
                const TextSpan(text: ',\nEverywhere.'),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Velo Music was born from a simple realization: the digital age has made music more accessible, but often at the cost of its soul. In the rush to stream everything, we lost the depth, the clarity, and the ownership of our listening experience.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Our journey began in a small studio, driven by a collective of engineers and artists who believed that high-fidelity sound shouldn’t be a luxury tethered to a fiber optic cable. We built Velo to be the ultimate vessel for your personal library—a sanctuary where technology serves the art.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child:
                    const Icon(Icons.music_note, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Velo Collective',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'FOUNDED 2026',
                    style: TextStyle(
                        color: Colors.white38, fontSize: 12, letterSpacing: 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aboutValuesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _aboutValueItem(
          Icons.waves,
          'Pure Signal Path',
          'We optimize every step of the audio processing pipeline to ensure zero-loss delivery from file to ear.',
        ),
        _aboutValueItem(
          Icons.search_rounded,
          'Limitless Discovery',
          'Your library is your legacy. We provide the tools to organize, tag, and rediscover your music like never before.',
        ),
        _aboutValueItem(
          Icons.security_rounded,
          'Privacy by Design',
          'No tracking, no data mining. Your listening habits are yours alone. We just provide the stage.',
        ),
        _aboutValueItem(
          Icons.timer,
          'Sleep Timer',
          'Set a timer to automatically stop playback after a specified duration up to 2 hours.',
        ),
        _aboutValueItem(
          Icons.ads_click_outlined,
          'No Ads',
          'No ads, no in-app purchases, no subscriptions. Just music.',
        ),
      ],
    );
  }

  Widget _aboutValueItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.white54, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures({Key? key}) {
    return _sectionWrapper(
      key: key,
      maxWidth: 2000,
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THE ECOSYSTEM',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        fontFamily: 'Outfit',
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: 'Engineered for the\n'),
                        TextSpan(
                          text: 'Audiophile',
                          style: TextStyle(color: Color(0xFFFF4081)),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We stripped away the noise to leave only the music. Precision tools for your sonic journey.',
                    style: TextStyle(
                      color: Colors.white.withAlpha(150),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 85.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THE ECOSYSTEM',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 14,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                fontFamily: 'Outfit',
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(text: 'Engineered for the\n'),
                                TextSpan(
                                  text: 'Audiophile',
                                  style: TextStyle(color: Color(0xFFFF4081)),
                                ),
                                TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'We stripped away the noise to leave only the music. Precision tools for your sonic journey.',
                          style: TextStyle(
                            color: Colors.white.withAlpha(150),
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 80),
            FeatureMarquee(
              speed: 40,
              children: [
                _featureMarqueeCard(
                  'Offline Playback',
                  'Your library, available anywhere regardless of connection.',
                  Icons.wifi_off_rounded,
                  Colors.cyanAccent,
                ),
                _featureMarqueeCard(
                  'Gapless Playback',
                  'Transition between tracks without a heartbeat of silence.',
                  Icons.all_inclusive_rounded,
                  Colors.blueAccent,
                ),
                _featureMarqueeCard(
                  'Smart Playlists',
                  'AI-driven discovery that adapts to your environment.',
                  Icons.auto_awesome_rounded,
                  const Color(0xFFFF4081),
                ),
                _featureMarqueeCard(
                  'Premium Themes',
                  'Choose from handcrafted visual styles and dark modes.',
                  Icons.palette_rounded,
                  Colors.purpleAccent,
                ),
                _featureMarqueeCard(
                  'Global Radio',
                  'Access thousands of worldwide radio stations directly.',
                  Icons.radio_rounded,
                  Colors.blueAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
            FeatureMarquee(
              speed: 40,
              reverse: true,
              children: [
                _featureMarqueeCard(
                  'Dual Language',
                  'Full support for both Myanmar and English languages.',
                  Icons.translate_rounded,
                  Colors.greenAccent,
                ),
                _featureMarqueeCard(
                  'Smart Alerts',
                  'Total control over notifications and sleep timer alerts.',
                  Icons.notifications_active_rounded,
                  Colors.redAccent,
                ),
                _featureMarqueeCard(
                  'Sleep Timer',
                  'Automatically stop playback during quiet hours.',
                  Icons.timer_rounded,
                  Colors.tealAccent,
                ),
                _featureMarqueeCard(
                  'Pure Interface',
                  'A minimalist workspace designed for rhythmic flow.',
                  Icons.devices_other_rounded,
                  Colors.indigoAccent,
                ),
                _featureMarqueeCard(
                  'High Quality',
                  'Support for FLAC, WAV and high-bitrate MP3.',
                  Icons.high_quality_rounded,
                  Colors.amberAccent,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _featureMarqueeCard(
      String title, String desc, IconData icon, Color accentColor) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
                color: Colors.white.withAlpha(150), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _bentoCard({
    required String title,
    required String desc,
    required IconData icon,
    bool isLarge = false,
    bool showMockup = false,
    IconData? bgIcon,
    Color? iconColor,
    bool isMobile = false,
  }) {
    return Container(
      height: isMobile ? null : (isLarge ? 400 : 368),
      constraints: isMobile ? const BoxConstraints(minHeight: 280) : null,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (bgIcon != null && !isMobile)
            Positioned(
              right: -40,
              bottom: -40,
              child: Opacity(
                opacity: 0.05,
                child: Icon(bgIcon, size: 280, color: Colors.white),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.white).withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor ?? Colors.white, size: 24),
              ),
              const SizedBox(height: 22),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 28 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: (!isMobile && isLarge) ? 300 : null,
                child: Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white.withAlpha(150),
                    fontSize: isMobile ? 16 : 18,
                    height: 1.5,
                  ),
                ),
              ),
              if (isMobile && showMockup)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Transform.rotate(
                      angle: 0.05,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(100),
                              blurRadius: 40,
                              offset: const Offset(10, 20),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/hero.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (!isMobile && showMockup)
            Positioned(
              right: -20,
              top: 40,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 40,
                        offset: const Offset(10, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/hero.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScreenshots() {
    return _sectionWrapper(
      child: Column(
        children: [
          const Text('Beautiful Design',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 64),
          SizedBox(
            height: 500,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(width: 40),
              itemBuilder: (context, index) {
                return AspectRatio(
                  aspectRatio: 9 / 19.5,
                  child: GlassContainer(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_iphone,
                              size: 48,
                              color: AppTheme.accentColor.withAlpha(100)),
                          const SizedBox(height: 16),
                          Text('View ${index + 1}',
                              style: const TextStyle(color: Colors.white38)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ({Key? key}) {
    return _sectionWrapper(
      key: key,
      child: const Column(
        children: [
          Text('Common Questions',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          SizedBox(height: 64),
          FAQAccordion(
              question: 'Is it free?',
              answer:
                  'Yes, Velo is completely free to use without any ads or subscriptions.'),
          FAQAccordion(
              question: 'Does it support local files?',
              answer:
                  'Velo is designed specifically for local files, including FLAC, MP3, and WAV.'),
          FAQAccordion(
              question: 'How are recommendations generated?',
              answer:
                  'Recommendations are processed entirely on-device using smart algorithms based on your listening habits.'),
        ],
      ),
    );
  }

  Widget _buildDownloadSection({Key? key}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: GlassContainer(
            padding: const EdgeInsets.all(64),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.qr_code_2,
                      size: 160, color: Colors.black),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Scan QR Code',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Scan this QR code with your mobile device to download',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withAlpha(150), fontSize: 16),
                ),
                const SizedBox(height: 48),
                _gradientButton('Direct Download', Icons.download,
                    onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContact() {
    return _sectionWrapper(
      child: GlassContainer(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            const Text('Support',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('agkooo.ako36@gmail.com',
                style: TextStyle(fontSize: 18, color: AppTheme.accentColor)),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.telegram, size: 32)),
                const SizedBox(width: 24),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.link, size: 32)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Velo Music',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(
                  'Professional-grade offline music player with advanced features like sleep timer, smart library management, and responsive design.',
                  style: TextStyle(
                      color: Colors.white.withAlpha(120), height: 1.5),
                ),
                const SizedBox(height: 32),
                const Text('© 2026 Velo Music. All rights reserved.',
                    style: TextStyle(color: Colors.white38)),
              ],
            ),
          ),
          const SizedBox(width: 80),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Terms',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _footerLink('Privacy Policy', () => context.go('/privacy')),
              _footerLink('Terms of Service', () => context.go('/terms')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Text(label, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _sectionWrapper(
      {required Widget child, Key? key, double maxWidth = 1200}) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      key: key,
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: 50, vertical: isMobile ? 20 : 100),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
