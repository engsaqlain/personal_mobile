import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_mobile/screens/product_detail_screen.dart';
import 'package:personal_mobile/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';
import '../models/product_model.dart';
import '../widgets/common/product_image.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tracks which category chip is currently selected
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          // Single vertical scroll for the whole screen -
          // header, banner, categories, and grid all scroll together
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),));
                },
              ),
              // Cart icon with a badge showing item count.
// Consumer rebuilds only this widget when CartProvider changes
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

  // Hero/promo banner - matches the "Fashionable Every Day" style from the brand design
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
          borderRadius: BorderRadius.circular(
            16,
          ), // Product card radius per Section 7.3
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
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.darkGray),
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
                // Update selected category and rebuild UI to reflect it
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  // Selected chip filled black, others outlined -
                  // matches Section 7.3 Category Button spec
                  color: isSelected
                      ? AppColors.elegantBlack
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppColors.elegantBlack, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.elegantBlack,
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

  // "Best Sellers" heading + product grid
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
          GridView.builder(
            // Grid is inside a ListView, so it must not scroll on its own -
            // shrinkWrap + NeverScrollableScrollPhysics let the outer
            // ListView handle all scrolling instead
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: DummyData.bestSellerProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  2, // 2 products per row, matching reference design
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7, // Controls card height relative to width
            ),
            itemBuilder: (context, index) {
              final product = DummyData.bestSellerProducts[index];
              return _buildProductCard(product);
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
        // TODO: Navigate to ProductDetailScreen, passing this product
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.softGray,
          borderRadius: BorderRadius.circular(
            16,
          ), // Section 7.3 Product Card spec
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
                // Only show old price (strikethrough) if there's an actual discount
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
