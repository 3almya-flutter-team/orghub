import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/MyComments/bloc.dart';
import 'package:orghub/Screens/MyComments/card.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/MyComments/events.dart';
import 'package:orghub/Screens/MyComments/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class MyCommentsView extends StatefulWidget {
  @override
  _MyCommentsViewState createState() => _MyCommentsViewState();
}

class _MyCommentsViewState extends State<MyCommentsView> {
  GetAllCommentsBloc getAllCommentsBloc =
      kiwi.KiwiContainer().resolve<GetAllCommentsBloc>();

  @override
  void initState() {
    getAllCommentsBloc.add(GetAllCommentsEventsStart());
    super.initState();
  }

  @override
  void dispose() {
    getAllCommentsBloc.close();
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
            title:
                translator.currentLanguage == "en" ? "My comments" : "تعليقاتى",
            leading: true),
        body: BlocBuilder(
          bloc: getAllCommentsBloc,
          builder: (context, state) {
            if (state is GetAllCommentsStatesStart) {
              return SpinKitThreeBounce(
                color: AppTheme.primaryColor,
                size: 30,
              );
            } else if (state is GetAllCommentsStatesSuccess) {
              return state.myComments.isEmpty
                  ? Center(
                      child: Text(translator.currentLanguage == "en"
                          ? "Empty"
                          : "لايوجد"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.myComments.length,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      itemBuilder: (BuildContext context, int index) {
                        return myCommentsCard(
                            context: context,
                            name: state.myComments[index].name ??"",
                            date: state.myComments[index].createdAt.toString(),
                            stars: double.parse(
                              state.myComments[index].rate.toString(),
                            ),
                            comment: state.myComments[index].review,
                            img: state.myComments[index].image);
                      },
                    );
            } else if (state is GetAllCommentsStatesFailed) {
              if (state.errType == 0) {
                return noInternetWidget(context);
              } else {
                return errorWidget(context, state.msg??"",state.statusCode);
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
