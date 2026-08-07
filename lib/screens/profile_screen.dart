import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';
import 'ai_chat_screen.dart';
import 'ai_outfit_screen.dart';
import 'order_history_screen.dart';
import 'order_tracking_screen.dart';
import 'wishlist_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.elegantBlack),
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.elegantBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // User info header
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.softGray,
                  child: Text(
                    // Shows the first letter of the email as a simple avatar
                    (user?.email?.isNotEmpty ?? false) ? user!.email![0].toUpperCase() : '?',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.elegantBlack),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? 'Guest',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.elegantBlack),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text('PERSONAL Member', style: GoogleFonts.inter(fontSize: 13, color: AppColors.darkGray)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Navigation menu items
            _menuItem(
              context,
              icon: Icons.receipt_long_outlined,
              label: 'Order History',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              ),
            ),
            _menuItem(
              context,
              icon: Icons.local_shipping_outlined,
              label: 'Track Order',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderTrackingScreen()),
              ),
            ),
            _menuItem(
              context,
              icon: Icons.favorite_border,
              label: 'Wishlist',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              ),
            ),
            _menuItem(
              context,
              icon: Icons.auto_awesome,
              label: 'AI Stylist',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiChatScreen()),
              ),
            ),
            _menuItem(
              context,
              icon: Icons.checkroom,
              label: 'AI Outfit Generator',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiOutfitScreen()),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // Logout
            _menuItem(
              context,
              icon: Icons.logout,
              label: 'Logout',
              iconColor: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  // Clear the entire navigation stack so the user
                  // can't press back into the app after logging out
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        Color? iconColor,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.elegantBlack, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: iconColor ?? AppColors.elegantBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.lightGray),
          ],
        ),
      ),
    );
  }
}