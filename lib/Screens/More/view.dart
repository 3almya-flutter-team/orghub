import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/GetUserType/bloc.dart';
import 'package:orghub/ComonServices/GetUserType/events.dart';
import 'package:orghub/ComonServices/GetUserType/states.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Screens/AppInfo/About/view.dart';
import 'package:orghub/Screens/AppInfo/Policy/view.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_bloc.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_events.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_states.dart';
// import 'package:orghub/Screens/Auth/Intro/view.dart';
import 'package:orghub/Screens/Auth/LogoutService/bloc.dart';
import 'package:orghub/Screens/Auth/LogoutService/events.dart';
import 'package:orghub/Screens/Auth/LogoutService/states.dart';
import 'package:orghub/Screens/Complaints&Suggestions/view.dart';
import 'package:orghub/Screens/Favourite/view.dart';
import 'package:orghub/Screens/MyComments/view.dart';
import 'package:orghub/Screens/MyProducts/view.dart';
import 'package:orghub/Screens/OffersHistory/view.dart';
import 'package:orghub/Screens/OrdersHistory/view.dart';
import 'package:orghub/Screens/OrdersOnMyAds/view.dart';
import 'package:orghub/Screens/Splash/view.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/UpdateService/bloc.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/view.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/UpdateUserProfile/UpdateService/bloc.dart';
import 'package:orghub/Screens/UpdateUserProfile/bloc.dart';
import 'package:orghub/Screens/UpdateUserProfile/events.dart';
import 'package:orghub/Screens/UpdateUserProfile/states.dart';
import 'package:orghub/Screens/UpdateUserProfile/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:toast/toast.dart';

class MoreView extends StatefulWidget {
  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  GetUserTypeBloc getUserTypeBloc =
      kiwi.KiwiContainer().resolve<GetUserTypeBloc>();
  LogoutBloc logoutBloc = kiwi.KiwiContainer().resolve<LogoutBloc>();

  GetUserProfileDataBloc getUserProfileDataBloc =
      kiwi.KiwiContainer().resolve<GetUserProfileDataBloc>();
  AppInitBloc appInitBloc = kiwi.KiwiContainer().resolve<AppInitBloc>();

  @override
  void initState() {
    // _checkAuth();
    appInitBloc.add(AppStarted());
    getUserTypeBloc.add(GetUserTypeEventsStart());
    getUserProfileDataBloc.add(GetUserProfileEventStart());
    super.initState();
  }

  bool isAuth = false;

  // void _checkAuth() async {
  //   print("=-=ooioioioioioioooooioioiooioioo-==> ${Prefs.getKeys().toList().toString()}");
  //   if (Prefs.getKeys().contains('authToken')) {
  //     if (await Prefs.getStringF('authToken') != null ||
  //         await Prefs.getStringF('authToken') != '') {
  //       print("----------------------------user is auth");
  //       setState(() {
  //         isAuth = true;
  //       });
  //     } else {
  //       print("-------------------------user is not auth");
  //       setState(() {
  //         isAuth = false;
  //       });
  //     }
  //   } else {
  //     print("-----------------------------user is not auth");
  //     setState(() {
  //       isAuth = false;
  //     });
  //   }
  // }

  @override
  void dispose() {
    getUserTypeBloc.close();
    logoutBloc.close();
    appInitBloc.close();
    getUserProfileDataBloc.close();
    super.dispose();
  }

  Widget _item(String txt, String icon, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                icon,
                width: 20,
                height: 20,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 40,
            ),
            Text(
              txt,
              style: TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: AppTheme.fontName),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleError({BuildContext context, LogoutStateFailed state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      // error from server
      print("-=-=-=-=> oooooo => ${state.msg.toString()}");

      FlashHelper.errorBar(context, message: state.msg ?? "");
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.currentLanguage == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        appBar: appBarWithAction(
            context: context,
            actionIcon: BlocBuilder(
                bloc: getUserTypeBloc,
                builder: (context, state) {
                  if (state is GetUserTypeStatesStart) {
                    return CupertinoActivityIndicator(
                      animating: true,
                      radius: 14,
                    );
                  } else if (state is GetUserTypeStatesSuccess) {
                    return IconButton(
                      onPressed: () {
                        if (state.type == "client") {
                          Get.to(
                            BlocProvider(
                                create: (_) => UserProfileUpdateBloc(),
                                child: UpdateUserProfileView()),
                          );
                        } else {
                          Get.to(
                            BlocProvider(
                                create: (_) => CompanyUpdateBloc(),
                                child: UpdateCompanyProfileView()),
                          );
                        }
                      },
                      icon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Image.asset(
                          "assets/icons/edit11.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            title: translator.currentLanguage == "en" ? "More" : "المزيد",
            leading: false),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              BlocBuilder(
                  bloc: getUserProfileDataBloc,
                  builder: (context, state) {
                    if (state is GetUserProfileStateStart) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SpinKitThreeBounce(
                          color: AppTheme.primaryColor,
                          size: 30,
                        ),
                      );
                    } else if (state is GetUserProfileStateSuccess) {
                      return Column(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    state.userProfileModel.data.image ??
                                        AppTheme.defaultPersonImage,
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              state.userProfileModel.data.fullname ?? "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      );
                    } else if (state is GetUserProfileStateFailed) {
                      if (state.errType == 0) {
                        // FlashHelper.errorBar(context,
                        //     message: translator.currentLanguage == 'en'
                        //         ? "Please check your network connection."
                        //         : "برجاء التاكد من الاتصال بالانترنت ");
                        return noInternetWidget(context);
                      } else {
                        // FlashHelper.errorBar(context,
                        //     message: state.msg ?? "");
                        return errorWidget(
                            context, state.msg ?? "", state.statusCode);
                      }
                    } else {
                      // FlashHelper.errorBar(context,
                      //     message: state.msg ?? "");
                      return Container();
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              _item(
                translator.currentLanguage == "en"
                    ? "Orders log"
                    : "سجل الطلبات",
                "assets/icons/microphone.png",
                () {
                  Get.to(OrderHistory());
                },
              ),
              _item(
                translator.currentLanguage == "en"
                    ? "Orders On My Ads"
                    : "الطلبات على منتجاتى",
                "assets/icons/order.png",
                () {
                  Get.to(OrdersOnMyAds());
                },
              ),
              _item(
                translator.currentLanguage == "en"
                    ? "Favourite ads"
                    : "الاعلانات المفضلة",
                "assets/icons/likes.png",
                () {
                  Get.to(
                    FavouriteView(),
                  );
                },
              ),
              _item(
                translator.currentLanguage == "en" ? "My products" : "منتجاتى",
                "assets/icons/calculator.png",
                () {
                  Get.to(MyProductsView());
                },
              ),
              _item(
                translator.currentLanguage == "en" ? "My Offers" : "عروضى",
                "assets/icons/discount.png",
                () {
                  Get.to(MyOffersView());
                },
              ),
              _item(
                translator.currentLanguage == "en" ? "My comments" : "تعليقاتى",
                "assets/icons/messaging.png",
                () {
                  Get.to(
                    MyCommentsView(),
                  );
                },
              ),
              _item(
                translator.currentLanguage == "en"
                    ? "About company"
                    : "عن الشركة",
                "assets/icons/building.png",
                () {
                  Get.to(
                    AboutView(),
                  );
                },
              ),
              _item(
                translator.currentLanguage == "en"
                    ? "Using policy"
                    : "سياسة الاستخدام",
                "assets/icons/policy.png",
                () {
                  Get.to(
                    PolicyView(),
                  );
                },
              ),
              _item(
                translator.currentLanguage == "en"
                    ? "For suggestions and complains"
                    : "الشكاوى والاقتراحات",
                "assets/icons/info-1.png",
                () {
                  Get.to(
                    ComplaintsView(
                      type: 'auth',
                    ),
                  );
                },
              ),
              _item(
                translator.currentLanguage == "en" ? "العربية" : "English",
                "assets/icons/translator.png",
                () {
                  translator.currentLanguage == "en"
                      ? translator.setNewLanguage(
                          context,
                          newLanguage: 'ar',
                          remember: true,
                          restart: true,
                        )
                      : translator.setNewLanguage(
                          context,
                          newLanguage: 'en',
                          remember: true,
                          restart: true,
                        );
                },
              ),
              BlocBuilder(
                bloc: appInitBloc,
                builder: (context, authState) {
                  if (authState is UserAuthenticated) {
                    return BlocConsumer(
                      bloc: logoutBloc,
                      builder: (context, logOutState) {
                        if (logOutState is LogoutStateStart) {
                          return SpinKitCircle(
                            color: AppTheme.primaryColor,
                            size: 30,
                          );
                        } else {
                          return _item(
                            translator.currentLanguage == "en"
                                ? "Log out"
                                : "تسجيل الخروج",
                            translator.currentLanguage == "en"
                                ? "assets/icons/logout-en.png"
                                : "assets/icons/logout.png",
                            () {
                              logoutBloc.add(
                                LogoutEventStart(),
                              );
                            },
                          );
                        }
                      },
                      listener: (context, logOutState) {
                        if (logOutState is LogoutStateSuccess) {
                          Toast.show(
                              translator.currentLanguage == "en"
                                  ? "Done"
                                  : "تم تسجيل الخروج بنجاح",
                              context);

                          Get.to(
                            BlocProvider(
                              create: (_) => AppInitBloc(),
                              child: SplashView(),
                            ),
                          );
                        } else if (logOutState is LogoutStateFailed) {
                          _handleError(context: context, state: logOutState);
                        }
                      },
                    );
                  } else if (authState is UserNotAuthenticated) {
                    return _item(
                      translator.currentLanguage == "en"
                          ? "Login"
                          : "تسجيل الدخول",
                      translator.currentLanguage == "en"
                          ? "assets/icons/login.png"
                          : "assets/icons/login.png",
                      () {
                        Get.to(
                          BlocProvider(
                            create: (_) => AppInitBloc(),
                            child: SplashView(),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
