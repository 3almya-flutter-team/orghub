// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotifcationClss {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   var initializationSettingsAndroid;
//   var initializationSettingsIOS;
//   var initializationSettings;
//   Timer time;
//   void initalvalues() {
//     initializationSettingsAndroid =
//         new AndroidInitializationSettings('@mipmap/ic_launcher');
//     initializationSettings = new InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
//     flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage taa: $message");
//         time = new Timer(Duration(milliseconds: 10), () {
//           if (time != null && !time.isActive)
//             showNotificationWithDefaultSound(
//                 message["data"]["title"].toString(),
//                 message["data"]["body"].toString());
//         });
//         // _showItemDialog(message);
//       },
//       //   onBackgroundMessage: myBackgroundMessageHandler,
//       onLaunch: (Map<String, dynamic> message) async {
//         showNotificationWithDefaultSound(
//             message["data"]["title"].toString(),
//             message["data"]["body"].toString());
//         print("onLaunch: $message");
//         // _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         showNotificationWithDefaultSound(
//             message["data"]["title"].toString(),
//             message["data"]["body"].toString());
//         print("onResume: $message");
//         // _navigateToItemDetail(message);
//       },
//     );
//   }

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   Future showNotificationWithDefaultSound(String tittel, String body) async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         importance: Importance.Max,
//         priority: Priority.High,
//         enableVibration: true,
//         playSound: true,
//         icon: 'mipmap/ic_launcher');
//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecond,
//       tittel, 
//       body,
//       platformChannelSpecifics,
//       payload: 'Default_Sound',
//     );
//   }

//   Future onSelectNotification(String payload) async {
//     // showDialog(
//     //   context: context,
//     //   builder: (_) {
//     //     return new AlertDialog(
//     //       title: Text("PayLoad"),
//     //       content: Text("Payload : $payload"),
//     //     );
//     //   },
//     // );
//   }
//   // // var initializationSettingsIOS = new IOSInitializationSettings();
//   // // var initializationSettings = new InitializationSettings(
//   // //     initializationSettingsAndroid, initializationSettingsIOS);
//   // // flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//   // flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification:
//   //     onSelectNotification);
// }
