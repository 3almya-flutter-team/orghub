import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/UpdatePassword/bloc.dart';
import 'package:orghub/Screens/UpdatePassword/events.dart';
import 'package:orghub/Screens/UpdatePassword/states.dart';
import 'package:toast/toast.dart';

class UpdatePasswordView extends StatefulWidget {
  @override
  _UpdatePasswordViewState createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  GlobalKey<FormState> _fkey = GlobalKey<FormState>();

  UpdatePasswordBloc updatePasswordBloc =
      kiwi.KiwiContainer().resolve<UpdatePasswordBloc>();

  String newPass;
  String oldPass;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    updatePasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _handleError(
        {BuildContext context, UpdatePasswordStatesFailed state}) {
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

    void _submit(BuildContext context) {
      if (!_fkey.currentState.validate()) {
        return;
      } else {
        _fkey.currentState.save();
        updatePasswordBloc.add(UpdatePasswordEventsStart(
          oldPass: oldPass,
          newPass: newPass,
        ));
      }
    }

    return Scaffold(
      appBar: appBar(
          context: context,
          leading: true,
          title: translator.currentLanguage == "en"
              ? "Edit password"
              : "تعديل كلمة المرور"),
      backgroundColor: AppTheme.backGroundColor,
      body: Directionality(
        textDirection: translator.currentLanguage == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: SingleChildScrollView(
          child: Form(
            key: _fkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                _txt(
                  translator.currentLanguage == "en"
                      ? " Old Password"
                      : "كلمة المرور الحاليه",
                ),
                textFormFieldUpdate(
                  context: context,
                  controller: null,
                  validator: (val) {
                    if (val.isEmpty) {
                      return translator.currentLanguage == "en"
                          ? "Old password is required"
                          : "كلمه المرور القديمه مطلوبه";
                    }
                  },
                  textInputType: TextInputType.visiblePassword,
                  onSaved: (val) {
                    setState(() {
                      oldPass = val;
                    });
                  },
                  hint: translator.currentLanguage == "en"
                      ? "Old Password"
                      : "كلمة المرور الحاليه",
                  secure: true,
                ),
                SizedBox(
                  height: 30,
                ),
                _txt(
                  translator.currentLanguage == "en"
                      ? "New Password"
                      : "كلمه المرور الجديده",
                ),
                textFormFieldUpdate(
                  context: context,
                  controller: null,
                  validator: (val) {
                    if (val.isEmpty) {
                      return translator.currentLanguage == "en"
                          ? "New password is required"
                          : "كلمه المرور الجديده مطلوبه";
                    }
                  },
                  textInputType: TextInputType.visiblePassword,
                  onSaved: (val) {
                    setState(() {
                      newPass = val;
                    });
                  },
                  hint: translator.currentLanguage == "en"
                      ? "New Password"
                      : " كلمة المرور الجديدة",
                  secure: true,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 530,
                ),
                BlocConsumer(
                  bloc: updatePasswordBloc,
                  builder: (context, state) {
                    if (state is UpdatePasswordStatesStart)
                      return SpinKitCircle(
                        color: AppTheme.primaryColor,
                        size: 40.0,
                      );
                    else
                      return btn(
                        context,
                        translator.currentLanguage == "en" ? "Edit" : "تعديل",
                        () {
                          _submit(context);
                        },
                      );
                  },
                  listener: (context, state) {
                    if (state is UpdatePasswordStatesSuccess) {
                      _fkey.currentState.reset();
                      Toast.show(
                          translator.currentLanguage == "en"
                              ? "Done"
                              : "تم تعديل كلمه المرور بنجاح  ",
                          context);
                    } else if (state is UpdatePasswordStatesFailed) {
                      _handleError(state: state, context: context);
                    }
                  },
                ),
                sizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _txt(String txt) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Text(
        txt,
        style: TextStyle(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.w800,
            fontSize: 14),
      ),
    );
  }
}
