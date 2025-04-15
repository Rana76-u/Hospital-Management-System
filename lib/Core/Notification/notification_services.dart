import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initToken() async {
    String? token = await _messaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
      await saveTokenToFirestore(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToFirestore);
  }

  Future<void> saveTokenToFirestore(String token) async {
    await FirebaseFirestore.instance.collection('device_tokens').doc(token).set({
      'token': token,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
