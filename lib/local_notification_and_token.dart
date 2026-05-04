import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

GlobalMethods globalMethods = GlobalMethods();
String? fcmToken;

class GlobalMethods {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void registerNotification(BuildContext context) async {
    // Request Firebase Messaging permissions
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
    }

    // Initialize local notifications
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked');
      },
    );

    // Request Android 13+ specific permission for local notifications
    final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      
      // Create the notification channel explicitly (required for Android 8.0+)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'albahrawi_channel',
        'Al-Bahrawi Notifications',
        description: 'قناة إشعارات تطبيق البهراوي',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await androidPlugin.createNotificationChannel(channel);
      debugPrint('Notification channel created successfully');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.messageId}');
      showLocalNotification(message);
    });

    firebaseMessaging.getToken().then((token) {
      if (token != null) {
        debugPrint('FCM Token: $token');
        fcmToken = token;
      }
    });
  }

  void showLocalNotification(RemoteMessage message) async {
    // ✅ استخدام نفس الـ instance المهيأ في registerNotification (class field)
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "albahrawi_channel",
      "Al-Bahrawi Notifications",
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? message.data['title'] ?? 'إشعار جديد',
      message.notification?.body ?? message.data['body'] ?? 'لديك إشعار جديد في التطبيق',
      notificationDetails,
      payload: null,
    );
  }
}
