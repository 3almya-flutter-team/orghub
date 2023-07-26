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
import 'package:orghub/Screens/Auth/CheckCode/view.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/bloc.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/evens.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/states.dart';
import 'package:orghub/Screens/Auth/card.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:toast/toast.dart';

class ForgetPasswordView extends StatefulWidget {
  @override
  _ForgetPasswordViewState createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  TextEditingController _phoneController = TextEditingController();

  SendCodeBloc sendCodeBloc = kiwi.KiwiContainer().resolve<SendCodeBloc>();

  @override
  void dispose() {
    sendCodeBloc.close();
    super.dispose();
  }

  void _handleError({BuildContext context, SendCodeStatesFailed state}) {
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
              userName: _phoneController.text ?? "",
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
    FlashHelper.init(context);
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
              child: Stack(
                children: <Widget>[
                  Column(
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
                        onTap: () {
                          Get.back();
                        },
                        key: " ",
                        val: "",
                        isIntro: false,
                        type: translator.currentLanguage == "en"
                            ? "Reset password"
                            : "استرجاع كلمة المرور",
                      ),
                      sizedBox(),
                      _txt(
                        translator.currentLanguage == "en"
                            ? "Please enter your mobile number"
                            : " من فضلك قم بادخال البريد الالكترونى او رقم الجوال",
                      ),
                      _txt(
                        translator.currentLanguage == "en"
                            ? "to send activation code"
                            : "لارسال كود التفعيل ",
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      txtField(
                        context: context,
                        hintText: translator.currentLanguage == "en"
                            ? "Email or Phone"
                            : " البريد الالكترونى او رقم الجوال",
                        // validator: (String val) {
                        //   if (val.isEmpty) {
                        //     return "رقم الجوال مطلوب";
                        //   }
                        // },
                        textInputType: TextInputType.text,
                        controller: _phoneController,
                        obscureText: false,
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: BlocConsumer(
                          bloc: sendCodeBloc,
                          builder: (context, state) {
                            if (state is SendCodeStatesStart) {
                              return SpinKitCircle(
                                color: AppTheme.primaryColor,
                                size: 30,
                              );
                            } else {
                              return btn(
                                context,
                                translator.currentLanguage == "en"
                                    ? "Send"
                                    : "ارسال",
                                () {
                                  sendCodeBloc.add(SendCodeEventsStart(phone: _phoneController.text));
                                },
                              );
                            }
                          },
                          listener: (context, state) {
                            if (state is SendCodeStatesSuccess) {
                              Get.to(
                                BlocProvider(
                                  create: (_) => ActivateAccountBloc(),
                                  child: CheckCodeView(
                                    type: translator.currentLanguage == "en"
                                        ? "Reset password"
                                        : "استرجاع كلمة المرور",
                                    mobile: _phoneController.text,
                                    status: "forget password",
                                  ),
                                ),
                              );
                            } else if (state is SendCodeStatesFailed) {
                              _handleError(context: context, state: state);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _txt(String txt) {
    return Text(
      txt,
      style: TextStyle(
        color: AppTheme.accentColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
