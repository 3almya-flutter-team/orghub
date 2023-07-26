import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_events.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppInitBloc extends Bloc<InitialAppEvents, InitialAppStates> {
  Completer completer = Completer();

  AppInitBloc() : super(UserNotAuthenticated());
  Echo echo;

  @override
  Stream<InitialAppStates> mapEventToState(InitialAppEvents event) async* {
    if (event is AppStarted) {
      // execute isAuth function
      completer.complete(isAuthenticated());
    }

    bool isAuth = await completer.future;
    print("=-=-==> isAuth =-=-=> $isAuth");
    if (isAuth) {
      // user is online and authenticated
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("authToken");
      print("][][][][][=--=-=-=-=> $token");
      echo = new Echo({
        'broadcaster': 'socket.io',
        'client': IO.io,
        'auth': {
          'headers': {'Authorization': 'Bearer $token'}
        },
        "host": "https://org.taha.rmal.com.sa:6010",
        // "host": "https://orghub.store:6010",
      });

      // echo.join('online');

      echo.join('online').here((users) {
        print(users);
      }).joining((user) {
        print(user);
      }).leaving((user) {
        print(user);
      });

      yield UserAuthenticated();
    } else {
      yield UserNotAuthenticated();
    }
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("authToken");
    if (!preferences.getKeys().toList().contains("authToken")) {
      return false;
    } else {
      if (token == null || token == "") {
        return false;
      } else {
        return true;
      }
    }
  }
}
