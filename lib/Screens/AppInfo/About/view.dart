import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/AppInfo/About/bloc.dart';
import 'package:orghub/Screens/AppInfo/About/events.dart';
import 'package:orghub/Screens/AppInfo/About/states.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  GetAboutDataBloc getAboutDataBloc =
      kiwi.KiwiContainer().resolve<GetAboutDataBloc>();

  @override
  void initState() {
    getAboutDataBloc.add(GetAboutDataEventsStart());
    super.initState();
  }

  @override
  void dispose() {
    getAboutDataBloc.close();
    super.dispose();
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
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
        appBar: appBar(
            context: context,
            leading: true,
            title: translator.currentLanguage == "en"
                ? "About company"
                : "عن الشركة"),
        backgroundColor: AppTheme.backGroundColor,
        body: BlocBuilder(
            bloc: getAboutDataBloc,
            builder: (context, state) {
              if (state is GetAboutDataStatesStart) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                );
              } else if (state is GetAboutDataStatesSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 20),
                        child: Center(
                            child: Image.asset(
                          "assets/icons/logox.png",
                          width: 150,
                          height: 150,
                        )),
                      ),
                      Html(
                        data: state.aboutData.about,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                            child: Image.asset(
                          "assets/icons/it_support.png",
                          width: 150,
                          height: 150,
                        )),
                      ),
                      Text(
                        translator.currentLanguage == "en"
                            ? "For your service always , contact us now"
                            : "بخدمتكم دائما , تحدث الينا الان",
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 15),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _avatarItem(
                              context: context,
                              onTap: () {
                                launch(('tel://${state.aboutData.phone}'));
                              },
                              img: "assets/icons/call.png"),
                          _avatarItem(
                              context: context,
                              onTap: () {
                                launch(Uri(
                                        scheme: 'mailto',
                                        path: state.aboutData.email,
                                        queryParameters: {'subject': ''})
                                    .toString());
                              },
                              img: "assets/icons/gmail.png"),
                          _avatarItem(
                              context: context,
                              onTap: () {
                                launchWhatsApp(
                                    message: "",
                                    phone: state.aboutData.whatsapp);
                              },
                              img: "assets/icons/whats-black.png"),
                          _avatarItem(
                              context: context,
                              onTap: () {
                                launch(('sms://${state.aboutData.smsMessage}'));
                              },
                              img: "assets/icons/sms.png"),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                );
              } else if (state is GetAboutDataStatesFailed) {
                if (state.errType == 0) {
                  // FlashHelper.errorBar(context,
                  //     message: translator.currentLanguage == 'en'
                  //         ? "Please check your network connection."
                  //         : "برجاء التاكد من الاتصال بالانترنت ");
                  return noInternetWidget(context);
                } else {
                  // FlashHelper.errorBar(context,
                  //     message: state.msg ?? "");
                  return Container();
                }
              } else {
                // FlashHelper.errorBar(context,
                //     message: state.msg ?? "");
                return Container();
              }
            }),
      ),
    );
  }

  _avatarItem({BuildContext context, String img, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppTheme.thirdColor,
            image: DecorationImage(
              image: AssetImage(
                img,
              ),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
