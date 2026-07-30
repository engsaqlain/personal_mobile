import '../models/product_model.dart';
// Represents a single product, matching the Firestore "products" collection
// schema defined in Section 5.1 of the project documentation
class ProductModel {
  final String productId;
  final String name;
  final String description;
  final double price;
  final double oldPrice;
  final String category; // hoodies, shirts, trousers, pants, cap
  final String collection; // 2022, 2023, 2024, 2025
  final List<String> images;
  final List<String> sizes; // S, M, L, XL, XXL
  final List<String> colors;
  final int stock;
  final bool isBestSeller;
  final bool isAvailable;
  final double averageRating;
  final DateTime? createdAt;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.collection,
    required this.images,
    required this.sizes,
    required this.colors,
    required this.stock,
    required this.isBestSeller,
    required this.isAvailable,
    required this.averageRating,
    this.createdAt,
  });

  // Converts Firestore document data (a Map) into a ProductModel object.
  // This will be used later when we fetch real data from Firestore.
  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      productId: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      oldPrice: (map['oldPrice'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      collection: map['collection'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      stock: map['stock'] ?? 0,
      isBestSeller: map['isBestSeller'] ?? false,
      isAvailable: map['isAvailable'] ?? true,
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      createdAt: map['createdAt']?.toDate(),
    );
  }
}
class DummyData {
  static List<ProductModel> bestSellerProducts = [
    ProductModel(
      productId: '1',
      name: 'Oversized Pink Hoodie',
      description: 'A cozy oversized hoodie perfect for everyday wear.',
      price: 45.99,
      oldPrice: 59.99,
      category: 'hoodies',
      collection: '2025',
      images: ['assets/images/onboarding1.png'],
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Pink', 'Black'],
      stock: 20,
      isBestSeller: true,
      isAvailable: true,
      averageRating: 4.5,
    ),
    ProductModel(
      productId: '2',
      name: 'Classic White Shirt',
      description: 'A timeless white shirt for any occasion.',
      price: 29.99,
      oldPrice: 0,
      category: 'shirts',
      collection: '2024',
      images: ['assets/images/onboarding2.png'],
      sizes: ['S', 'M', 'L'],
      colors: ['White'],
      stock: 15,
      isBestSeller: true,
      isAvailable: true,
      averageRating: 4.2,
    ),
    ProductModel(
      productId: '3',
      name: 'Slim Fit Trousers',
      description: 'Comfortable slim fit trousers.',
      price: 39.99,
      oldPrice: 49.99,
      category: 'trousers',
      collection: '2025',
      images: ['assets/images/onboarding3.png'],
      sizes: ['M', 'L', 'XL'],
      colors: ['Beige', 'Grey'],
      stock: 10,
      isBestSeller: true,
      isAvailable: true,
      averageRating: 4.0,
    ),
    ProductModel(
      productId: '4',
      name: 'Casual Cap',
      description: 'A stylish casual cap.',
      price: 15.99,
      oldPrice: 0,
      category: 'cap',
      collection: '2023',
      images: ['assets/images/onboarding1.png'],
      sizes: ['One Size'],
      colors: ['Black', 'White'],
      stock: 25,
      isBestSeller: true,
      isAvailable: true,
      averageRating: 4.7,
    ),
  ];

  static List<String> categories = [
    'All',
    'Hoodies',
    'Shirts',
    'Trousers',
    'Pants',
    'Cap',
  ];
}