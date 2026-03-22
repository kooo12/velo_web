import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VeloWebApp());
}

class VeloWebApp extends StatelessWidget {
  const VeloWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Velo Music Player | Privacy, Speed, Premium UI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.forestMistGradient,
                  ),
                ),
              ),
              if (child != null) child,
            ],
          ),
        );
      },
    );
  }
}
