import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/Favourite/RemoveFromFav/bloc.dart';
import 'package:orghub/Screens/Favourite/RemoveFromFav/events.dart';
import 'package:orghub/Screens/Favourite/RemoveFromFav/states.dart';
import 'package:orghub/Screens/Favourite/bloc.dart';
import 'package:orghub/Screens/Favourite/events.dart';
import 'package:orghub/Screens/Favourite/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/floating_modal.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class FavouriteView extends StatefulWidget {
  @override
  _FavouriteViewState createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  GetAllFavAdsBloc getAllFavAdsBloc =
      kiwi.KiwiContainer().resolve<GetAllFavAdsBloc>();
  RemoveFromFavBloc removeFromFavBloc =
      kiwi.KiwiContainer().resolve<RemoveFromFavBloc>();

  @override
  void initState() {
    getAllFavAdsBloc.add(GetAllFavAdsEventsStart());
    super.initState();
  }

  @override
  void dispose() {
    removeFromFavBloc.close();
    super.dispose();
  }

  void _deleteFromFav({int advertId, int index}) {
    print("deleted chat id =-=-=> $advertId");
    removeFromFavBloc.add(
      RemoveFromFavEventsStart(advertId: advertId),
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
      {BuildContext context, int advertId, int index}) {
    showFloatingModalBottomSheet(
      context: context,
      builder: (context, scrollController) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(translator.currentLanguage == 'en'
                ? "Are you sure  ?"
                : "هل تريد حقا مسح المنتج من المفضله ؟"),
          ),
          BlocConsumer(
            bloc: removeFromFavBloc,
            builder: (context, state) {
              if (state is RemoveFromFavStatesStart)
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
                    _deleteFromFav(advertId: advertId, index: index);
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
              if (state is RemoveFromFavStatesSuccess) {
                FlashHelper.successBar(context,
                    message: translator.currentLanguage == 'en'
                        ? "Done"
                        : "تم المسح بنجاح");
                Get.back();
                getAllFavAdsBloc.add(GetAllFavAdsEventsStart());
              } else if (state is RemoveFromFavStatesFailed) {
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
    FlashHelper.init(context);
    return Scaffold(
      appBar: appBar(
        context: context,
        leading: true,
        title: translator.currentLanguage == "en"
            ? "Favourite ads"
            : "الاعلانات المفضلة",
      ),
      body: BlocBuilder(
          bloc: getAllFavAdsBloc,
          builder: (context, state) {
            if (state is GetAllFavAdsStatesStart) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinKitThreeBounce(
                  color: AppTheme.primaryColor,
                  size: 30,
                ),
              );
            } else if (state is GetAllFavAdsStatesSuccess) {
              return state.allFavAdverts.isEmpty
                  ? Center(
                      child: Text(translator.currentLanguage == "en"
                          ? "Empty"
                          : "لايوجد"),
                    )
                  : ListView.builder(
                      itemCount: state.allFavAdverts.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          actions: [
                            IconSlideAction(
                              caption: translator.currentLanguage == 'en'
                                  ? 'Remove'
                                  : "حذف",
                              color: AppTheme.primaryColor,
                              icon: Icons.delete,
                              onTap: () => opendeleteConfirmationDialog(
                              context: context,
                                  advertId: state.allFavAdverts[index].id,
                                  index: index),
                            ),
                          ],
                          child: productCard(
                              context: context,
                              
                              onTap: () {},

                              isMine: false,
                              name: state.allFavAdverts[index].name,
                              organizationName: state.allFavAdverts[index].organizationName,
                              img: AppTheme.defaultImage,
                              address: state.allFavAdverts[index].address ?? "",
                              brandName:
                                  state.allFavAdverts[index].adOwner.name ?? "",
                              price: state.allFavAdverts[index].price ?? "",
                              currency: state.allFavAdverts[index].currency.name ?? "",
                              description:
                                  state.allFavAdverts[index].desc ?? "",
                              onToggleTapped: () {
                                setState(() {
                                  isFav = !isFav;
                                });
                              },
                              isFav: state.allFavAdverts[index].isFavourite),
                        );
                      },
                    );
            } else if (state is GetAllFavAdsStatesFailed) {
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
          }),
    );
  }

  bool isFav = true;
}
