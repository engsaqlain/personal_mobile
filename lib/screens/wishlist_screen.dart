import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../models/product_model.dart';
import '../services/wishlist_service.dart';
import '../services/product_service.dart';
import '../widgets/common/product_image.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistService = WishlistService();
    final productService = ProductService();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.elegantBlack),
        title: Text('Wishlist',
            style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.elegantBlack)),
      ),
      // First stream gets the wishlisted product IDs, then we filter
      // the full product list against those IDs
      body: StreamBuilder<List<String>>(
        stream: wishlistService.getWishlistProductIds(),
        builder: (context, wishlistSnapshot) {
          if (wishlistSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final wishlistedIds = wishlistSnapshot.data ?? [];

          if (wishlistedIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: AppColors.lightGray),
                  const SizedBox(height: 16),
                  Text('Your wishlist is empty', style: GoogleFonts.inter(fontSize: 16, color: AppColors.darkGray)),
                ],
              ),
            );
          }

          return StreamBuilder<List<ProductModel>>(
            stream: productService.getProducts(),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allProducts = productSnapshot.data ?? [];
              // Only keep products whose ID is in the wishlist
              final wishlistedProducts =
              allProducts.where((p) => wishlistedIds.contains(p.productId)).toList();

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: wishlistedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = wishlistedProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.softGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ProductImage(images: product.images, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('\$${product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                  fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldAccent)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}