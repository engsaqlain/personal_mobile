import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Handles Firebase Cloud Messaging setup: requesting permission,
// getting the device token, and saving it to Firestore so backend
// Cloud Functions can send order-update notifications (Section 3.7).
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Call this once when the app starts (after login) to set up
  // notifications and save this device's token.
  Future<void> initialize() async {
    // Ask the user for permission to show notifications
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get this device's unique FCM token
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveTokenToFirestore(token);
    }

    // If the token ever refreshes (e.g. app reinstalled), save the new one
    _messaging.onTokenRefresh.listen(_saveTokenToFirestore);

    // Handle notifications that arrive while the app is open (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // TODO: Show an in-app banner/snackbar using message.notification
      // once we want foreground notifications to be visible to the user.
    });
  }

  // Saves the FCM token under the current user's document so backend
  // Cloud Functions know which device(s) to send notifications to.
  Future<void> _saveTokenToFirestore(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).set(
      {'fcmToken': token},
      SetOptions(merge: true),
    );
  }
}