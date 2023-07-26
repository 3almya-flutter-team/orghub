import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:orghub/Helpers/app_globals.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/bloc.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';
import 'package:orghub/Screens/Chat/view.dart';
import 'package:orghub/Screens/OfferDetail/view.dart';
import 'package:orghub/Screens/OrderDetail/view.dart';
import 'package:orghub/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalNotification {
  FirebaseMessaging _firebaseMessaging;
  GlobalKey<NavigatorState> navigatorKey;

  static StreamController<Map<String, dynamic>> _onMessageStreamController =
      StreamController.broadcast();
  static StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  static GlobalNotification instance = new GlobalNotification._();
  GlobalNotification._();

  static final Stream<Map<String, dynamic>> onFcmMessage =
      _streamController.stream;

  void notificationSetup({GlobalKey<NavigatorState> navigatorKey}) {
    _firebaseMessaging = FirebaseMessaging();
    this.navigatorKey = navigatorKey;
    requestPermissions();
    getFcmToken();
    notificationListeners();
  }

  StreamController<Map<String, dynamic>> get notificationSubject {
    return _onMessageStreamController;
  }

  void requestPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
  }

  Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('msgToken', await _firebaseMessaging.getToken());
    print('firebase token => ${await _firebaseMessaging.getToken()}');
    return await _firebaseMessaging.getToken();
  }

  void notificationListeners() {
    _firebaseMessaging.configure(
        onMessage: _onNotificationMessage,
        onResume: _onNotificationResume,
        onLaunch: _onNotificationLaunch);
  }

  Future<dynamic> _onNotificationMessage(Map<dynamic, dynamic> message) async {
    // _notificationSubject.add(message);
    _onMessageStreamController.add(message);

    // FlutterRingtonePlayer.play(
    //   android: AndroidSounds.notification,
    //   ios: IosSounds.glass,
    //   looping: true, // Android only - API >= 28
    //   volume: 0.1, // Android only - API >= 28
    //   asAlarm: false, // Android only - all APIs
    // );

    Get.snackbar(
      "${message['data']['title']}", // title
      "${message['data']['body']}", // message
      icon: Icon(Icons.notifications),
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      onTap: (_) {
        // print(
        //     "------- ON Message clicked ------6666=[${message['data']['type']}]=6666------ $message");

        // if (message['data']['type'] == "order") {
        //   Get.to(MyPurchasesDetailsView(
        //     current: true,
        //     status: "",
        //     id: int.parse(message['data']['order_id'].toString()),
        //   ));
        // } else if (message['data']['type'] == "refund_order") {
        //   if (message['data']['product_id'] != "" &&
        //       message['data']['product_id'] != null) {
        //     Get.to(MySameRetrievalProductsDetailsView(
        //       isCurrent: true,
        //       id: int.parse(message['data']['order_id'].toString()),
        //     ));
        //   } else {
        //     Get.to(MyRetrievalProductsDetailsView(
        //       isCurrent: true,
        //       id: int.parse(message['data']['order_id'].toString()),
        //     ));
        //   }
        // } else {}
      },
      duration: Duration(seconds: 20),
    );

    print(
        "------- ON MESSAGE -------5555555----- ${message['data']['message_object'] is Map}");

    SendMessageData messageData =
        SendMessageData.fromJson(jsonDecode(message['data']['message_object']));
    print("=-=-=-> =-=-=-=-=> =-=-=-==> ${messageData.message}");

    getIt.get<AppGlobals>().controller.add(messageData);
  }

  Future<dynamic> _onNotificationResume(Map<dynamic, dynamic> message) async {
    print(
        "------- ON RESUME ------6666=[${message['data']['type']}]=6666------ $message");

    if (message['data']['type'] == "order") {
      Get.to(DetailsOrder(
        orderId: int.parse(message['data']['order_id'].toString()),
        api: "orders",
      ));
    } else if (message['data']['type'] == "new_offer") {
      Get.to(OfferDetailView(
        offerId: int.parse(message['data']['offer_id'].toString()),
      ));
    } else if (message['data']['type'] == "new_chat") {
      print(
          "=-=-=-= [a7a7a7a7a7a7a] =-=-===--------------${message['data']['sender_id'] is String}--------------");
      print(
          "=-=-=-= [a7a7a7a7a7a7a] =-=-===--------------${message['data']['chat_id'] is String}--------------");
      // navigatorKey.currentState
      //     .push(PageRouteBuilder(pageBuilder: (_, __, ___) {
      //   return ChatScreen(
      //     receiverId: message['data']['sender_id'],
      //     receiverName: message['data']['receiver_name'],
      //     chatId: int.parse(message['data']['chat_id'].toString()),
      //   );
      // }));
      Get.to(BlocProvider(
        create: (_) => SendMessageBloc(),
        child: ChatScreen(
          receiverId: int.parse(message['data']['sender_id'].toString()),
          receiverName: message['data']['receiver_name'],
          chatId: int.parse(message['data']['chat_id'].toString()),
        ),
      ));
    }
  }

  Future<dynamic> _onNotificationLaunch(Map<dynamic, dynamic> message) async {
    print(
        "------- ON RESUME ------6666=[${message['data']['type']}]=6666------ $message");

    if (message['data']['type'] == "order") {
      Get.to(DetailsOrder(
        orderId: int.parse(message['data']['order_id'].toString()),
        api: "orders",
      ));
    } else if (message['data']['type'] == "new_offer") {
      Get.to(OfferDetailView(
        offerId: int.parse(message['data']['offer_id'].toString()),
      ));
    } else if (message['data']['type'] == "new_chat") {
      // print("=-=-=-= [a7a7a7a7a7a7a] =-=-===--------------${message['data']['sender_id'] is String}--------------");
      // print("=-=-=-= [a7a7a7a7a7a7a] =-=-===--------------${message['data']['chat_id'] is String}--------------");
      // navigatorKey.currentState.push(
      //   PageRouteBuilder(
      //     pageBuilder: (_, __, ___) {
      //       return ChatScreen(
      //         receiverId: int.parse(message['data']['sender_id'].toString()),
      //         receiverName: message['data']['receiver_name'],
      //         chatId: int.parse(message['data']['chat_id'].toString()),
      //       );
      //     },
      //   ),
      // );
      Get.to(BlocProvider(
        create: (_) => SendMessageBloc(),
        child: ChatScreen(
          receiverId: int.parse(message['data']['sender_id'].toString()),
          receiverName: message['data']['receiver_name'],
          chatId: int.parse(message['data']['chat_id'].toString()),
        ),
      ));
    }
  }

  void killNotification() {
    _onMessageStreamController.close();
    _streamController.close();
  }
}
