import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Auth/Activation/bloc.dart';
import 'package:orghub/Screens/Auth/Activation/events.dart';
import 'package:orghub/Screens/Auth/Activation/states.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/bloc.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/evens.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/states.dart';
import 'package:orghub/Screens/Auth/SuccessfullyActivated/view.dart';
import 'package:orghub/Screens/Auth/card.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:toast/toast.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class ActivationView extends StatefulWidget {
  final String type, userName, status;
  const ActivationView(
      {Key key, this.type, this.userName, this.status})
      : super(key: key);
  @override
  _ActivationViewState createState() => _ActivationViewState();
}

class _ActivationViewState extends State<ActivationView> {
  String phone;
  SendCodeBloc sendCodeBloc = kiwi.KiwiContainer().resolve<SendCodeBloc>();

  String userName;

  @override
  void initState() {
    _startCountDown();
    
    super.initState();
  }

  

  @override
  void dispose() {
    sendCodeBloc.close();
    timer.cancel();
    super.dispose();
  }

  void _submit({BuildContext context}) {
    // timer.cancel();
    if (code.text.isEmpty) {
      FlashHelper.errorBar(context,
          message: translator.currentLanguage == 'en'
              ? "Code is required."
              : "الكود مطلوب");
      return;
    }
    if (widget.userName == "" || widget.userName == null) {
      FlashHelper.errorBar(context,
          message: translator.currentLanguage == 'en'
              ? "Mobile or Email is required."
              : "رقم الجوال او البريد الالكترونى مطلوب");
      return;
    }

    BlocProvider.of<ActivateAccountBloc>(context).add(
      ActivateAccountEventsStart(
        phone: widget.userName,
        code: code.text,
      ),
    );
  }

  Timer timer;
  int hours;
  int minutes;
  int seconds;
  int endDate;
  bool stop = false;
  void _startCountDown() {
    print("timer started");
    DateTime now = new DateTime.now();
    int endDate = now
        .add(Duration(
          minutes: 1,
        ))
        .toUtc()
        .millisecondsSinceEpoch;
    timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
      var now = DateTime.now().toUtc().millisecondsSinceEpoch;
      var distance = endDate - now;
      Duration remaining = Duration(milliseconds: endDate - now);

      setState(() {
        hours = remaining.inHours;
        minutes = DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds)
            .minute;
        seconds = DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds)
            .second;
      });
      // print("$hours $minutes $seconds");

      if (distance <= 0) {
        timer.cancel();
        // sendCodeBloc.add(
        //   SendCodeEventsStart(phone: widget.mobile),
        // );
        stop = true;
        print('finish');
      }
    });
  }

  void _handleError({BuildContext context, dynamic state}) {
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
      if (state.statusCode == 422) {
        FlashHelper.errorBar(context, message: state.msg ?? "");
      } else {
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
        body: SingleChildScrollView(
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
                    key: "",
                    val: "",
                    isIntro: false,
                    type: widget.type,
                  ),
                  sizedBox(),
                  _txt(
                    translator.currentLanguage == "en"
                        ? "Please enter activation code"
                        : "من فضلك قم بادخال كود التفعيل",
                  ),
                  _txt(
                    translator.currentLanguage == "en"
                        ? "that sent to your mobile"
                        : "المرسل اليك على ",
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    widget.userName ?? "",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      stop ? "00:00" : "${minutes ?? 01}:${seconds ?? 00}",
                      style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocConsumer(
                    bloc: sendCodeBloc,
                    builder: (context, state) {
                      if (state is SendCodeStatesStart) {
                        return SpinKitCircle(
                          color: AppTheme.primaryColor,
                          size: 30,
                        );
                      } else {
                        return Center(
                          child: stop
                              ? InkWell(
                                  onTap: () {
                                    sendCodeBloc.add(
                                      SendCodeEventsStart(phone: widget.userName),
                                    );
                                  },
                                  child: Text(
                                    translator.currentLanguage == "en"
                                        ? "Re send code"
                                        : "ارسال مرة اخرى",
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900),
                                  ),
                                )
                              : Container(),
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is SendCodeStatesSuccess) {
                        _startCountDown();
                        code.text = "";
                        stop = false;
                        // setState(() {});
                        Toast.show(
                            translator.currentLanguage == 'en'
                                ? "Activation code has been sent successfully"
                                : "تم ارسال كود التفعيل بنجاح",
                            context);
                      } else if (state is SendCodeStatesFailed) {
                        _handleError(context: context, state: state);
                      }
                    },
                  ),

                  // InkWell(
                  //   onTap: () {
                  //     Get.back();
                  //   },
                  //   child: Text(
                  //     translator.currentLanguage == "en"
                  //         ? "Edit mobile number"
                  //         : "نعديل رقم الجوال",
                  //     style: TextStyle(
                  //       color: AppTheme.primaryColor,
                  //       fontSize: 13,
                  //       decoration: TextDecoration.underline,
                  //       fontWeight: FontWeight.w800,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Directionality(
                      textDirection: translator.currentLanguage == 'en'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: PinCodeTextField(
                        onChanged: (h) {},
                        length: 4,
                        controller: code,
                        obsecureText: false,
                        textInputType: TextInputType.number,
                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Colors.white.withOpacity(0),
                        textInputAction: TextInputAction.done,
                        enableActiveFill: true,
                        enabled: true,
                        animationCurve: Curves.ease,
                        autoFocus: true,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        autoDisposeControllers: true,
                        autoDismissKeyboard: true,
                        pinTheme: PinTheme(
                            selectedColor: AppTheme.primaryColor,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                            inactiveColor: Colors.grey,
                            activeColor: AppTheme.primaryColor,
                            disabledColor: AppTheme.primaryColor,
                            borderWidth: .5,
                            selectedFillColor: AppTheme.thirdColor,
                            inactiveFillColor: Colors.transparent),
                      ),
                    ),
                  ),
                  BlocConsumer<ActivateAccountBloc, ActivateAccountStates>(
                    builder: (context, state) {
                      if (state is ActivateAccountStatesStart)
                        return SpinKitCircle(
                          color: AppTheme.primaryColor,
                          size: 40.0,
                        );
                      else
                        return btn(
                          context,
                          translator.currentLanguage == "en"
                              ? "Activate"
                              : "تفعيل",
                          () {
                            _submit(context: context);
                          },
                        );
                    },
                    listener: (context, state) {
                      if (state is ActivateAccountStatesSuccess) {
                        Toast.show("تم تفعيل الحساب بنجاح ", context);

                        Get.to(
                          // widget.type == "forget password"
                          //     ? ResetPasswordView()
                          //     :
                          SuccessfullyActivatedView(
                            type: translator.currentLanguage == "en"
                                ? "Account is activated successfully"
                                : "تم تفعيل الحساب بنجاح",
                          ),
                        );
                      } else if (state is ActivateAccountStatesFailed) {
                        _handleError(state: state, context: context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController code = TextEditingController();
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
