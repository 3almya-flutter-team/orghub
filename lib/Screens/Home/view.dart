// import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Screens/AllMostRequired/view.dart';
import 'package:orghub/Screens/AllMostSalling/view.dart';
import 'package:orghub/Screens/Categories/view.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:orghub/Screens/Home/AllCategories/bloc.dart';
import 'package:orghub/Screens/Home/AllCategories/events.dart';
import 'package:orghub/Screens/Home/AllCategories/states.dart';
import 'package:orghub/Screens/Home/AllSliders/bloc.dart';
import 'package:orghub/Screens/Home/AllSliders/events.dart';
import 'package:orghub/Screens/Home/AllSliders/states.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/bloc.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/events.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/states.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/bloc.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/events.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/states.dart';
import 'package:orghub/Screens/Home/widgets/ShowAll.dart';
import 'package:orghub/Screens/Home/widgets/main_category_widget.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/bloc.dart';
import 'package:orghub/Screens/ProductDetails/view.dart';

import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/SearchPage/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // ignore: close_sinks
  GetAllSlidersBloc getAllSlidersBloc =
      kiwi.KiwiContainer().resolve<GetAllSlidersBloc>();
  // ignore: close_sinks
  GetAllCategoriesBloc getAllCategoriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCategoriesBloc>();
  // ignore: close_sinks
  GetMostBuyingAdvertsBloc getMostBuyingAdvertsBloc =
      kiwi.KiwiContainer().resolve<GetMostBuyingAdvertsBloc>();
  // ignore: close_sinks
  GetMostSellingAdvertsBloc getMostSellingAdvertsBloc =
      kiwi.KiwiContainer().resolve<GetMostSellingAdvertsBloc>();

  @override
  void initState() {
    super.initState();

    // SharedPreferences.getInstance().then((token) {
    //   IO.Socket socket =
    //     IO.io('https://org.taha.rmal.com.sa:6010', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    //   // 'extraHeaders': {
    //   'auth': {
    //     'headers': {'Authorization': 'Bearer $token'}
    //   },
    //   // } // optional
    // });
    // socket.on('connection', (_) {
    //   print('connect');
    //   socket.emit('chat message', 'test');
    // });
    // socket.on('event', (data) => print(data));
    // socket.on('disconnect', (_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));
    // });

    // get all sliders
    getAllSlidersBloc.add(GetAllSlidersEventStart());

    // get all categories
    getAllCategoriesBloc.add(GetAllCategoriesEventStart());

    // get most buying advers
    getMostBuyingAdvertsBloc.add(GetMostBuyingAdvertsEventsStart());

    // get most selling adverts
    getMostSellingAdvertsBloc.add(GetMostSellingAdvertsEventsStart());
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isFav = true;

  // void showFilterDialog({@required BuildContext context}) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return FilterDialogWidget();
  //     },
  //   );
  // }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection: translator.currentLanguage == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
          backgroundColor: AppTheme.backGroundColor,
          body: ListView(
            primary: true,
            shrinkWrap: true,
            children: <Widget>[
              clientHomeAppBar(
                context: context,
                onFilterTapped: () {
                  Get.to(SearchScreen(type: "filter"));
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BlocBuilder(
                      bloc: getAllSlidersBloc,
                      builder: (context, state) {
                        if (state is GetAllSlidersStateStart) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SpinKitThreeBounce(
                              color: AppTheme.primaryColor,
                              size: 30,
                            ),
                          );
                        } else if (state is GetAllSlidersStateSucess) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 4,
                            child: Swiper(
                              autoplay: true,
                              autoplayDelay: 7000,
                              onTap: (int index) {
                                print("hello world");
                                if (state.allSliders[index].ad != null) {
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
                                        advertId:
                                            state.allSliders[index].ad.adId,
                                        adType:
                                            state.allSliders[index].ad.adType,
                                        myAdvert: false,
                                      ),
                                    ),
                                  ).then((value) {
                                    // get most selling adverts
                                    getMostSellingAdvertsBloc.add(
                                        GetMostSellingAdvertsEventsStart());
                                  });
                                } else if (state.allSliders[index].link !=
                                        null &&
                                    state.allSliders[index].link != '') {
                                  _launchURL(state.allSliders[index].link);
                                }
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return new Image.network(
                                  state.allSliders[index].image ??
                                      "http://via.placeholder.com/350x150",
                                  fit: BoxFit.fill,
                                );
                              },
                              itemCount: state.allSliders.length,
                              // pagination: new SwiperPagination(),
                              // control: new SwiperControl(),
                            ),
                          );
                        } else if (state is GetAllSlidersStateFaild) {
                          if (state.errType == 0) {
                            // FlashHelper.errorBar(context,
                            //     message: translator.currentLanguage == 'en'
                            //         ? "Please check your network connection."
                            //         : "برجاء التاكد من الاتصال بالانترنت ");
                            return noInternetWidget(context);
                          } else {
                            // FlashHelper.errorBar(context,
                            //     message: state.msg ?? "");
                            return errorWidget(
                                context, state.msg ?? "", state.statusCode);
                          }
                        } else {
                          // FlashHelper.errorBar(context,
                          //     message: state.msg ?? "");
                          return Container();
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 12, left: 12, bottom: 5),
                    child: Text(
                      translator.currentLanguage == "en"
                          ? "Categories"
                          : "الأقسام",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontFamily: AppTheme.boldFont,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  BlocBuilder(
                    bloc: getAllCategoriesBloc,
                    builder: (context, state) {
                      if (state is GetAllCategoriesStateStart) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SpinKitThreeBounce(
                            color: AppTheme.primaryColor,
                            size: 30,
                          ),
                        );
                      } else if (state is GetAllCategoriesStateSucess) {
                        return SizedBox(
                          height: 130,
                          child: state.allCategories.isEmpty
                              ? Center(
                                  child: Text(translator.currentLanguage == 'en'
                                      ? "There is no categories"
                                      : "لا يوجد اقسام"))
                              : ListView.builder(
                                  itemCount: state.allCategories.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, index) {
                                    return mainCatWidget(
                                        context: context,
                                        onTap: () {
                                          Get.to(CategoriesView(
                                            catId:
                                                state.allCategories[index].id,
                                            catName:
                                                state.allCategories[index].name,
                                          ));
                                        },
                                        img: state.allCategories[index].image,
                                        name: state.allCategories[index].name);
                                  }),
                        );
                      } else if (state is GetAllCategoriesStateFaild) {
                        if (state.errType == 0) {
                          // FlashHelper.errorBar(context,
                          //     message: translator.currentLanguage == 'en'
                          //         ? "Please check your network connection."
                          //         : "برجاء التاكد من الاتصال بالانترنت ");
                          return noInternetWidget(context);
                        } else {
                          // FlashHelper.errorBar(context,
                          //     message: state.msg ?? "");
                          return errorWidget(
                              context, state.msg ?? "", state.statusCode);
                        }
                      } else {
                        // FlashHelper.errorBar(context, message: state.msg ?? "");
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  showAllText(
                      context: context,
                      title: translator.currentLanguage == "ar"
                          ? "الأكثر مبيعا"
                          : "Most Sell",
                      onShowAllTapped: () {
                        Get.to(AllMostSaleView());
                      }),
                  BlocBuilder(
                    bloc: getMostSellingAdvertsBloc,
                    builder: (context, state) {
                      if (state is GetMostSellingAdvertsStatesStart) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SpinKitThreeBounce(
                            color: AppTheme.primaryColor,
                            size: 30,
                          ),
                        );
                      } else if (state is GetMostSellingAdvertsStatesSuccess) {
                        return state.adverts.isEmpty
                            ? Center(
                                child: Text(translator.currentLanguage == 'en'
                                    ? "Empty"
                                    : "لا يوجد"))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.adverts.length,
                                scrollDirection: Axis.vertical,
                                primary: false,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8, top: 8),
                                    child: productCard(
                                        context: context,
                                        organizationName: state
                                            .adverts[index].organizationName,
                                        onTap: () {
                                          Get.to(
                                            MultiBlocProvider(
                                              providers: [
                                                BlocProvider<RateAdvertBloc>(
                                                  create:
                                                      (BuildContext context) =>
                                                          RateAdvertBloc(),
                                                ),
                                                BlocProvider<
                                                    AddAdvertToFavBloc>(
                                                  create:
                                                      (BuildContext context) =>
                                                          AddAdvertToFavBloc(),
                                                ),
                                              ],
                                              child: ProductDetailsView(
                                                advertId:
                                                    state.adverts[index].id,
                                                adType:
                                                    state.adverts[index].adType,
                                                myAdvert: false,
                                              ),
                                            ),
                                          ).then((value) {
                                            // get most selling adverts
                                            getMostSellingAdvertsBloc.add(
                                                GetMostSellingAdvertsEventsStart());
                                          });
                                        },
                                        name: state.adverts[index].name ?? "",
                                        img: state.adverts[index].image ??
                                            "https://cdn.pixabay.com/photo/2015/01/21/14/14/imac-606765_1280.jpg",
                                        address:
                                            "${state.adverts[index].country.name ?? ""},${state.adverts[index].city.name ?? ""}" ??
                                                "",
                                        brandName:
                                            state.adverts[index].adOwner.name ??
                                                "",
                                        isMine: false,
                                        price: state.adverts[index].price ?? "",
                                        currency: state
                                                .adverts[index].currency.name ??
                                            "",
                                        description:
                                            state.adverts[index].desc ?? "",
                                        onToggleTapped: () {
                                          setState(() {
                                            isFav = !isFav;
                                          });
                                        },
                                        isFav:
                                            state.adverts[index].isFavourite),
                                  );
                                },
                              );
                      } else if (state is GetMostSellingAdvertsStatesFailed) {
                        if (state.errType == 0) {
                          // FlashHelper.errorBar(context,
                          //     message: translator.currentLanguage == 'en'
                          //         ? "Please check your network connection."
                          //         : "برجاء التاكد من الاتصال بالانترنت ");
                          return noInternetWidget(context);
                        } else {
                          // FlashHelper.errorBar(context,
                          //     message: state.msg ?? "");
                          return errorWidget(
                              context, state.msg ?? "", state.statusCode);
                        }
                      } else {
                        // FlashHelper.errorBar(context, message: state.msg ?? "");
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  showAllText(
                      context: context,
                      title: translator.currentLanguage == "ar"
                          ? "الأكثر طلبا"
                          : "Most required",
                      onShowAllTapped: () {
                        Get.to(AllMostRequiredView());
                      }),
                  BlocBuilder(
                    bloc: getMostBuyingAdvertsBloc,
                    builder: (context, state) {
                      if (state is GetMostBuyingAdvertsStatesStart) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SpinKitThreeBounce(
                            color: AppTheme.primaryColor,
                            size: 30,
                          ),
                        );
                      } else if (state is GetMostBuyingAdvertsStatesSuccess) {
                        return state.adverts.isEmpty
                            ? Center(
                                child: Text(translator.currentLanguage == 'en'
                                    ? "Empty"
                                    : "لا يوجد"))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.adverts.length,
                                scrollDirection: Axis.vertical,
                                primary: false,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8, top: 8),
                                    child: productCard(
                                        context: context,
                                        organizationName: state
                                            .adverts[index].organizationName,
                                        onTap: () {
                                          Get.to(
                                            MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<RateAdvertBloc>(
                                                    create: (BuildContext
                                                            context) =>
                                                        RateAdvertBloc(),
                                                  ),
                                                  BlocProvider<
                                                      AddAdvertToFavBloc>(
                                                    create: (BuildContext
                                                            context) =>
                                                        AddAdvertToFavBloc(),
                                                  ),
                                                ],
                                                child: ProductDetailsView(
                                                  advertId:
                                                      state.adverts[index].id,
                                                  adType: state
                                                      .adverts[index].adType,
                                                  myAdvert: false,
                                                )),
                                          ).then((value) {
                                            // get most buying advers
                                            getMostBuyingAdvertsBloc.add(
                                                GetMostBuyingAdvertsEventsStart());
                                          });
                                        },
                                        name: state.adverts[index].name ?? "",
                                        img: state.adverts[index].image ??
                                            "https://cdn.pixabay.com/photo/2015/01/21/14/14/imac-606765_1280.jpg",
                                        address:
                                            "${state.adverts[index].country.name ?? ""},${state.adverts[index].city.name ?? ""}" ??
                                                "",
                                        brandName:
                                            state.adverts[index].adOwner.name ??
                                                "",
                                        isMine: false,
                                        price: state.adverts[index].price ?? "",
                                        currency: state
                                                .adverts[index].currency.name ??
                                            "",
                                        description:
                                            state.adverts[index].desc ?? "",
                                        onToggleTapped: () {
                                          // setState(() {
                                          //   isFav = !isFav;
                                          // });
                                        },
                                        isFav:
                                            state.adverts[index].isFavourite),
                                  );
                                },
                              );
                      } else if (state is GetMostBuyingAdvertsStatesFailed) {
                        if (state.errType == 0) {
                          // FlashHelper.errorBar(context,
                          //     message: translator.currentLanguage == 'en'
                          //         ? "Please check your network connection."
                          //         : "برجاء التاكد من الاتصال بالانترنت ");
                          return noInternetWidget(context);
                        } else {
                          // FlashHelper.errorBar(context,
                          //     message: state.msg ?? "");
                          return  errorWidget(context, state.msg ??"",state.statusCode);
                        }
                      } else {
                        // FlashHelper.errorBar(context, message: state.msg ?? "");
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              )
            ],
          )),
    );
  }

  Future openFilterBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        builder: (BuildContext context) {
          return Directionality(
            textDirection: translator.currentLanguage == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Container(
                height: 360,
                decoration: BoxDecoration(
                  color: AppTheme.backGroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: StatefulBuilder(builder: (context, StateSetter rebuild) {
                  return Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              Text(
                                translator.currentLanguage == "en"
                                    ? "Filter"
                                    : "فلتر",
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: AppTheme.secondaryColor,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text("svf")
                        ],
                      ),
                    ],
                  );
                })),
          );
        });
  }
}
