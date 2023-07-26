import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Auth/ResetPassword/bloc.dart';
import 'package:orghub/Screens/Auth/ResetPassword/evens.dart';
import 'package:orghub/Screens/Auth/ResetPassword/states.dart';
import 'package:orghub/Screens/Auth/SignIn/bloc.dart';
import 'package:orghub/Screens/Auth/SignIn/view.dart';
import 'package:orghub/Screens/Auth/SuccessfullyActivated/view.dart';
import 'package:orghub/Screens/Auth/card.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class ResetPasswordView extends StatefulWidget {
  final String phone;
  final String code;

  const ResetPasswordView({Key key, this.phone, this.code}) : super(key: key);
  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  double sizedBoxHeight = 15.0;
  bool obscureText = true;
  String password, oldPassword;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  ResetPasswordeBloc resetPasswordeBloc =
      kiwi.KiwiContainer().resolve<ResetPasswordeBloc>();

  @override
  void dispose() {
    resetPasswordeBloc.close();
    super.dispose();
  }

  void _handleError({BuildContext context, ResetPasswordeStatesFailed state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      FlashHelper.errorBar(context, message: state.msg ?? "");
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            child: Form(
              key: formKey,
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
                    key: " ",
                    val: "",
                    isIntro: false,
                    type: translator.currentLanguage == "en"
                        ? "Reset password"
                        : "اعادة تعين كلمة المرور",
                  ),
                  sizedBox(),
                  _txt(
                    translator.currentLanguage == "en"
                        ? "Please enter new password"
                        : "من فضلك قم بادخال ",
                  ),
                  _txt(
                    translator.currentLanguage == "en"
                        ? ""
                        : "كلمة المرور الجديدة",
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  passwordTextField(
                      context: context,
                      validator: (String val) {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          // print("not equal $password");
                          return translator.currentLanguage == "en"
                              ? "Please check password"
                              : "من فضلك تأكد من كلمه المرور";
                        } else if (val.toString().length < 6) {
                          return translator.currentLanguage == "en"
                              ? "It must contain at least 6 numbers or letters"
                              : "يجب ان تحتوي علي 6 ارقام او احرف علي الأقل";
                        } else if (val.isEmpty)
                          return translator.currentLanguage == "en"
                              ? "Password is required"
                              : "كلمة المرور مطلوبة";
                        else {
                          print("jlkjkllk");
                          return null;
                        }
                      },
                      onSaved: null,
                      controller: _passwordController,
                      obscureText: obscureText,
                      onSuffixIconTapped: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      hintText: translator.currentLanguage == "en"
                          ? "New password"
                          : "كلمة المرور الجديدة"),
                  SizedBox(
                    height: sizedBoxHeight,
                  ),
                  passwordTextField(
                      context: context,
                      validator: (String val) {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          return translator.currentLanguage == "en"
                              ? "Please check password"
                              : "من فضلك تأكد من كلمه المرور";
                        } else if (val.isEmpty)
                          return translator.currentLanguage == "en"
                              ? "Password is required"
                              : "كلمة المرور مطلوبة";
                        else {
                          return null;
                        }
                      },
                      onSaved: (String val) {
                        setState(() {
                          password = val;
                        });
                      },
                      controller: _confirmPasswordController,
                      obscureText: obscureText,
                      onSuffixIconTapped: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      hintText: translator.currentLanguage == "en"
                          ? "Confirm new password"
                          : "تأكيد كلمة المرور الجديدة"),
                  BlocConsumer(
                    bloc: resetPasswordeBloc,
                    builder: (context, state) {
                      if (state is ResetPasswordeStatesStart) {
                        return SpinKitCircle(
                          color: AppTheme.primaryColor,
                          size: 30,
                        );
                      } else {
                        return btn(
                          context,
                          translator.currentLanguage == "en" ? "Send" : "ارسال",
                          () {
                            if (!formKey.currentState.validate() ||
                                _passwordController.text.isEmpty) {
                              FlashHelper.errorBar(context,
                                  message: "يجب كتابه كلمه المرور اولا ");
                              return;
                            } else {
                              resetPasswordeBloc.add(ResetPasswordeEventsStart(
                                  phone: widget.phone,
                                  code: widget.code,
                                  newPassword: _passwordController.text));
                            }
                          },
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is ResetPasswordeStatesSuccess) {
                        Get.to(
                          BlocProvider(
                            create: (_) => UserLoginBloc(),
                            child: SignInView(),
                          ),
                        );
                      } else if (state is ResetPasswordeStatesFailed) {
                        _handleError(context: context, state: state);
                      }
                    },
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 40, bottom: 20),
                  //   child: btn(
                  //     context,
                  //     translator.currentLanguage == "en" ? "Send" : "ارسال",
                  //     () {
                  //       Get.to(
                  //         SuccessfullyActivatedView(
                  //           type: translator.currentLanguage == "en"
                  //               ? "Account is activated successfully"
                  //               : "تم تفعيل الحساب بنجاح",
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
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
