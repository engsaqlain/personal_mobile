import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import '../providers/cart_provider.dart';
import 'order_confirmation.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  String _paymentMethod = 'Cash on Delivery'; // Default per Section 3.3
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  // Places the order in Firestore following the "orders" schema (Section 5.1)
  void _placeOrder(CartProvider cartProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacingOrder = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      const double deliveryFee = 5.0;
      final double subtotal = cartProvider.totalPrice;
      final double total = subtotal + deliveryFee;

      // Build the order document per the documented schema
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'orderNumber': 'ORD${DateTime.now().millisecondsSinceEpoch}',
        'items': cartProvider.items.map((item) => item.toMap()).toList(),
        'shippingAddress': {
          'street': _streetController.text.trim(),
          'city': _cityController.text.trim(),
          'zip': _zipController.text.trim(),
        },
        'paymentMethod': _paymentMethod,
        'paymentStatus': 'pending',
        'orderStatus': 'pending',
        'subtotal': subtotal,
        'tax': 0,
        'deliveryFee': deliveryFee,
        'totalAmount': total,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear the cart now that the order is placed
      cartProvider.clearCart();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    const double deliveryFee = 5.0;
    final double total = cartProvider.totalPrice + deliveryFee;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.elegantBlack),
        title: Text('Checkout',
            style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.elegantBlack)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shipping Address',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.elegantBlack)),
                const SizedBox(height: 12),
                _buildTextField(_streetController, 'Street Address'),
                const SizedBox(height: 12),
                _buildTextField(_cityController, 'City'),
                const SizedBox(height: 12),
                _buildTextField(_zipController, 'ZIP Code'),
                const SizedBox(height: 24),

                Text('Payment Method',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.elegantBlack)),
                const SizedBox(height: 8),
                _buildPaymentOption('Cash on Delivery'),
                _buildPaymentOption('Credit Card'),
                const SizedBox(height: 24),

                Text('Order Summary',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.elegantBlack)),
                const SizedBox(height: 12),
                _summaryRow('Subtotal', '\$${cartProvider.totalPrice.toStringAsFixed(2)}'),
                _summaryRow('Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
                const Divider(height: 24),
                _summaryRow('Total', '\$${total.toStringAsFixed(2)}', isBold: true),
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
                    onPressed: _isPlacingOrder ? null : () => _placeOrder(cartProvider),
                    child: _isPlacingOrder
                        ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.elegantBlack))
                        : Text('Place Order', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.softGray,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      validator: (value) => (value == null || value.trim().isEmpty) ? '$hint is required' : null,
    );
  }

  Widget _buildPaymentOption(String method) {
    final bool isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.elegantBlack : AppColors.softGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppColors.goldAccent : AppColors.darkGray, size: 20),
            const SizedBox(width: 10),
            Text(method,
                style: GoogleFonts.inter(color: isSelected ? AppColors.white : AppColors.elegantBlack)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkGray)),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: isBold ? 16 : 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: AppColors.elegantBlack)),
        ],
      ),
    );
  }
}