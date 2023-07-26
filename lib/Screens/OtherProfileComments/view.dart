import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/OtherProfileComments/bloc.dart';
import 'package:orghub/Screens/OtherProfileComments/card.dart';
import 'package:orghub/Screens/OtherProfileComments/events.dart';
import 'package:orghub/Screens/OtherProfileComments/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class AllCompanyCommentsView extends StatefulWidget {
  final int companyId;

  const AllCompanyCommentsView({Key key, this.companyId}) : super(key: key);
  @override
  _AllCompanyCommentsViewState createState() => _AllCompanyCommentsViewState();
}

class _AllCompanyCommentsViewState extends State<AllCompanyCommentsView> {
  GetAllCompanyCommentsBloc getAllCompanyCommentsBloc =
      kiwi.KiwiContainer().resolve<GetAllCompanyCommentsBloc>();

  @override
  void initState() {
    getAllCompanyCommentsBloc
        .add(GetAllCompanyCommentsEventsStart(companyId: widget.companyId));
    super.initState();
  }

  @override
  void dispose() {
    getAllCompanyCommentsBloc.close();
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
                translator.currentLanguage == "en" ? "All Comments" : "كل التعليقات",
            leading: true),
        body: BlocBuilder(
          bloc: getAllCompanyCommentsBloc,
          builder: (context, state) {
            if (state is GetAllCompanyCommentsStatesStart) {
              return SpinKitThreeBounce(
                color: AppTheme.primaryColor,
                size: 30,
              );
            } else if (state is GetAllCompanyCommentsStatesSuccess) {
              return state.allComments.isEmpty
                  ? Center(
                      child: Text(translator.currentLanguage == "en"
                          ? "Empty"
                          : "لايوجد"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.allComments.length,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      itemBuilder: (BuildContext context, int index) {
                        return myCommentsCard(
                            context: context,
                            name: state.allComments[index].name,
                            date: state.allComments[index].createdAt.toString(),
                            stars: double.parse(
                              state.allComments[index].rate.toString(),
                            ),
                            comment: state.allComments[index].review,
                            img: state.allComments[index].image);
                      },
                    );
            } else if (state is GetAllCompanyCommentsStatesFailed) {
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
