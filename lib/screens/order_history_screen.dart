import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.elegantBlack),
        title: Text('My Orders',
            style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.elegantBlack)),
      ),
      // StreamBuilder shows orders in real-time, sorted by newest first
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
                  const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.lightGray),
                  const SizedBox(height: 16),
                  Text('No orders yet', style: GoogleFonts.inter(fontSize: 16, color: AppColors.darkGray)),
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
              final items = List.from(data['items'] ?? []);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        _statusBadge(status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${items.length} item(s)',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.darkGray)),
                    const SizedBox(height: 8),
                    Text('\$${totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.goldAccent)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Color-coded status badge matching the documented order status values:
  // pending, processing, shipped, delivered, cancelled (Section 5.1)
  Widget _statusBadge(String status) {
    Color badgeColor;
    switch (status) {
      case 'delivered':
        badgeColor = Colors.green;
        break;
      case 'shipped':
        badgeColor = Colors.blue;
        break;
      case 'processing':
        badgeColor = Colors.orange;
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = AppColors.darkGray;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: badgeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor),
      ),
    );
  }
}