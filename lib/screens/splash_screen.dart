import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import 'onboarding_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // Timer navigates to Onboarding screen after 3 seconds
  void initState() {
    super.initState();
    Timer(const Duration(
      seconds: 3),  (){
      if(mounted){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()));
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
