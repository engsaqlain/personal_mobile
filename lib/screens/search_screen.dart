import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../widgets/common/product_image.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  // Holds ALL products fetched once from Firestore when this screen opens
  List<ProductModel> _allProducts = [];

  // Holds the currently filtered results based on search text
  List<ProductModel> _filteredProducts = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Fetches all products from Firestore once when the screen opens.
  // We take the first value from the stream since search doesn't need
  // to stay live-updated while the user is typing.
  void _loadProducts() async {
    try {
      final products = await _productService.getProducts().first;
      setState(() {
        _allProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Runs on every keystroke - filters the already-loaded product list by name
  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() => _filteredProducts = []);
      return;
    }

    final results = _allProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() => _filteredProducts = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.elegantBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _onSearchChanged,
                      style: GoogleFonts.inter(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: GoogleFonts.inter(color: AppColors.lightGray, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.softGray,
                        prefixIcon: const Icon(Icons.search, color: AppColors.darkGray),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.close, color: AppColors.darkGray),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildResultsArea()),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    // Still loading the initial product list from Firestore
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.trim().isEmpty) {
      return Center(
        child: Text(
          'Search for hoodies, shirts, and more',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkGray),
        ),
      );
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppColors.lightGray),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkGray),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: ProductImage(images: product.images),
            ),
          ),
          title: Text(
            product.name,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.goldAccent, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
            );
          },
        );
      },
    );
  }
}
