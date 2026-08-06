// Represents a single product, matching the Firestore "products" collection
// schema defined in Section 5.1 of the project documentation.
//
// Includes defensive parsing (_parseDouble, _parseStringList) so the app
// doesn't crash if any team member's Firestore data has inconsistent
// types (e.g. a price stored as a String instead of a number, or an
// images field stored as a single String instead of an array).
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
  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      productId: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: _parseDouble(map['price']),
      oldPrice: _parseDouble(map['oldPrice']),
      category: map['category'] ?? '',
      collection: map['collection'] ?? '',
      images: _parseStringList(map['images']),
      sizes: _parseStringList(map['sizes']),
      colors: _parseStringList(map['colors']),
      stock: _parseInt(map['stock']),
      isBestSeller: map['isBestSeller'] ?? false,
      isAvailable: map['isAvailable'] ?? true,
      averageRating: _parseDouble(map['averageRating']),
      createdAt: map['createdAt']?.toDate(),
    );
  }

  // Converts this ProductModel back into a Map, useful if we ever need
  // to write/update product data from the app (e.g. Admin features later).
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'category': category,
      'collection': collection,
      'images': images,
      'sizes': sizes,
      'colors': colors,
      'stock': stock,
      'isBestSeller': isBestSeller,
      'isAvailable': isAvailable,
      'averageRating': averageRating,
    };
  }

  // --- Defensive parsing helpers ---

  // Safely converts a value to double, whether it comes from Firestore
  // as a String (e.g. "180"), an int, or a double.
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  // Safely converts a value to int, in case stock is ever stored as a String
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  // Safely converts a value to List<String>, whether Firestore has it as
  // a proper array, a single String, or missing entirely.
  // Safely converts a value to List<String>, whether Firestore has it as
// a proper array, a single String, a comma-separated String
// (e.g. "S,M,L"), or missing entirely.
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return List<String>.from(value.map((e) => e.toString()));
    }
    if (value is String) {
      if (value.trim().isEmpty) return [];
      // Handle comma-separated strings like "S,M,L" by splitting them,
      // and trim whitespace around each item
      return value.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }
}