// import 'package:flutter/cupertino.dart';

// import 'fcm_handler.dart';
// import 'firebase_service.dart';
// import 'notification_service.dart';

// class AppNotificationInitializer {
//   /// Initialize Firebase, Local Notification, and FCM
//   static Future<void> init() async {
//     WidgetsFlutterBinding.ensureInitialized();

//     await FirebaseService.init();       //  Firebase Init + Token
//     await NotificationService.init();   //  Local Notification Init
//     FCMHandler.configure();             //  Foreground & Tap handler
//   }
// }