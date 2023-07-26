import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/bloc.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/view.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/bloc.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/view.dart';
import 'package:orghub/Screens/Auth/SignIn/bloc.dart';
import 'package:orghub/Screens/Auth/SignIn/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';

import '../card.dart';

class IntroView extends StatefulWidget {
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.currentLanguage == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                authCard(
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
                  context: context,
                  onTap: () {},
                  key: "",
                  val: "",
                  isIntro: true,
                  type: "",
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        translator.currentLanguage == "en"
                            ? "Please choose register type"
                            : "من فضلك اختر نوع التسجيل",
                        style: TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            btn(
                                context,
                                translator.currentLanguage == "en"
                                    ? "Create client account"
                                    : "انشاء حساب مستخدم", () {
                              Get.to(
                                BlocProvider(
                                    create: (_) => ClientSignUpBloc(),
                                    child: ClientSignUpView()),
                              );
                            }),
                            btn(
                                context,
                                translator.currentLanguage == "en"
                                    ? "Create company account"
                                    : "انشاء حساب شركة", () {
                              Get.to(
                                BlocProvider(
                                  create: (_) => ProviderSignUpBloc(),
                                  child: ProviderSignUpView(),
                                ),
                              );
                            }),
                            InkWell(
                              onTap: () {
                                Get.to(
                                  BlocProvider(
                                    create: (_) => UserLoginBloc(),
                                    child: SignInView(),
                                  ),
                                );
                              },
                              child: Text(
                                translator.currentLanguage == "en"
                                    ? "Sign in"
                                    : "تسجيل دخول",
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
