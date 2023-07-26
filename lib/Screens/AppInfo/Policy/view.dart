import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';

import 'package:orghub/Screens/AppInfo/Policy/bloc.dart';
import 'package:orghub/Screens/AppInfo/Policy/events.dart';
import 'package:orghub/Screens/AppInfo/Policy/states.dart';

import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class PolicyView extends StatefulWidget {
  @override
  _PolicyViewState createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
  GetPolicyDataBloc getPolicyDataBloc =
      kiwi.KiwiContainer().resolve<GetPolicyDataBloc>();

  @override
  void initState() {
    getPolicyDataBloc.add(GetPolicyDataEventsStart());
    super.initState();
  }

  @override
  void dispose() {
    getPolicyDataBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.currentLanguage == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        appBar: appBar(
            context: context,
            title: translator.currentLanguage == "en"
                ? "Using policy"
                : "سياسة الاستخدام",
            leading: true),
        body: BlocBuilder(
            bloc: getPolicyDataBloc,
            builder: (context, state) {
              if (state is GetPolicyDataStatesStart) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                );
              } else if (state is GetPolicyDataStatesSuccess) {
                return SingleChildScrollView(
                    child: Center(
                  child: Html(
                    data: state.policyData.policy,
                    padding: EdgeInsets.all(8),
                  ),
                ));
              } else if (state is GetPolicyDataStatesFailed) {
                if (state.errType == 0) {
                  return noInternetWidget(context);
                } else {
                  // FlashHelper.errorBar(context,
                  //     message: state.msg ?? "");
                  return errorWidget(context, state.msg,state.statusCode);
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
}
