// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:notification_test/features/authentication/presentation/screens/login_screen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
//
// class NotificationService {
//   static final _localNotifications = FlutterLocalNotificationsPlugin();
//
//   // initializing notification system
//   static Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//
//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         final payload = response.payload;
//         if (payload != null) {
//           handleNotificationTap(payload);
//         }
//       },
//     );
//   }
//
//   // display notification to the notification panel
//   static Future<void> _showNotification({
//     required String title,
//     required String body,
//     String? payload,
//     String? imageUrl,
//   }) async {
//     // notification image
//     final BigPictureStyleInformation? bigPictureStyle =
//         imageUrl != null && imageUrl.isNotEmpty
//         ? BigPictureStyleInformation(
//             FilePathAndroidBitmap(
//               await _downloadAndSaveFile(
//                 imageUrl,
//                 'bigPicture_${DateTime.now().millisecondsSinceEpoch}',
//               ), // cashing image with dynamic image name based on time stamp
//             ),
//             contentTitle: title,
//             summaryText: body,
//           )
//         : null;
//
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//           'default_channel',
//           'General Notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//           styleInformation: bigPictureStyle,
//         );
//
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//
//     // display actual notification
//     await _localNotifications.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: payload,
//     );
//   }
//
//   // if notification has a spasific screen route
//   // then it will push to those screen
//   static void handleNotificationTap(String payload) {
//     switch (payload) {
//       case "chat":
//        // your screen
//
//       // other case you can add
//
//       default:
//         HomeScreen();
//     }
//   }
//
//   // helper function for download and save notification image
//   static Future<String> _downloadAndSaveFile(
//     String url,
//     String fileName,
//   ) async {
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/$fileName';
//     final response = await http.get(Uri.parse(url));
//     final file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
//
//
//
//   // --------------------------------------- Notification Function For DEVELOPER ----------------------------------
//   static Future<void> sendLocalNotification({
//     required String title,
//     required String body,
//     String? payload,
//     String? imageUrl,
//   }) async {
//     _showNotification(
//       title: title,
//       body: body,
//       payload: payload,
//       imageUrl: imageUrl,
//     );
//   }
// }
