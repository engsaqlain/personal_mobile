import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';
import '../models/product_model.dart';
import '../widgets/common/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back button and wishlist icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.elegantBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: AppColors.elegantBlack),
                    onPressed: () {
                      // TODO: Add to wishlist via Firestore
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Container(
                      height: 320,
                      width: double.infinity,
                      color: AppColors.softGray,
                      child: ProductImage(images: product.images, fit: BoxFit.contain),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.elegantBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldAccent,
                                ),
                              ),
                              if (product.oldPrice > 0) ...[
                                const SizedBox(width: 10),
                                Text(
                                  '\$${product.oldPrice.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: AppColors.darkGray,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            product.description.isNotEmpty
                                ? product.description
                                : 'No description available.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.darkGray,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Size selector
                          if (product.sizes.isNotEmpty) ...[
                            Text('Size',
                                style: GoogleFonts.inter(
                                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.elegantBlack)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: product.sizes.map((size) {
                                final bool isSelected = _selectedSize == size;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedSize = size),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.elegantBlack : Colors.transparent,
                                      border: Border.all(color: AppColors.elegantBlack),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      size,
                                      style: GoogleFonts.inter(
                                        color: isSelected ? AppColors.white : AppColors.elegantBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Color selector
                          if (product.colors.isNotEmpty) ...[
                            Text('Color',
                                style: GoogleFonts.inter(
                                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.elegantBlack)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: product.colors.map((color) {
                                final bool isSelected = _selectedColor == color;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedColor = color),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.elegantBlack : Colors.transparent,
                                      border: Border.all(color: AppColors.elegantBlack),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      color,
                                      style: GoogleFonts.inter(
                                        color: isSelected ? AppColors.white : AppColors.elegantBlack,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Quantity selector
                          Text('Quantity',
                              style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.elegantBlack)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _quantityButton(Icons.remove, () {
                                if (_quantity > 1) setState(() => _quantity--);
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  '$_quantity',
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              _quantityButton(Icons.add, () {
                                setState(() => _quantity++);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom "Add to Cart" bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: AppColors.elegantBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Require size/color selection before adding to cart,
                    // but only if the product actually has size/color options
                    if (product.sizes.isNotEmpty && _selectedSize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a size')),
                      );
                      return;
                    }
                    if (product.colors.isNotEmpty && _selectedColor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a color')),
                      );
                      return;
                    }

                    // Actually add the item to the cart via CartProvider
                    context.read<CartProvider>().addToCart(
                      product: product,
                      size: _selectedSize ?? 'One Size',
                      color: _selectedColor ?? 'Default',
                      quantity: _quantity,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart!')),
                    );
                  },
                  child: Text('Add to Cart',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.elegantBlack),
      ),
    );
  }
}