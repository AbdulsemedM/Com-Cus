import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Generate cryptographically secure notification ID
    // Use message ID if available, otherwise generate secure random ID
    int notificationId;
    if (message.messageId != null && message.messageId!.isNotEmpty) {
      // Use FCM message ID as base and add random component for uniqueness
      notificationId =
          message.messageId!.hashCode.abs() + Random.secure().nextInt(1000);
    } else {
      // Generate completely secure random ID
      notificationId = Random.secure().nextInt(2147483647); // Max int32 value
    }

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification?.title ?? 'New Notification',
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }
}
