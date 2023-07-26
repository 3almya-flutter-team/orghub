import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:orghub/ComonServices/GetCurrentLocation/bloc.dart';
// import 'package:orghub/ComonServices/GetCurrentLocation/events.dart';
import 'package:orghub/Helpers/PushNotifications.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_bloc.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_events.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_states.dart';
import 'package:orghub/Screens/Auth/SignIn/bloc.dart';
import 'package:orghub/Screens/Auth/SignIn/view.dart';
import 'package:orghub/Screens/BottomNavigation/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:kiwi/kiwi.dart' as kiwi;

class SplashView extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const SplashView({Key key, this.navKey}) : super(key: key);
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String isDone;
  // GetCurrentLocationBloc getCurrentLocationBloc =
  //     kiwi.KiwiContainer().resolve<GetCurrentLocationBloc>();
  @override
  void initState() {
    GlobalNotification.instance.notificationSetup(navigatorKey: widget.navKey);
    // getCurrentLocationBloc.add(GetCurrentLocationEventsStart());
    goToHomePage();
    super.initState();
  }

  @override
  void dispose() {
    // getCurrentLocationBloc.close();
    super.dispose();
  }

  void goToHomePage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      isDone = prefs.getString('isDone');
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        Timer(Duration(seconds: 2), () {
          BlocProvider.of<AppInitBloc>(context).add(AppStarted());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //       // BottomNavigationView(),
          //     IntroView(),
          //   ),
          // );
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      _showNetworkErrorDialog(context);
    }
  }

  void _showNetworkErrorDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            translator.currentLanguage == "en"
                ? "please check your internet connection"
                : "تأكد من الاتصال بالانترنت",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryColor,
                fontFamily: AppTheme.fontName),
          ),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) {
                      return BlocProvider(
                        create: (_) => AppInitBloc(),
                        child: SplashView(),
                      );
                    },
                  ),
                );
              },
              child: Text(
                translator.currentLanguage == "en"
                    ? "Try again"
                    : "حاول مرة أخرى",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                    fontFamily: AppTheme.boldFont),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.currentLanguage == "en"
          ? TextDirection.ltr
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        body: BlocListener<AppInitBloc, InitialAppStates>(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icons/splash.png"),
                    fit: BoxFit.fill),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Image.asset(
                    "assets/icons/logox.png",
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
            listener: (BuildContext context, InitialAppStates state) {
              if (state is UserAuthenticated) {
                // go to home
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) {
                      return BottomNavigationView();
                    },
                  ),
                );
              } else {
                // go to login page
                Get.to(
                  BlocProvider(
                    create: (_) => UserLoginBloc(),
                    child: SignInView(),
                  ),
                );
                // Navigator.of(context).pushReplacement(
                //   PageRouteBuilder(
                //     pageBuilder: (_, __, ___) {
                //       return SignInView();
                //     },
                //   ),
                // );
              }
            }),
      ),
    );
  }
}
