import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:velo_web/widgets/feature_marquee.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/faq_accordion.dart';
import '../widgets/floating_navbar.dart';

import '../providers/faq/faq_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _downloadKey = GlobalKey();
  final GlobalKey _demoKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // ui_web.platformViewRegistry.registerViewFactory(
    //   'velo-demo',
    //   (int viewId) => web.HTMLIFrameElement()
    //     ..src = 'https://velo-live-demo.web.app/'
    //     ..style.border = 'none'
    //     ..style.width = '100%'
    //     ..style.height = '100%',
    // );
  }

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: _buildHero(key: _heroKey)),
              SliverToBoxAdapter(child: _buildAbout(key: _aboutKey)),
              SliverToBoxAdapter(child: _buildFeatures(key: _featuresKey)),
              SliverToBoxAdapter(child: _buildAppDemo(key: _demoKey)),
              SliverToBoxAdapter(child: _buildFAQ(key: _faqKey)),
              SliverToBoxAdapter(child: _buildDownloadSection(key: _downloadKey)),
              SliverToBoxAdapter(child: _buildFooter()),
            ],
          ),
          FloatingNavbar(
            onDownloadPressed: () => _scrollTo(_downloadKey),
            onNavLinkPressed: (label) {
              if (label == 'Home') _scrollTo(_heroKey);
              if (label == 'About') _scrollTo(_aboutKey);
              if (label == 'Features') _scrollTo(_featuresKey);
              if (label == 'Demo') _scrollTo(_demoKey);
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
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 50, vertical: 50),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isMobile
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        _heroText(),
                        const SizedBox(height: 50),
                        _heroImage(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 12, child: _heroText()),
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                              child: _heroImage(),
                            )),
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
    return GestureDetector(
      onTap: () => _scrollTo(_demoKey),
      child: RepaintBoundary(
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
              'assets/images/home_screen.png',
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
      padding: const EdgeInsets.all(34),
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
              // Container(
              //   width: 56,
              //   height: 56,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     border: Border.all(color: Colors.white24, width: 2),
              //   ),
              //   child:
              //       const Icon(Icons.music_note, color: Colors.white, size: 24),
              // ),
              Image.asset(
                'assets/images/app_icon.png',
                width: 56,
                height: 56,
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
                            'assets/images/home_screen.png',
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
                      'assets/images/home_screen.png',
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

  Widget _buildAppDemo({Key? key}) {
    return _sectionWrapper(
      key: key,
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return Column(
          children: [
            const Text('Experience Velo',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Text(
              'Try the live interactive demo below to see how Velo transforms your music experience.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white.withAlpha(150), fontSize: 18),
            ),
            const SizedBox(height: 64),
            isMobile
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            launchWeb('https://velo-live-demo.web.app'),
                        child: Image.asset(
                          'assets/images/home_screen.png',
                          fit: BoxFit.contain,
                          height: 600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          _demoButton(),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: 300,
                            child: Text(
                              'Experience the full interface right in your browser. Test the fluid animations, explore the layout, and see why Velo is the choice for audiophiles.',
                              style: TextStyle(
                                color: Colors.white.withAlpha(150),
                                fontSize: 16,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            launchWeb('https://velo-live-demo.web.app'),
                        child: Image.asset(
                          'assets/images/home_screen.png',
                          fit: BoxFit.contain,
                          height: 600,
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Column(
                        children: [
                          _demoButton(),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: 300,
                            child: Text(
                              'Experience the full interface right in your browser. Test the fluid animations, explore the layout, and see why Velo is the choice for audiophiles.',
                              style: TextStyle(
                                color: Colors.white.withAlpha(150),
                                fontSize: 16,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
          ],
        );
      }),
    );
  }

  Widget _demoButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchWeb('https://velo-live-demo.web.app'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.forestMistStart,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.link, color: Colors.white, size: 24),
              SizedBox(width: 16),
              Text(
                'Try Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchWeb(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildFAQ({Key? key}) {
    return _sectionWrapper(
      key: key,
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _faqHeader(),
                  const SizedBox(height: 48),
                  _faqForm(),
                  const SizedBox(height: 64),
                  _faqList(),
                  const SizedBox(height: 32),
                  _socialLinks(),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _faqHeader(),
                        const SizedBox(height: 48),
                        _faqForm(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 80),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _faqList(),
                        const SizedBox(height: 32),
                        _socialLinks(),
                      ],
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget _faqHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _badge('FAQ'),
        const SizedBox(height: 24),
        const Text(
          'Common\nQuestions',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
            height: 1.1,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Everything you need to know about Velo. Can\'t find the answer? Reach out to our support team.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withAlpha(150),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _faqForm() {
    final faqState = ref.watch(faqProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(32),
      radius: 32,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ask a Question',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Can\'t find what you\'re looking for? Ask us directly.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(150),
              ),
            ),
            const SizedBox(height: 32),
            _customTextField(
              controller: _nameController,
              label: 'Name',
              hint: 'John Doe',
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 20),
            _customTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'john@example.com',
              icon: Icons.email_outlined,
              validator: (v) {
                if (v!.isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _customTextField(
              controller: _questionController,
              label: 'Question',
              hint: 'How do I...',
              icon: Icons.help_outline,
              maxLines: 4,
              validator: (v) =>
                  v!.isEmpty ? 'Please enter your question' : null,
            ),
            const SizedBox(height: 32),
            if (faqState.submissionSuccess)
              _buildSuccessMessage()
            else if (faqState.submissionError != null)
              _buildErrorMessage(faqState.submissionError!)
            else
              SizedBox(
                width: double.infinity,
                child: _gradientButton(
                  faqState.isSubmitting ? 'Sending...' : 'Send Message',
                  faqState.isSubmitting
                      ? Icons.hourglass_empty
                      : Icons.send_rounded,
                  onPressed: faqState.isSubmitting ? () {} : _submitQuestion,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.greenAccent.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.greenAccent.withAlpha(50)),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: Colors.greenAccent, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Message Sent!',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ll get back to you as soon as possible.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => ref.read(faqProvider.notifier).reset(),
            child: const Text('Send another',
                style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    ).animate().fadeIn().scale(delay: 100.ms);
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.redAccent.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withAlpha(50)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          _gradientButton(
            'Try Again',
            Icons.refresh_rounded,
            onPressed: _submitQuestion,
          ),
        ],
      ),
    ).animate().shake();
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withAlpha(60)),
            prefixIcon: Icon(icon,
                color: AppTheme.accentColor.withAlpha(150), size: 20),
            filled: true,
            fillColor: Colors.white.withAlpha(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withAlpha(20)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withAlpha(20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.accentColor),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

  Future<void> _submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(faqProvider.notifier).submitQuestion(
            name: _nameController.text,
            email: _emailController.text,
            question: _questionController.text,
          );

      final state = ref.read(faqProvider);
      if (state.submissionSuccess) {
        _nameController.clear();
        _emailController.clear();
        _questionController.clear();
      }
    }
  }

  Widget _faqList() {
    return const Column(
      children: [
        FAQAccordion(
          question: 'Is Velo really free?',
          answer:
              'Yes, Velo is 100% free. No ads, no subscriptions, no locked features. We believe great tools should be accessible to everyone.',
        ),
        FAQAccordion(
          question: 'What audio formats are supported?',
          answer:
              'Velo supports a wide range of formats including FLAC, MP3, WAV, AAC, and OGG. It is optimized for high-resolution lossless playback.',
        ),
        FAQAccordion(
          question: 'How does the recommendation engine work?',
          answer:
              'Our smart algorithms analyze your listening habits entirely on-device. Your data never leaves your phone, ensuring complete privacy while providing personalized discovery.',
        ),
        FAQAccordion(
          question: 'Does it support Hi-Res audio?',
          answer:
              'Absolutely. Velo is designed for audiophiles and supports bit-perfect playback for high-resolution formats like FLAC and WAV up to 24-bit/192kHz.',
        ),
        FAQAccordion(
          question: 'Can I use Velo on multiple devices?',
          answer:
              'Velo is available for Android only. Since it\'s an offline player, your local library is managed on each device independently.',
        ),
        FAQAccordion(
          question: 'Is there a sleep timer?',
          answer:
              'Yes, there is a built-in sleep timer. You can set it to turn off your music automatically after a set duration, perfect for listening before bed.',
        ),
        FAQAccordion(
          question: 'How do I import my music?',
          answer:
              'Velo automatically scans your device\'s "Music" folder. You can also manually add specific folders to scan in the app settings.',
        ),
        // FAQAccordion(
        //   question: 'Does it support lyrics?',
        //   answer:
        //       'Yes! Velo supports both embedded lyrics in audio files and external .lrc files stored in the same folder as your music.',
        // ),
        FAQAccordion(
          question: 'What makes Velo different from other players?',
          answer:
              'Velo combines a premium, high-fidelity audio engine with a beautiful, modern interface and a strict "no-tracking" privacy policy.',
        ),
      ],
    );
  }

  Widget _socialLinks() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _socialIconButton(FontAwesomeIcons.telegram, 'Telegram',
            () => _launchURL('https://t.me/kooo2109')),
        _socialIconButton(
            FontAwesomeIcons.linkedin,
            'LinkedIn',
            () => _launchURL(
                'https://www.linkedin.com/in/aung-ko-oo-042342242/')),
        _socialIconButton(FontAwesomeIcons.facebook, 'Facebook',
            () => _launchURL('https://facebook.com/kooo1210')),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Widget _socialIconButton(IconData icon, String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(20)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadSection({Key? key}) {
    return _sectionWrapper(
      key: key,
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 80 : 10,
            horizontal: 24,
          ),
          child: Column(
            children: [
              _badge('Download'),
              const SizedBox(height: 24),
              const Text(
                'Get Velo Now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Experience your music like never before. High-fidelity, private, and beautiful.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withAlpha(150),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 64),
              isMobile
                  ? Column(
                      children: [
                        _buildDownloadCard(isMobile),
                        const SizedBox(height: 38),
                        _buildQRCodeCard(isMobile),
                      ],
                    )
                  : IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _buildDownloadCard(isMobile)),
                          const SizedBox(width: 48),
                          Expanded(child: _buildQRCodeCard(isMobile)),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDownloadCard(bool isMobile) {
    return GlassContainer(
      padding: const EdgeInsets.all(38),
      radius: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ready to start?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Download Velo for Android and start your high-fidelity music journey today.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(150),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _directDownloadButton(isMobile),
          const SizedBox(height: 24),
          _playStoreButton(isMobile),
        ],
      ),
    );
  }

  Widget _buildQRCodeCard(bool isMobile) {
    return GlassContainer(
      padding: const EdgeInsets.all(38),
      radius: 40,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentColor.withAlpha(50),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                // onTap: () => _launchURL(
                //     'https://play.google.com/store/apps/details?id=com.ako.velo'),
                onTap: () => _showComingSoonMessage(isMobile),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/qr_play_store.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Visit Play Store',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan to view Velo on the Google Play Store (Coming Soon).',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }

  Widget _directDownloadButton(bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(
            'https://drive.google.com/file/d/1P1x_WECFmsY2DSPZcXofZXvr9SZVyqWA/view?usp=share_link'),
        child: const GlassContainer(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            radius: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FontAwesomeIcons.download, color: Colors.white, size: 24),
                SizedBox(width: 16),
                Text('Direct Download'),
              ],
            )),
      ),
    );
  }

  Widget _playStoreButton(bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        // onTap: () => _launchURL(
        //     'https://play.google.com/store/apps/details?id=com.ako.velo'),
        onTap: () => _showComingSoonMessage(isMobile),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FontAwesomeIcons.googlePlay,
                  color: Colors.white, size: 24),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GET IT ON',
                    style: TextStyle(
                      color: Colors.white.withAlpha(150),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const Text(
                    'Google Play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonMessage(bool isMobile) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: GlassContainer(
          width: isMobile ? 320 : 400,
          padding: const EdgeInsets.all(32),
          radius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FontAwesomeIcons.clock, color: Colors.amber, size: 48),
              const SizedBox(height: 24),
              const Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are currently in the Google Play Store review process. Stay tuned for the official release!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              _gradientButton(
                'Got it!',
                Icons.check,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ).animate().fadeIn().scale(),
    );
  }

  Widget _buildFooter() {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 50, vertical: isMobile ? 20 : 80),
      child: isMobile
          ? Column(
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
                const SizedBox(height: 12),
                const Text('© 2026 Velo Music. All rights reserved.',
                    style: TextStyle(color: Colors.white38)),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Velo Music',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
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
                SizedBox(width: isMobile ? 10 : 80),
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
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 50, vertical: isMobile ? 20 : 100),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
