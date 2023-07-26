import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_bloc.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_events.dart';
import 'package:orghub/Screens/Complaints&Suggestions/bloc.dart';
import 'package:orghub/Screens/Complaints&Suggestions/events.dart';
import 'package:orghub/Screens/Complaints&Suggestions/states.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Utils/FormBuilder/flutter_form_builder.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:toast/toast.dart';

class ComplaintsView extends StatefulWidget {
  final String type;
  ComplaintsView({Key key, this.type}) : super(key: key);

  @override
  _ComplaintsViewState createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<ComplaintsView> {
  GlobalKey<FormBuilderState> _fbkeys = GlobalKey<FormBuilderState>();

  AppInitBloc getAllMarksBloc = kiwi.KiwiContainer().resolve<AppInitBloc>();
  ContactBloc contactBloc = kiwi.KiwiContainer().resolve<ContactBloc>();
  bool _isAuth = false;
  @override
  void initState() {
    getAllMarksBloc.add(AppStarted());
    getAllMarksBloc.isAuthenticated().then((value) {
      setState(() {
        _isAuth = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    getAllMarksBloc.close();
    contactBloc.close();
    super.dispose();
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
      FlashHelper.errorBar(context, message: state.msg ?? "");
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  _submit() {
    if (!_fbkeys.currentState.validate()) {
      return;
    } else {
      _fbkeys.currentState.save();
      Map<String, dynamic> contactData = _fbkeys.currentState.value;
      contactData.putIfAbsent("type", () => "استفسار");
      contactBloc.add(
        ContactEventsStart(contactData: contactData,type: widget.type),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Scaffold(
      backgroundColor: AppTheme.backGroundColor,
      appBar: appBar(
          context: context,
          title: translator.currentLanguage == "en"
              ? "Using policy"
              : "الشكاوى والاقتراحات",
          leading: true),
      body: FormBuilder(
        key: _fbkeys,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              widget.type == 'auth'
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: "fullname",
                        decoration: InputDecoration(
                          labelText: translator.currentLanguage == 'en'
                              ? "Fullname"
                              : "الاسم بالكامل",
                          hintStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontSize: 12,
                            color: Color(getColorHexFromStr("#949494")),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: AppTheme.fontName,
                          ),
                        ),
                        validators: !_isAuth
                            ? [
                                FormBuilderValidators.required(
                                    errorText:
                                        translator.currentLanguage == "ar"
                                            ? "هذا الحقل مطلوب"
                                            : "This field is required.")
                              ]
                            : [],
                      ),
                    ),
              widget.type == 'auth'
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: "email",
                        decoration: InputDecoration(
                          labelText: translator.currentLanguage == 'en'
                              ? "Email"
                              : "البريد الالكترونى",
                          hintStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontSize: 12,
                            color: Color(getColorHexFromStr("#949494")),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: AppTheme.fontName,
                          ),
                        ),
                        validators: !_isAuth
                            ? [
                                FormBuilderValidators.required(
                                    errorText:
                                        translator.currentLanguage == "ar"
                                            ? "هذا الحقل مطلوب"
                                            : "This field is required."),
                                FormBuilderValidators.email(
                                    errorText: translator.currentLanguage ==
                                            "ar"
                                        ? "البريد الالكترونى غير صحيح"
                                        : 'This field requires a valid URL address.')
                              ]
                            : [],
                      ),
                    ),
              widget.type == 'auth'
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: "phone",
                        decoration: InputDecoration(
                          labelText: translator.currentLanguage == 'en'
                              ? "Phone"
                              : "رقم الجوال",
                          hintStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontSize: 12,
                            color: Color(getColorHexFromStr("#949494")),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: AppTheme.fontName,
                          ),
                        ),
                        validators: !_isAuth
                            ? [
                                FormBuilderValidators.required(
                                    errorText:
                                        translator.currentLanguage == "ar"
                                            ? "هذا الحقل مطلوب"
                                            : "This field is required."),
                                FormBuilderValidators.numeric()
                              ]
                            : [],
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderTextField(
                  attribute: "title",
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: translator.currentLanguage == 'en'
                        ? "Address "
                        : "العنوان",
                    hintStyle: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 12,
                      color: Color(getColorHexFromStr("#949494")),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: AppTheme.fontName,
                    ),
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: translator.currentLanguage == "ar"
                            ? "هذا الحقل مطلوب"
                            : "This field is required.")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderTextField(
                  attribute: "content",
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: translator.currentLanguage == 'en'
                        ? "Subject"
                        : "الموضوع",
                    hintStyle: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 12,
                      color: Color(getColorHexFromStr("#949494")),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: AppTheme.fontName,
                    ),
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: translator.currentLanguage == "ar"
                            ? "هذا الحقل مطلوب"
                            : "This field is required.")
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocConsumer(
                bloc: contactBloc,
                builder: (context, state) {
                  if (state is ContactStatesStart)
                    return SpinKitCircle(
                      color: AppTheme.primaryColor,
                      size: 40.0,
                    );
                  else
                    return btn(context,
                        translator.currentLanguage == 'en' ? "Send" : "ارسال",
                        () {
                      _submit();
                    });
                },
                listener: (context, state) {
                  if (state is ContactStatesSuccess) {
                    Toast.show(
                        translator.currentLanguage == 'en'
                            ? "Done"
                            : "تم الارسال بنجاح ",
                        context);
                    _fbkeys.currentState.reset();
                  } else if (state is ContactStatesFailed) {
                    _handleError(state: state, context: context);
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
