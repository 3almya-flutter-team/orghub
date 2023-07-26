import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/bloc.dart';
import 'package:orghub/Screens/Chat/view.dart';
import 'package:orghub/Screens/Conversations/Delete/bloc.dart';
import 'package:orghub/Screens/Conversations/Delete/events.dart';
import 'package:orghub/Screens/Conversations/Delete/states.dart';
import 'package:orghub/Screens/Conversations/bloc.dart';
import 'package:orghub/Screens/Conversations/card.dart';
import 'package:orghub/Screens/Conversations/events.dart';
import 'package:orghub/Screens/Conversations/states.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/floating_modal.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class ConversationsView extends StatefulWidget {
  @override
  _ConversationsViewState createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView> {
  GetAllChatsBloc getAllChatsBloc =
      kiwi.KiwiContainer().resolve<GetAllChatsBloc>();
  ChatsDeleteBloc deleteBloc = kiwi.KiwiContainer().resolve<ChatsDeleteBloc>();

  int pageNumber = 1;

  @override
  void initState() {
    getAllChatsBloc.add(GetAllChatsEventsStart(pageNum: pageNumber));
    super.initState();
  }

  @override
  void dispose() {
    getAllChatsBloc.close();
    deleteBloc.close();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      getAllChatsBloc.add(GetNextChatsEvent(pageNum: ++pageNumber));
    }
    return false;
  }

  int calculateListItemCount(GetAllChatsStatesCompleted state) {
    if (state.hasReachedEndOfResults || state.hasReachedPageMax) {
      return state.conversations.length;
    } else {
      // + 1 for the loading indicator
      return state.conversations.length + 1;
    }
  }

  void _deleteChat({int chatId, int index}) {
    print("deleted chat id =-=-=> $chatId");
    deleteBloc.add(
      ChatsDeleteEventsStart(chatId: chatId),
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
      {BuildContext context, int chatId, int index}) {
    print("=-=-=>%%%% $chatId");
    showFloatingModalBottomSheet(
      context: context,
      builder: (context, scrollController) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(translator.currentLanguage == 'en'
                ? "Are you sure  ?"
                : "هل تريد حقا مسح هذه المحادثه ؟"),
          ),
          BlocConsumer(
            bloc: deleteBloc,
            builder: (context, state) {
              if (state is ChatsDeleteStatesStart)
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
                    _deleteChat(chatId: chatId, index: index);
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
              if (state is ChatsDeleteStatesSuccess) {
                FlashHelper.successBar(context,
                    message: translator.currentLanguage == 'en'
                        ? "Done"
                        : "تم المسح بنجاح");
                Get.back();
                getAllChatsBloc.add(
                  GetAllChatsEventsStart(pageNum: pageNumber),
                );
              } else if (state is ChatsDeleteStatesFailed) {
                _handleError(state: state, context: context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _showLoader() {
    return Center(
      child: CupertinoActivityIndicator(
        animating: true,
        radius: 12,
      ),
    );
  }

  String searchVal;

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection: translator.currentLanguage == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        appBar: appBar(
            context: context,
            title: translator.currentLanguage == "en"
                ? "Conversations"
                : "المحادثات",
            leading: false),
        body: Column(
          children: <Widget>[
            searchTextFormFiled(
              context: context,
              // onSearchTapped: () {
              //   getAllChatsBloc.add(
              //     GetAllChatsSearchEventStart(term: searchVal, pageNum: pageNumber),
              //   );
              // },
              onChange: (val) {
                // setState(() {
                //   searchVal = val;
                // });
                getAllChatsBloc.add(
                  GetAllChatsSearchEventStart(term: val, pageNum: pageNumber),
                );
              },
            ),
            SizedBox(
              height: 8,
            ),
            BlocBuilder(
                bloc: getAllChatsBloc,
                builder: (context, state) {
                  if (state is GetAllChatsStatesStart) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitThreeBounce(
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    );
                  } else if (state is GetAllChatsStatesNoData) {
                    return Center(
                      child: Text(translator.currentLanguage == 'en'
                          ? "Empty"
                          : "لا يوجد"),
                    );
                  } else if (state is GetAllChatsStatesCompleted) {
                    return Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: _handleScrollNotification,
                        child: ListView.builder(
                          itemCount: calculateListItemCount(state),
                          shrinkWrap: true,
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return index >= state.conversations.length
                                ? _showLoader()
                                : state.conversations.isEmpty
                                    ? Center(
                                        child: Text(
                                            translator.currentLanguage == 'en'
                                                ? "Empty"
                                                : "لا يوجد"),
                                      )
                                    : conversationsCard(
                                        context: context,
                                        date: state.conversations[index].readAt
                                            .toString(),
                                        onTap: () {
                                          Get.to(BlocProvider(
                                            create: (_) => SendMessageBloc(),
                                            child: ChatScreen(
                                              chatId: state
                                                  .conversations[index].chatId,
                                              receiverName: state
                                                  .conversations[index]
                                                  .senderData
                                                  .fullname,
                                              receiverId: state
                                                  .conversations[index]
                                                  .senderData
                                                  .id,
                                            ),
                                          ));
                                        },
                                        name: state.conversations[index]
                                            .senderData.fullname,
                                        img: state.conversations[index]
                                                .senderData.image ??
                                            AppTheme.defaultImage,
                                        body: state
                                            .conversations[index].lastMessage,
                                        onDeleteTapped: () {
                                          print(
                                              "=-=-=-= ${state.conversations[index].chatId}");
                                          opendeleteConfirmationDialog(
                                              context: context,
                                              chatId: state
                                                  .conversations[index].chatId,
                                              index: index);
                                        },
                                      );
                          },
                        ),
                      ),
                    );
                  } else if (state is GetAllChatsStatesFailed) {
                    if (state.errType == 0) {
                      // FlashHelper.errorBar(context,
                      //     message: translator.currentLanguage == 'en'
                      //         ? "Please check your network connection."
                      //         : "برجاء التاكد من الاتصال بالانترنت ");
                      return noInternetWidget(context);
                    } else {
                      // FlashHelper.errorBar(context, message: state.msg ?? "");
                      return errorWidget(context, state.msg ?? "",state.statusCode);
                    }
                  } else {
                    // FlashHelper.errorBar(context, message: state.msg ?? "");
                    return Container();
                  }
                })
          ],
        ),
      ),
    );
  }
}
