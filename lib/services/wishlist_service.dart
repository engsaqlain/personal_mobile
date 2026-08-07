import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Handles all Firestore reads/writes for the current user's wishlist,
// following the "wishlist" schema in Section 5.1
class WishlistService {
  final CollectionReference _wishlistRef =
  FirebaseFirestore.instance.collection('wishlist');

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // Adds a product to the user's wishlist. Uses the userId as the
  // document ID so each user has exactly one wishlist document.
  Future<void> addToWishlist(String productId) async {
    if (_userId == null) return;
    await _wishlistRef.doc(_userId).set({
      'userId': _userId,
      'products': FieldValue.arrayUnion([productId]),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromWishlist(String productId) async {
    if (_userId == null) return;
    await _wishlistRef.doc(_userId).update({
      'products': FieldValue.arrayRemove([productId]),
    });
  }

  // Real-time stream of the current user's wishlist product IDs
  Stream<List<String>> getWishlistProductIds() {
    if (_userId == null) return Stream.value([]);
    return _wishlistRef.doc(_userId).snapshots().map((doc) {
      if (!doc.exists) return [];
      final data = doc.data() as Map<String, dynamic>;
      return List<String>.from(data['products'] ?? []);
    });
  }
}