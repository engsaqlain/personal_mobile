import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.elegantBlack),
        title: Text('Order Tracking',
            style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.elegantBlack)),
      ),
      // Real-time list of the user's orders, each showing a status tracker
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load orders.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkGray),
                ),
              ),
            );
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 64, color: AppColors.lightGray),
                  const SizedBox(height: 16),
                  Text('No orders to track', style: GoogleFonts.inter(fontSize: 16, color: AppColors.darkGray)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final orderNumber = data['orderNumber'] ?? 'N/A';
              final status = data['orderStatus'] ?? 'pending';
              final totalAmount = (data['totalAmount'] ?? 0).toDouble();

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(orderNumber,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('\$${totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.goldAccent)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildStatusTracker(status),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Visual step tracker showing progress through the order lifecycle,
  // per the documented orderStatus values (Section 5.1):
  // pending -> processing -> shipped -> delivered (cancelled shown separately)
  Widget _buildStatusTracker(String currentStatus) {
    // If the order was cancelled, show a distinct cancelled state instead
    // of a progress tracker, since cancellation breaks the normal flow
    if (currentStatus == 'cancelled') {
      return Row(
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Text('Order Cancelled',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.red)),
        ],
      );
    }

    const steps = ['pending', 'processing', 'shipped', 'delivered'];
    final currentIndex = steps.indexOf(currentStatus);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        // Even indices are step circles, odd indices are connecting lines
        if (i.isEven) {
          final stepIndex = i ~/ 2;
          final bool isCompleted = stepIndex <= currentIndex;
          return Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.goldAccent : AppColors.lightGray,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: AppColors.elegantBlack)
                    : null,
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 60,
                child: Text(
                  steps[stepIndex][0].toUpperCase() + steps[stepIndex].substring(1),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isCompleted ? AppColors.elegantBlack : AppColors.darkGray,
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        } else {
          final lineIndex = i ~/ 2;
          final bool isCompleted = lineIndex < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 22),
              color: isCompleted ? AppColors.goldAccent : AppColors.lightGray,
            ),
          );
        }
      }),
    );
  }
}