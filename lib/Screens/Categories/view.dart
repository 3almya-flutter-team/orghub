import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllSubCategories/bloc.dart';
import 'package:orghub/ComonServices/AllSubCategories/events.dart';
import 'package:orghub/ComonServices/AllSubCategories/states.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Categories/GetAdsInCategory/bloc.dart';
import 'package:orghub/Screens/Categories/GetAdsInCategory/events.dart';
import 'package:orghub/Screens/Categories/GetAdsInCategory/states.dart';
import 'package:orghub/Screens/Categories/Widgets/subCat_widget.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/bloc.dart';
import 'package:orghub/Screens/ProductDetails/view.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';

class CategoriesView extends StatefulWidget {
  final int catId;
  final String catName;
  const CategoriesView({Key key, this.catId, this.catName}) : super(key: key);
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  bool isFav = true;

  GetCategoryAdsBloc getCategoryAdsBloc =
      kiwi.KiwiContainer().resolve<GetCategoryAdsBloc>();
  GetAllSubCategoriesBloc getAllSubCategoriesBloc =
      kiwi.KiwiContainer().resolve<GetAllSubCategoriesBloc>();
  @override
  void initState() {
    super.initState();
    getCategoryAdsBloc
        .add(GetCategoryAdsEventsStart(catId: widget.catId, adType: "sell"));
    getAllSubCategoriesBloc.add(
      GetAllSubCategoriesEventStart(catId: widget.catId),
    );
    _controller = new TabController(vsync: DrawerControllerState(), length: 2);
    _controller.index = 0;
    _controller.addListener(() {
      if (_controller.index == 0) {
        getCategoryAdsBloc.add(
            GetCategoryAdsEventsStart(catId: widget.catId, adType: "sell"));
      } else {
        getCategoryAdsBloc
            .add(GetCategoryAdsEventsStart(catId: widget.catId, adType: "buy"));
      }
    });
  }

  @override
  void dispose() {
    getCategoryAdsBloc.close();
    getAllSubCategoriesBloc.close();
    super.dispose();
  }

  Widget _buildTaps() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.white,
              child: TabBar(
                labelPadding: EdgeInsets.only(right: 3, left: 3),
                isScrollable: false,
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                unselectedLabelColor: Color(getColorHexFromStr("#acacac")),
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
                onTap: (index) {
                  if (index == 0) {
                    getCategoryAdsBloc.add(GetCategoryAdsEventsStart(
                        catId: widget.catId, adType: "sell"));
                  } else {
                    getCategoryAdsBloc.add(GetCategoryAdsEventsStart(
                        catId: widget.catId, adType: "buy"));
                  }
                },
                tabs: [
                  Container(
                    height: 40,
                    child: Tab(
                      child: Text(
                        translator.currentLanguage == "en" ? "Sell" : "للبيع",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Tab(
                      child: Text(
                        translator.currentLanguage == "en" ? "Buy" : "للشراء",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _body() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppTheme.thirdColor,
        child: TabBarView(controller: _controller, children: <Widget>[
          // ***********   current ****************

          BlocBuilder(
              bloc: getCategoryAdsBloc,
              builder: (context, state) {
                if (state is GetCategoryAdsStatesStart) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitThreeBounce(
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  );
                } else if (state is GetCategoryAdsStatesSuccess) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: state.adverts.isEmpty
                        ? Center(
                            child: Text(translator.currentLanguage == "en"
                                ? "Empty"
                                : "لايوجد"))
                        : ListView.builder(
                            itemCount: state.adverts.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return productCard(
                                  context: context,
                                  organizationName: state.adverts[index].organizationName,
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
                                  img: state.adverts[index].image,
                                  address: "",
                                  brandName: state.adverts[index].adOwner.name,
                                  isMine: false,
                                  price: state.adverts[index].price,
                                  currency: state.adverts[index].currency.name??"",
                                  description: state.adverts[index].desc,
                                  onToggleTapped: () {},
                                  isFav: state.adverts[index].isFavourite);
                            },
                          ),
                  );
                } else if (state is GetCategoryAdsStatesFailed) {
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

          // ***********   current ****************

          BlocBuilder(
              bloc: getCategoryAdsBloc,
              builder: (context, state) {
                if (state is GetCategoryAdsStatesStart) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitThreeBounce(
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  );
                } else if (state is GetCategoryAdsStatesSuccess) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: state.adverts.isEmpty
                        ? Center(
                            child: Text(translator.currentLanguage == "en"
                                ? "Empty"
                                : "لايوجد"))
                        : ListView.builder(
                            itemCount: state.adverts.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return productCard(
                                  context: context,
                                  organizationName: state.adverts[index].organizationName,
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
                                  img: state.adverts[index].image,
                                  address: "",
                                  brandName: state.adverts[index].adOwner.name,
                                  isMine: false,
                                  price: state.adverts[index].price,
                                  currency: state.adverts[index].currency.name??"",
                                  description: state.adverts[index].desc,
                                  onToggleTapped: () {},
                                  isFav: state.adverts[index].isFavourite);
                            },
                          ),
                  );
                } else if (state is GetCategoryAdsStatesFailed) {
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
        ]));
  }

  TabController _controller;

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Scaffold(
      appBar:
          appBar(context: context, leading: true, title: widget.catName ?? ""),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            BlocBuilder(
              bloc: getAllSubCategoriesBloc,
              builder: (context, state) {
                if (state is GetAllSubCategoriesStateStart) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitThreeBounce(
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  );
                } else if (state is GetAllSubCategoriesStateSucess) {
                  return state.allSubCategories.isEmpty
                      ? Container()
                      : Container(
                          color: Colors.white,
                          height: 40,
                          // padding: EdgeInsets.all(9),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: state.allSubCategories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  print("here");
                                  // Get.to(CategoriesView(
                                  //   catId: state.allSubCategories[index].id,
                                  //   catName: state.allSubCategories[index].name,
                                  // ));

                                  Navigator.of(context).push(
                                    PageRouteBuilder(pageBuilder: (_, __, ___) {
                                      return CategoriesView(
                                        catId: state.allSubCategories[index].id,
                                        catName:
                                            state.allSubCategories[index].name,
                                      );
                                    }),
                                  );
                                },
                                child: SubCatWidget(
                                  image: state.allSubCategories[index].image,
                                  name: state.allSubCategories[index].name,
                                ),
                              );
                            },
                          ),
                        );
                } else if (state is GetAllSubCategoriesStateFaild) {
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
              },
            ),
            _buildTaps(),
            Expanded(
              child: _body(),
            ),
          ],
        ),
      ),
    );
  }
}
