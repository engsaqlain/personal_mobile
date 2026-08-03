import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../utils/dummy_data.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../widgets/common/product_image.dart';
import 'cart_screen.dart';
import 'search_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tracks which category chip is currently selected
  String _selectedCategory = 'All';

  // Handles all Firestore reads for products
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildBanner(),
            const SizedBox(height: 24),
            _buildCategoriesRow(),
            const SizedBox(height: 24),
            _buildBestSellersSection(),
          ],
        ),
      ),
    );
  }

  // Top bar: brand name + search/cart icons
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'PERSONAL',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.elegantBlack,
              letterSpacing: 1.5,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.elegantBlack),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
              ),
              // Cart icon with a live badge showing item count.
              // Consumer rebuilds only this widget when CartProvider changes.
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.elegantBlack),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          );
                        },
                      ),
                      if (cartProvider.itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.goldAccent,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                            child: Text(
                              '${cartProvider.itemCount}',
                              style: const TextStyle(
                                color: AppColors.elegantBlack,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hero/promo banner
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.roseGold, AppColors.softGray],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fashionable',
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.elegantBlack,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Be a part of the fashion revolution',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Horizontal scrollable row of category chips
  Widget _buildCategoriesRow() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: DummyData.categories.length,
        itemBuilder: (context, index) {
          final category = DummyData.categories[index];
          final bool isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.elegantBlack : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppColors.elegantBlack, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.elegantBlack,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // "Best Sellers" heading + real-time product grid from Firestore
  Widget _buildBestSellersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Sellers',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.elegantBlack,
            ),
          ),
          const SizedBox(height: 16),

          // StreamBuilder listens to Firestore in real-time and rebuilds
          // this widget whenever the products collection changes
          StreamBuilder<List<ProductModel>>(
            stream: _productService.getBestSellers(),
            builder: (context, snapshot) {
              // Still waiting for the first batch of data from Firestore
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Something went wrong fetching data
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Could not load products.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkGray),
                    ),
                  ),
                );
              }

              final products = snapshot.data ?? [];

              // No best sellers found in Firestore yet
              if (products.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No products available yet',
                      style: GoogleFonts.inter(color: AppColors.darkGray),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Individual product card - image, name, price
  Widget _buildProductCard(ProductModel product) {
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
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.elegantBlack,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldAccent,
                  ),
                ),
                if (product.oldPrice > 0) ...[
                  const SizedBox(width: 6),
                  Text(
                    '\$${product.oldPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.darkGray,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}