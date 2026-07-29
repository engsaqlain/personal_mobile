import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../models/onboarding_model.dart';
import 'login_screen.dart'; // Navigate here after onboarding finishes

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}
class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controls which page is currently visible and allows programmatic navigation
  final PageController _pageController = PageController();

  // Tracks the current slide index (0, 1, or 2)
  int _currentIndex = 0;

  // Onboarding content list - separated from UI for easy editing/reuse
  final List<OnboardingModel> _slides = [
    OnboardingModel(
      title: 'Fashionable Every Day',
      description:
      'Discover trendy, high-quality apparel curated just for you.',
      imagePath: 'assets/images/onboarding1.png',
    ),
    OnboardingModel(
      title: 'Personalized Styling',
      description:
      'Get AI-powered outfit suggestions based on your unique style.',
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingModel(
      title: 'Shop Anytime, Anywhere',
      description:
      'Enjoy a seamless 24/7 shopping experience from your phone.',
      imagePath: 'assets/images/onboarding3.png',
    ),
  ];

  // Dispose the controller when this screen is removed to avoid memory leaks
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Navigates to the Login screen, replacing Onboarding in the stack
  // so the user can't swipe/navigate back to onboarding after finishing
  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button - top right, lets user bypass onboarding
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _goToLogin,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      color: AppColors.darkGray,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            // PageView takes remaining space and shows swipeable slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                // Fires whenever the user swipes to a new page
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Slide image - uses asset path from model
                        Image.asset(
                          slide.imagePath,
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.elegantBlack,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots indicator - shows which slide is currently active
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  // Active dot is wider than inactive dots
                  width: _currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.goldAccent
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: AppColors.elegantBlack,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Per Section 7.3 button spec
                    ),
                  ),
                  onPressed: () {
                    // If on the last slide, go to login; otherwise, animate to next page
                    if (_currentIndex == _slides.length - 1) {
                      _goToLogin();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentIndex == _slides.length - 1 ? 'Get Started' : 'Next',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}