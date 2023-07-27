import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:orghub/ComonServices/injection_container.dart';
import 'package:orghub/Screens/Splash/view.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'Helpers/app_globals.dart';
import 'Helpers/app_theme.dart';
// import 'Helpers/prefs.dart';
import 'Screens/Auth/CheckUserAuth/init_app_bloc.dart';
import 'Screens/firebase_option.dart';

GetIt getIt = GetIt.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initKiwi();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await translator.init(
      languagesList: <String>['ar', 'en'], assetsDirectory: 'assets/langs/');
  initServiceLocator();
  runApp(
    LocalizedApp(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>().restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  // GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      // navigatorKey: navKey,
      key: key,
      locale: translator.locale,
      supportedLocales: translator.locals(),
      home: BlocProvider(
        create: (_) => AppInitBloc(),
        child: SplashView(
          navKey: null,
        ),
      ),
      title: "org hub",
      theme: ThemeData(
          fontFamily: 'Neosans',
          backgroundColor: AppTheme.backGroundColor,
          primaryColor: AppTheme.primaryColor,
          accentColor: AppTheme.accentColor),
    );
  }
}

void initServiceLocator() {
  getIt.registerLazySingleton<AppGlobals>(() => AppGlobals());
}
