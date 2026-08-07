import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 80, color: AppColors.goldAccent),
                const SizedBox(height: 20),
                Text('Order Placed!',
                    style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.elegantBlack)),
                const SizedBox(height: 8),
                Text('Thank you for shopping with us.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkGray)),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: AppColors.elegantBlack,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                      );
                    },
                    child: Text('Continue Shopping', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}