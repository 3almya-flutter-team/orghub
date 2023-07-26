import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Screens/Conversations/view.dart';
import 'package:orghub/Screens/CreateProduct/bloc.dart';
import 'package:orghub/Screens/CreateProduct/view.dart';
import 'package:orghub/Screens/Home/view.dart';
import 'package:orghub/Screens/More/view.dart';
import 'package:orghub/Screens/Notifications/view.dart';
// import 'package:orghub/Screens/UpdateProduct/bloc.dart';
// import 'package:orghub/Screens/UpdateProduct/view.dart';

class BottomNavigationView extends StatefulWidget {
  final int pageIndex;
  const BottomNavigationView({Key key, this.pageIndex}) : super(key: key);
  @override
  _BottomNavigationViewState createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  AnimationController _animationController;
  Animation<double> opacity;
  AnimationController _moveController;
  Animation<double> move;
  AnimationController _rotateController;
  Animation<double> rotate;

  var pages = [
    HomeView(),
    ConversationsView(),
    NotificationsView(),
    MoreView(),
  ];
  Future<bool> _onBackPressed() {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: new Text(
              translator.currentLanguage == 'ar'
                  ? "هل تريد اغلاق التطبيق "
                  : "Do you want close the app?",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                  fontFamily: AppTheme.fontName),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  translator.currentLanguage == 'ar' ? "لا" : "No",
                  style: TextStyle(color: AppTheme.secondaryColor),
                ),
              ),
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text(
                  translator.currentLanguage == 'ar' ? "نعم" : "ok",
                  style: TextStyle(color: AppTheme.secondaryColor),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    opacity = new Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _moveController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    move = new Tween(begin: 30.0, end: -1.0).animate(_moveController)
      ..addListener(() {
        setState(() {});
      });
    _rotateController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    rotate = new Tween(begin: 0.0, end: 90.0).animate(_rotateController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();
    _moveController.forward();
    _rotateController.forward();

    if (widget.pageIndex != null) {
      setState(() {
        _selectedIndex = widget.pageIndex;
      });
    } else {
      setState(() {
        _selectedIndex = 0;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Directionality(
        textDirection: translator.currentLanguage == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppTheme.backGroundColor,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Transform.translate(
            offset: Offset(0, move.value),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  
                  Get.to(
                    BlocProvider(
                      create: (_) => CreateNewAdvertBloc(),
                      child: CreateProductScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              splashColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  title: Container(),
                  activeIcon: Opacity(
                    opacity: opacity.value,
                    child: Image.asset(
                      'assets/icons/ico-1.png',
                      height: 25,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  icon: Opacity(
                    opacity: opacity.value,
                    child: Image.asset(
                      'assets/icons/home.png',
                      height: 25,
                      color: Color(getColorHexFromStr('#F1B6C1')),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  title: Container(),
                  activeIcon: Transform.translate(
                    offset: translator.currentLanguage == 'en'
                        ? Offset(-20, move.value)
                        : Offset(20, move.value),
                    child: Image.asset(
                      'assets/icons/chaat.png',
                      height: 25,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  icon: Transform.translate(
                    offset: translator.currentLanguage == 'en'
                        ? Offset(-20, move.value)
                        : Offset(20, move.value),
                    child: Image.asset(
                      'assets/icons/message.png',
                      height: 25,
                      color: Color(getColorHexFromStr('#F1B6C1')),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  
                  title: Container(),
                  activeIcon: Transform.translate(
                    offset: translator.currentLanguage == 'en'
                        ? Offset(20, move.value)
                        : Offset(-20, move.value),
                    child: Image.asset(
                      'assets/icons/notification.png',
                      height: 25,
                    ),
                    
                  ),
                  icon: Transform.translate(
                    offset: translator.currentLanguage == 'en'
                        ? Offset(20, move.value)
                        : Offset(-20, move.value),
                    child: Image.asset(
                      'assets/icons/noti.png',
                      height: 25,
                      color: Color(getColorHexFromStr('#F1B6C1')),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  title: Container(),
                  activeIcon: Transform.rotate(
                    angle: rotate.value,
                    origin: Offset(0, 0),
                    child: Image.asset(
                      "assets/icons/ico.png",
                      width: 25, height: 25,
                      //  color: AppTheme.primaryColor
                    ),
                  ),
                  icon: Transform.rotate(
                    angle: rotate.value,
                    child: Image.asset(
                      "assets/icons/settings.png",
                      width: 25,
                      height: 25,
                      color: Color(getColorHexFromStr('#F1B6C1')),
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          body: pages[_selectedIndex],
        ),
      ),
    );
  }
}
