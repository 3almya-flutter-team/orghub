import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/Notifications/DeleteNotification/bloc.dart';
import 'package:orghub/Screens/Notifications/DeleteNotification/events.dart';
import 'package:orghub/Screens/Notifications/DeleteNotification/states.dart';
import 'package:orghub/Screens/Notifications/bloc.dart';
import 'package:orghub/Screens/Notifications/card.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/Notifications/events.dart';
import 'package:orghub/Screens/Notifications/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/floating_modal.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:toast/toast.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  GetNotificationsBloc getNotificationsBloc =
      kiwi.KiwiContainer().resolve<GetNotificationsBloc>();
  NotificationsDeleteBloc notificationsDeleteBloc =
      kiwi.KiwiContainer().resolve<NotificationsDeleteBloc>();

  final ScrollController _scrollController = ScrollController();

  int pageNumber = 1;

  Widget _showLoader() {
    return Center(
      child: CupertinoActivityIndicator(
        animating: true,
        radius: 12,
      ),
    );
  }

  Widget _showEmptyWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      color: Colors.red,
      child: Center(
        child: Text(translator.currentLanguage == 'en' ? "Empty" : "لايوجد"),
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      getNotificationsBloc
          .add(GetNextNotificationsEvent(pageNum: ++pageNumber));
    }
    return false;
  }

  int calculateListItemCount(GetNotificationsStatesCompleted state) {
    if (state.hasReachedEndOfResults || state.hasReachedPageMax) {
      return state.notifications.length;
    } else {
      // + 1 for the loading indicator
      return state.notifications.length + 1;
    }
  }

  @override
  void initState() {
    getNotificationsBloc.add(GetNotificationsEventsStart(pageNum: pageNumber));
    super.initState();
  }

  @override
  void dispose() {
    getNotificationsBloc.close();
    notificationsDeleteBloc.close();
    super.dispose();
  }

  void _deleteNotification({String notificationId, int index}) {
    print("deleted chat id =-=-=> $notificationId");
    notificationsDeleteBloc.add(
      NotificationsDeleteEventsStart(notificationId: notificationId),
    );
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

  void opendeleteConfirmationDialog(
      {BuildContext context, String notificationId, int index}) {
    showFloatingModalBottomSheet(
      context: context,
      builder: (context, scrollController) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(translator.currentLanguage == 'en'
                ? "Are you sure  ?"
                : "هل تريد حقا مسح هذا الاشعار ؟"),
          ),
          BlocConsumer(
            bloc: notificationsDeleteBloc,
            builder: (context, state) {
              if (state is NotificationsDeleteStatesStart)
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SpinKitWave(
                    size: 17,
                    color: AppTheme.primaryColor,
                  ),
                );
              else {
                return FlatButton(
                  onPressed: () {
                    _deleteNotification(
                        notificationId: notificationId, index: index);
                  },
                  child: Text(
                    translator.currentLanguage == 'en' ? "Delete" : "حذف",
                    style: TextStyle(
                      fontFamily: "Neosans",
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              }
            },
            listener: (context, state) {
              if (state is NotificationsDeleteStatesSuccess) {
                FlashHelper.successBar(context,
                    message: translator.currentLanguage == 'en'
                        ? "Done"
                        : "تم المسح بنجاح");
                Get.back();
                getNotificationsBloc.add(
                  GetNotificationsEventsStart(pageNum: pageNumber),
                );
              } else if (state is NotificationsDeleteStatesFailed) {
                _handleError(state: state, context: context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: translator.currentLanguage == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppTheme.backGroundColor,
          appBar: appBar(
              context: context,
              title: translator.currentLanguage == "en"
                  ? "Notifications"
                  : "الاشعارات",
              leading: false),
          body: BlocBuilder(
              bloc: getNotificationsBloc,
              builder: (context, state) {
                if (state is GetNotificationsStatesStart) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitThreeBounce(
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  );
                } else if (state is GetNotificationsStatesCompleted) {
                  return state.notifications.isEmpty
                      ? Center(
                          child: Text(translator.currentLanguage == 'en'
                              ? "Empty"
                              : "لا يوجد"),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: _handleScrollNotification,
                          child: ListView.builder(
                            itemCount: calculateListItemCount(state),
                            shrinkWrap: true,
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return index >= state.notifications.length
                                  ? _showLoader()
                                  : notificationsCard(
                                      context: context,
                                      onTap: () {},
                                      name: state.notifications[index].title,
                                      img: state.notifications[index].image,
                                      body: state.notifications[index].body,
                                      onDeleteTapped: () {
                                        print(
                                            "=-=--== [DELETE NOTIFICATIONS] =-=-=-=");
                                        opendeleteConfirmationDialog(
                                            context: context,
                                            notificationId:
                                                state.notifications[index].id,
                                            index: index);
                                      });
                            },
                          ),
                        );
                } else if (state is GetNotificationsStatesNoData) {
                  return Center(
                    child: Text(translator.currentLanguage == 'en'
                        ? "Empty"
                        : "لا يوجد"),
                  );
                } else if (state is GetNotificationsStatesFailed) {
                  if (state.errType == 0) {
                    // FlashHelper.errorBar(context,
                    //     message: translator.currentLanguage == 'en'
                    //         ? "Please check your network connection."
                    //         : "برجاء التاكد من الاتصال بالانترنت ");
                    // Toast.show("222222", context);
                    return noInternetWidget(context);
                  } else {
                    // Toast.show("11111111", context);
                    // FlashHelper.errorBar(context,
                    //     message: state.msg ?? "");
                    return errorWidget(context, state.msg ?? "",state.statusCode);
                  }
                } else {
                  // FlashHelper.errorBar(context,
                  //     message: state.msg ?? "");
                  // Toast.show("3423422423", context);
                  return Container();
                }
              }),
        ));
  }
}
