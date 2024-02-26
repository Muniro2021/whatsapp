// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:uct_chat/features/create_update_screen/create_update_screen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'
//     as localMessage;
// import 'package:uct_chat/main.dart';

// class APIsMessage {
//   static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

//   static final localNotification =
//       localMessage.FlutterLocalNotificationsPlugin();

//   static void handleMessage(RemoteMessage message) {
//     print("MuneerMessage: handleMessage");
//     if (message == null) return;
//     navigatorKey.currentState?.pushNamed(
//       CreateUpdateScreen.route,
//       arguments: message,
//     );
//   }

//   static Future initPushNotification() async {
//     print("MuneerMessage: initPushNotification");
//     await fMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       sound: true,
//       badge: true,
//     );
//     fMessaging.getInitialMessage().then(
//           (value) => handleMessage,
//         );
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (event) => handleMessage,
//     );
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;
//       localNotification.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           const localMessage.NotificationDetails(
//             android: localMessage.AndroidNotificationDetails(
//               'updates',
//               'Updates',
//               playSound: true,
//             ),
//           ),
//           payload: jsonEncode(message.toMap()));
//     });
//   }

//   static Future initLocalNotifications() async {
//     print("MuneerMessage: initLocalNotifications");
//     const android = localMessage.AndroidInitializationSettings('');
//     const settings = localMessage.InitializationSettings(android: android);
//     await localNotification.initialize(
//       settings,
//       onSelectNotification: (payload) {
//         final message = RemoteMessage.fromMap(jsonDecode(payload!));
//         handleMessage(message);
//       },
//     );
//     final platform = localNotification.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(const AndroidNotificationChannel(
//       'updates',
//       'For Showing Updates Message Notification',
//       description: 'For Showing Updates Message Notification desc',
//       importance: Importance.high,
//     ));
//   }

//   static Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     print("MuneerMessage: handleBackgroundMessage");
//     print(message.notification?.title);
//     print(message.notification?.body);
//     print(message.data);
//     navigatorKey.currentState?.pushNamed(
//       CreateUpdateScreen.route,
//       arguments: message,
//     );
//   }
// }
