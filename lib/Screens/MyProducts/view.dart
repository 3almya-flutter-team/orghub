import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/MyProducts/bloc.dart';
import 'package:orghub/Screens/MyProducts/events.dart';
import 'package:orghub/Screens/MyProducts/states.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/bloc.dart';
import 'package:orghub/Screens/ProductDetails/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class MyProductsView extends StatefulWidget {
  @override
  _MyProductsViewState createState() => _MyProductsViewState();
}

class _MyProductsViewState extends State<MyProductsView> {
  GetMyProductsBloc getMyProductsBloc =
      kiwi.KiwiContainer().resolve<GetMyProductsBloc>();

  @override
  void initState() {
    getMyProductsBloc.add(GetMyProductsEventsStart(pageNum: pageNumber));
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  int pageNumber = 1;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      getMyProductsBloc.add(GetNextMyProductsEvent(pageNum: ++pageNumber));
    }
    return false;
  }

  int calculateListItemCount(GetMyProductsStatesCompleted state) {
    if (state.hasReachedEndOfResults || state.hasReachedPageMax) {
      return state.myProducts.length;
    } else {
      // + 1 for the loading indicator
      return state.myProducts.length + 1;
    }
  }

  @override
  void dispose() {
    getMyProductsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Scaffold(
      appBar: appBar(
        context: context,
        leading: true,
        title: translator.currentLanguage == "en" ? "My products" : "منتجاتى",
      ),
      body: BlocBuilder(
          bloc: getMyProductsBloc,
          builder: (context, state) {
            if (state is GetMyProductsStatesStart) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinKitThreeBounce(
                  color: AppTheme.primaryColor,
                  size: 30,
                ),
              );
            } else if (state is GetMyProductsStatesCompleted) {
              return state.myProducts.isEmpty
                  ? Center(
                      child: Text(translator.currentLanguage == "en"
                          ? "Empty"
                          : "لايوجد"),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: _handleScrollNotification,
                      child: ListView.builder(
                        itemCount: calculateListItemCount(state),
                        shrinkWrap: true,
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: productCard(
                                context: context,
                                organizationName: state.myProducts[index].organizationName,
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
                                        advertId: state.myProducts[index].id,
                                        adType: state.myProducts[index].adType,
                                        myAdvert: true,
                                      ),
                                    ),
                                  );
                                },
                                isMine: true,
                                name: state.myProducts[index].name,
                                img: state.myProducts[index].image,
                                address:
                                    "${state.myProducts[index].country.name}, ${state.myProducts[index].city.name}",
                                brandName: state.myProducts[index].adOwner.name,
                                price: state.myProducts[index].price,
                                currency: state.myProducts[index].currency.name??"",
                                description: state.myProducts[index].desc,
                                onToggleTapped: () {
                                  // setState(() {
                                  //   isFav = !isFav;
                                  // });
                                },
                                isFav: state.myProducts[index].isFavourite),
                          );
                        },
                      ),
                    );
            } else if (state is GetMyProductsStatesFailed) {
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
