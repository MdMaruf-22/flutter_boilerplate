// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:notification_test/core/utils/helpers/app_helper.dart';
// import 'notification_service.dart';
//
// class FCMHandler {
//   static void configure() {
//
//     // Foreground notification listener
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//
//       // get image url (if notification has image)
//       final imageUrl = message.notification?.android?.imageUrl
//           ?? message.notification?.apple?.imageUrl;
//
//       NotificationService.sendLocalNotification(
//         title: message.notification?.title ?? '',
//         body: message.notification?.body ?? '',
//         payload: message.data['screen'] ?? '',
//         imageUrl: imageUrl
//       );
//     });
//
//     // Background notification handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // when tap to notification it will go a spasific route/screen
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       final screen = message.data['screen'];
//       if (screen != null) {
//         NotificationService.handleNotificationTap(screen);
//       }
//     });
//   }
//
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     if (message.notification != null) {
//       await NotificationService.sendLocalNotification(
//         title: message.notification?.title ?? '',
//         body: message.notification?.body ?? '',
//         payload: message.data['screen'] ?? '',
//       );
//     }
//   }
// }