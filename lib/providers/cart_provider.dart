import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

// Manages the shopping cart state for the whole app.
// Any screen (Home badge, Cart, Checkout) can listen to this
// and stay in sync automatically.
class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  // Read-only access to the cart items list
  List<CartItemModel> get items => _items;

  // Total number of items in the cart (sum of quantities, not just line count)
  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  // Total price across the whole cart
  double get totalPrice => _items.fold(0.0, (total, item) => total + item.totalPrice);

  // Adds a product to the cart. If the same product+size+color combo
  // already exists, increase its quantity instead of adding a duplicate row.
  void addToCart({
    required ProductModel product,
    required String size,
    required String color,
    int quantity = 1,
  }) {
    final existingIndex = _items.indexWhere((item) =>
    item.product.productId == product.productId &&
        item.size == size &&
        item.color == color);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItemModel(
        product: product,
        size: size,
        color: color,
        quantity: quantity,
      ));
    }

    notifyListeners();
  }

  void removeFromCart(CartItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItemModel item, int newQuantity) {
    if (newQuantity < 1) return;
    item.quantity = newQuantity;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}