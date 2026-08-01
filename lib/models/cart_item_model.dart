import 'product_model.dart';

// Matches the Firestore "cart" items schema from Section 5.1.
// Keeps a reference to the full ProductModel for UI display purposes
// (name, image, etc.), but toMap() only sends the fields Firestore expects.
class CartItemModel {
  final ProductModel product; // Used locally for UI (name, image, etc.)
  final String size;
  final String color;
  int quantity;

  CartItemModel({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  // Price is taken from the product at the time it was added to cart
  double get totalPrice => product.price * quantity;

  // Converts this cart item into the exact map structure Firestore expects,
  // per the "cart.items" schema in Section 5.1
  Map<String, dynamic> toMap() {
    return {
      'productId': product.productId,
      'quantity': quantity,
      'size': size,
      'color': color,
      'price': product.price,
    };
  }
}