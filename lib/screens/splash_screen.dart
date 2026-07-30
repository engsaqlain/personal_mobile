import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Check Firebase directly for a currently signed-in user
        final User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // User is already logged in - skip straight past onboarding/login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // No user session found - show onboarding as normal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
       gradient: LinearGradient(
         begin:  Alignment.topCenter,
         end: Alignment.bottomCenter,
         colors: [
           AppColors.roseGold,
           AppColors.softGray,
         ]
       )
       ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text('PERSONAL', style: GoogleFonts.playfairDisplay(
                 fontSize: 36,
                 fontWeight: FontWeight.bold,
                 color: AppColors.elegantBlack,
                 letterSpacing: 2,
               )
          ),
              const SizedBox(height: 12,),
              Text('Be a part of fashion revolution',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.darkGray,
              )
              )
              ]
          )
        )
    ),

    );
  }
}
