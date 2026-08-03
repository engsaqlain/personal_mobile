import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

// Handles all Firestore reads/writes related to products.
// Keeping this logic separate from UI code (screens) makes it reusable
// and easier to test/maintain.
class ProductService {
  final CollectionReference _productsRef =
  FirebaseFirestore.instance.collection('products');

  // Returns a real-time stream of all products.
  // Using a Stream (not a one-time Future) means the UI automatically
  // updates if Sami adds/edits a product from the Admin Panel.
  Stream<List<ProductModel>> getProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Returns only products marked as best sellers
  Stream<List<ProductModel>> getBestSellers() {
    return _productsRef
        .where('isBestSeller', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
}