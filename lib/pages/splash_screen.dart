import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/pages/auth_check_page.dart';

class AnimatedSplashScreenWidget extends StatelessWidget {
  const AnimatedSplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/anim_123.json'),
      ),
      splashIconSize: 200,
      duration: 3000,

      // 🔥 ALWAYS go to AuthCheckPage
      nextScreen: const AuthCheckPage(),
    );
  }
}
