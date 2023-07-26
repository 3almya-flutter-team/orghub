import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/states.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/bloc.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/events.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/states.dart';
import 'package:orghub/Screens/ProductDetails/Report/bloc.dart';
import 'package:orghub/Screens/ProductDetails/Report/events.dart';
import 'package:orghub/Screens/ProductDetails/Report/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:toast/toast.dart';

class ReportView extends StatefulWidget {
  final int advertId;
  ReportView({Key key, this.advertId}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  GetReportReasonsBloc getReportReasonsBloc =
      kiwi.KiwiContainer().resolve<GetReportReasonsBloc>();
  SendReportBloc sendReportBloc =
      kiwi.KiwiContainer().resolve<SendReportBloc>();

  int selectedReasonId;
  TextEditingController _reportController = TextEditingController();

  @override
  void initState() {
    getReportReasonsBloc.add(GetReportReasonsEventsStart());
    super.initState();
  }

  @override
  void dispose() {
    getReportReasonsBloc.close();
    sendReportBloc.close();
    super.dispose();
  }

  void _handleError({BuildContext context, SendReportStatesFailed state}) {
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
    sendReportBloc.add(SendReportEventsStart(
        advertId: widget.advertId,
        msg: _reportController.text,
        reasonId: selectedReasonId));
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "الابلاغ",
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontFamily: "Neosans",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text("من فضلك قم باختيار سبب الابلاغ"),
            ),
            Expanded(
              child: BlocBuilder(
                  bloc: getReportReasonsBloc,
                  builder: (context, state) {
                    if (state is GetReportReasonsStatesStart) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SpinKitThreeBounce(
                          color: AppTheme.primaryColor,
                          size: 30,
                        ),
                      );
                    } else if (state is GetReportReasonsStatesSuccess) {
                      return ListView.builder(
                          itemCount: state.reasons.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                int selectedIndex = state.reasons.indexWhere(
                                    (element) =>
                                        element.id == state.reasons[index].id);

                                state.reasons[selectedIndex].selected = true;
                                setState(() {
                                  selectedReasonId =
                                      state.reasons[selectedIndex].id;
                                });

                                state.reasons.forEach((otherElement) {
                                  if (otherElement.id !=
                                      state.reasons[selectedIndex].id) {
                                    int otherIndex = state.reasons.indexWhere(
                                        (item) => item.id == otherElement.id);

                                    state.reasons[otherIndex].selected = false;
                                    setState(() {});
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(),
                                      ),
                                      child: Center(
                                        child: !state.reasons[index].selected
                                            ? Container()
                                            : Container(
                                                width: 14,
                                                height: 14,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: AppTheme.primaryColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(state.reasons[index].name),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else if (state is GetReportReasonsStatesFailed) {
                      if (state.errType == 0) {
                        return noInternetWidget(context);
                      } else {
                        // FlashHelper.errorBar(context,
                        //     message: state.msg ?? "");
                        return errorWidget(context, state.msg ?? "",state.statusCode);
                      }
                    } else {
                      // FlashHelper.errorBar(context,
                      //     message: state.msg ?? "");
                      return Container();
                    }
                  }),
            ),
            TextField(
              controller: _reportController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "من فضلك اكتب سبب الابلاغ",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            BlocConsumer(
              bloc: sendReportBloc,
              builder: (context, state) {
                if (state is SendReportStatesStart)
                  return SpinKitCircle(
                    color: AppTheme.primaryColor,
                    size: 40.0,
                  );
                else
                  return btn(context, "ابلاغ", () {
                    _submit();
                  });
              },
              listener: (context, state) {
                if (state is SendReportStatesSuccess) {
                  Toast.show("تم الارسال بنجاح ", context);
                  Get.back();
                } else if (state is SendReportStatesFailed) {
                  _handleError(state: state, context: context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
