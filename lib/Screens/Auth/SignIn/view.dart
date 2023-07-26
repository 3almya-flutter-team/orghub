import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Auth/Activation/bloc.dart';
import 'package:orghub/Screens/Auth/Activation/view.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/view.dart';
import 'package:orghub/Screens/Auth/Intro/view.dart';
import 'package:orghub/Screens/Auth/SignIn/bloc.dart';
import 'package:orghub/Screens/Auth/SignIn/events.dart';
import 'package:orghub/Screens/Auth/SignIn/states.dart';
import 'package:orghub/Screens/Auth/card.dart';
import 'package:orghub/Screens/BottomNavigation/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:toast/toast.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserLoginData userLoginData = UserLoginData(phone: null, password: null);

  void _submit({BuildContext context}) {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();

      BlocProvider.of<UserLoginBloc>(context).add(
        UserLoginEventsStart(
          userLoginData: userLoginData,
        ),
      );
    }
  }

  void _handleError({BuildContext context, UserLoginStatesFailed state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      if (state.goToActivate) {
        // go to activate page
        Toast.show(state.msg ?? "", context);
        Get.to(
          BlocProvider(
            create: (_) => ActivateAccountBloc(),
            child: ActivationView(
              userName: state.userName ?? "",
              type: translator.currentLanguage == "en"
                  ? "Account activation"
                  : "تفعيل الحساب",
            ),
          ),
        );
      } else if (state.isBan) {
        // user is banned
        FlashHelper.errorBar(context, message: state.msg ?? "");
      } else {
        // other error
        FlashHelper.errorBar(context, message: state.msg ?? "");
      }
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.currentLanguage == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  authCard(
                    context: context,
                    changeLang: () {
                      translator.currentLanguage == "en"
                          ? translator.setNewLanguage(
                              context,
                              newLanguage: 'ar',
                              remember: true,
                              restart: false,
                            )
                          : translator.setNewLanguage(
                              context,
                              newLanguage: 'en',
                              remember: true,
                              restart: false,
                            );
                      setState(() {});
                    },
                    onTap: () {
                      // Get.back();
                      Get.to(IntroView());
                    },
                    key: translator.currentLanguage == "en"
                        ? "Doesn't have account ?"
                        : "ليس لديك حساب ؟",
                    val: translator.currentLanguage == "en"
                        ? "Create account"
                        : "انشاء حساب",
                    isIntro: false,
                    type: translator.currentLanguage == "en"
                        ? "Sign in"
                        : "تسجيل دخول",
                  ),
                  sizedBox(),
                  txtField(
                    context: context,
                    hintText: translator.currentLanguage == "en"
                        ? "Mobile Or Mail"
                        : "رقم الجوال او البريد الالكترونى",
                    onSaved: (val) {
                      setState(() {
                        userLoginData.phone = val;
                      });
                    },
                    validator: (val) {},
                    // textInputType: TextInputType.phone,
                    controller: null,
                    obscureText: false,
                  ),
                  sizedBox(),
                  txtField(
                    context: context,
                    hintText: translator.currentLanguage == "en"
                        ? "Password"
                        : "كلمة المرور",
                    onSaved: (val) {
                      setState(() {
                        userLoginData.password = val;
                      });
                    },
                    validator: (val) {},
                    textInputType: TextInputType.text,
                    controller: null,
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 60),
                    child: InkWell(
                      onTap: () {
                        Get.to(ForgetPasswordView());
                      },
                      child: Text(
                        translator.currentLanguage == "en"
                            ? "Forget password"
                            : "نسيت كلمة المرور",
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  BlocConsumer<UserLoginBloc, UserLoginStates>(
                    builder: (context, state) {
                      if (state is UserLoginStatesStart) {
                        return SpinKitCircle(
                          color: AppTheme.primaryColor,
                          size: 30,
                        );
                      } else {
                        return btn(
                          context,
                          translator.currentLanguage == "en"
                              ? "Sign in"
                              : "تسجيل دخول",
                          () {
                            _submit(context: context);
                          },
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is UserLoginStatesSuccess) {
                        // go to bottom navigation page
                        Get.to(
                          BottomNavigationView(),
                        );
                      } else if (state is UserLoginStatesFailed) {
                        _handleError(context: context, state: state);
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Get.to(
                          BottomNavigationView(),
                        );
                      },
                      child: Text(
                        translator.currentLanguage == "en"
                            ? "Login as a visitor"
                            : 'الدخول كزائر',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserLoginData {
  String phone;
  String password;

  UserLoginData({
    @required this.phone,
    @required this.password,
  });
}
