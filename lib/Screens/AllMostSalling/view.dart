import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/AllMostRequired/AllBuyingAdverts/states.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/bloc.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/events.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/states.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/bloc.dart';
import 'package:orghub/Screens/ProductDetails/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class AllMostSaleView extends StatefulWidget {
  @override
  _AllMostSaleViewState createState() => _AllMostSaleViewState();
}

class _AllMostSaleViewState extends State<AllMostSaleView> {
  bool isFav = true;

  GetAllSellingAdvertsBloc getAllSellingAdvertsBloc =
      kiwi.KiwiContainer().resolve<GetAllSellingAdvertsBloc>();

  @override
  void initState() {
    getAllSellingAdvertsBloc.add(GetAllSellingAdvertsEventsStart(pageNum: pageNumber));
    super.initState();
  }

  @override
  void dispose() {
    getAllSellingAdvertsBloc.close();
    super.dispose();
  }

  int pageNumber = 1;

  final ScrollController _scrollController = ScrollController();

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      getAllSellingAdvertsBloc
          .add(GetAllSellingAdvertsEventsStart(pageNum: ++pageNumber));
    }
    return false;
  }

  int calculateListItemCount(GetAllSellingAdvertsStatesCompleted state) {
    if (state.hasReachedEndOfResults || state.hasReachedPageMax) {
      return state.adverts.length;
    } else {
      // + 1 for the loading indicator
      return state.adverts.length + 1;
    }
  }

  Widget _showLoader() {
    return Center(
      child: CupertinoActivityIndicator(
        animating: true,
        radius: 12,
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
              ? "Most Sell"
              : "الأكثر مبيعا"),
      body: BlocBuilder(
          bloc: getAllSellingAdvertsBloc,
          builder: (context, state) {
            if (state is GetAllSellingAdvertsStatesStart) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinKitThreeBounce(
                  color: AppTheme.primaryColor,
                  size: 30,
                ),
              );
            } else if (state is GetAllSellingAdvertsStatesCompleted) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: state.adverts.isEmpty
                    ? Center(
                        child: Text(translator.currentLanguage == "en"
                            ? "Empty"
                            : "لايوجد"))
                    : NotificationListener<ScrollNotification>(
                        onNotification: _handleScrollNotification,
                        
                        child: ListView.builder(
                          itemCount: calculateListItemCount(state),
                          shrinkWrap: true,
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return index >= state.adverts.length
                                ? _showLoader()
                                : productCard(
                                    context: context,
                                    onTap: () {
                                      Get.to(
                                        MultiBlocProvider(
                                          providers: [
                                            BlocProvider<RateAdvertBloc>(
                                              create: (BuildContext context) =>
                                                  RateAdvertBloc(),
                                            ),
                                            BlocProvider<AddAdvertToFavBloc>(
                                              create: (BuildContext context) =>
                                                  AddAdvertToFavBloc(),
                                            ),
                                          ],
                                          child: ProductDetailsView(
                                            advertId: state.adverts[index].id,
                                            adType: state.adverts[index].adType,
                                            myAdvert: false,
                                          ),
                                        ),
                                      );
                                    },
                                    name: state.adverts[index].name,
                                    organizationName: state.adverts[index].organizationName,
                                    img: state.adverts[index].image,
                                    address: "",
                                    brandName:
                                        state.adverts[index].adOwner.name,
                                    isMine: false,
                                    price: state.adverts[index].price,
                                    currency: state.adverts[index].currency.name??"",
                                    description: state.adverts[index].desc,
                                    onToggleTapped: () {},
                                    isFav: state.adverts[index].isFavourite);
                          },
                        ),
                      ),
              );
            } else if (state is GetAllSellingAdvertsStatesNoData) {
              return Center(
                child: Text(
                    translator.currentLanguage == 'en' ? "Empty" : "لا يوجد"),
              );
            } else if (state is GetAllSellingAdvertsStatesFailed) {
              if (state.errType == 0) {
                // FlashHelper.errorBar(context,
                //     message: translator.currentLanguage == 'en'
                //         ? "Please check your network connection."
                //         : "برجاء التاكد من الاتصال بالانترنت ");
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
    );
  }
}
