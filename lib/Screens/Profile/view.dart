import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/bloc.dart';
import 'package:orghub/Screens/Chat/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:orghub/Screens/MyComments/card.dart';
import 'package:orghub/Screens/OtherProfileComments/view.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/bloc.dart';
import 'package:orghub/Screens/ProductDetails/view.dart';
import 'package:orghub/Screens/ProductDetails/widgets/RateCard.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/Profile/AddRate/bloc.dart';
import 'package:orghub/Screens/Profile/AddRate/events.dart';
import 'package:orghub/Screens/Profile/OtherComments/bloc.dart';
import 'package:orghub/Screens/Profile/OtherComments/events.dart';
import 'package:orghub/Screens/Profile/OtherComments/states.dart';
import 'package:orghub/Screens/Profile/OtherProducts/bloc.dart';
import 'package:orghub/Screens/Profile/OtherProducts/events.dart';
import 'package:orghub/Screens/Profile/OtherProducts/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/floating_modal.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AddRate/states.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final int userId;
  final String address;
  final String time;
  final String phone;
  final String image;
  final String cover;
  final String whatsApp;
  ProfileScreen({
    Key key,
    @required this.name,
    @required this.address,
    @required this.time,
    @required this.phone,
    @required this.whatsApp,
    @required this.image,
    @required this.cover,
    this.userId,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TabController _controller;
  TextEditingController rateController = TextEditingController();
  RateUserBloc rateUserBloc = kiwi.KiwiContainer().resolve<RateUserBloc>();
  GetUserCommentsBloc getUserCommentsBloc =
      kiwi.KiwiContainer().resolve<GetUserCommentsBloc>();
  GetUserProductsBloc getUserProductsBloc =
      kiwi.KiwiContainer().resolve<GetUserProductsBloc>();

  double rate;
  @override
  void initState() {
    super.initState();
    // getUserCommentsBloc.add(
    //   GetUserCommentsEventsStart(
    //     userId: widget.userId,
    //   ),
    // );
    getUserProductsBloc.add(GetUserProductsEventsStart(userId: widget.userId));
    _controller = new TabController(vsync: DrawerControllerState(), length: 2);
    _controller.index = 0;
    _controller.addListener(() {
      if (_controller.index == 0) {
      } else {}
    });
  }

  @override
  void dispose() {
    rateUserBloc.close();
    getUserCommentsBloc.close();
    getUserProductsBloc.close();
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
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TabBar(
                labelPadding: EdgeInsets.only(right: 3, left: 3),
                controller: _controller,
                unselectedLabelColor: Color(getColorHexFromStr("#acacac")),
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
                onTap: (index) {
                  if (index == 0) {
                    getUserProductsBloc
                        .add(GetUserProductsEventsStart(userId: widget.userId));
                  } else {
                    getUserCommentsBloc.add(
                      GetUserCommentsEventsStart(
                        userId: widget.userId,
                      ),
                    );
                  }
                },
                tabs: [
                  Container(
                    height: 40,
                    child: Tab(
                      child: Text(
                        translator.currentLanguage == "en"
                            ? "Ads"
                            : "الاعلانات",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Tab(
                      child: Text(
                        translator.currentLanguage == "en"
                            ? "Comments"
                            : "التقييمات",
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

  void _handleError({BuildContext context, RateUserStatesFailed state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      FlashHelper.errorBar(context, message: state.msg ?? "");
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  void openRatingDialog({BuildContext context}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.black,
        context: context,
        isScrollControlled: true,
        builder: (context) => _SystemPadding(
              child: Container(
                // padding: MediaQuery.of(context).viewInsets,
                height: MediaQuery.of(context).size.height / 2,
                // padding:
                // EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                width: double.infinity,
                color: Colors.white,
                child: BlocConsumer(
                  bloc: rateUserBloc,
                  builder: (context, state) {
                    if (state is RateUserStatesStart) {
                      return addRateCard(
                          context: context,
                          withShadow: false,
                          isLoading: true,
                          controller: rateController,
                          onAddCommentTapped: () => null,
                          onRatingUpdate: (rate) => null);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        // padding: MediaQuery.of(context).viewInsets,
                        child: addRateCard(
                            context: context,
                            withShadow: false,
                            isLoading: false,
                            controller: rateController,
                            onAddCommentTapped: () {
                              rateUserBloc.add(
                                RateUserEvevntsStart(
                                    userId: widget.userId,
                                    rate: rate,
                                    review: rateController.text),
                              );
                            },
                            onRatingUpdate: (newRate) {
                              setState(() {
                                rate = newRate;
                              });
                            }),
                      );
                    }
                  },
                  listener: (context, state) {
                    if (state is RateUserStatesSuccess) {
                      rateController.text = "";
                      FlashHelper.successBar(context,
                          message: translator.currentLanguage == "en"
                              ? "Done"
                              : "تم تقييم المنتج بنجاح");
                      getUserCommentsBloc.add(
                        GetUserCommentsEventsStart(
                          userId: widget.userId,
                        ),
                      );
                      Get.back();
                    } else if (state is RateUserStatesFailed) {
                      _handleError(context: context, state: state);
                    }
                  },
                ),
              ),
            ));
  }
  // void openRatingDialog({BuildContext context}) {
  //   showFloatingModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.white,
  //       builder: (context, scrollController) {
  //         return SingleChildScrollView(
  //           controller: scrollController,
  //           child: Container(
  //             padding: MediaQuery.of(context).viewInsets,
  //             height: 250,
  //             color: Colors.white,
  //             child: BlocConsumer(
  //               bloc: rateUserBloc,
  //               builder: (context, state) {
  //                 if (state is RateUserStatesStart) {
  //                   return addRateCard(
  //                       context: context,
  //                       withShadow: false,
  //                       isLoading: true,
  //                       controller: rateController,
  //                       onAddCommentTapped: () => null,
  //                       onRatingUpdate: (rate) => null);
  //                 } else {
  //                   return Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     // padding: MediaQuery.of(context).viewInsets,
  //                     child: addRateCard(
  //                         context: context,
  //                         withShadow: false,
  //                         isLoading: false,
  //                         controller: rateController,
  //                         onAddCommentTapped: () {
  //                           rateUserBloc.add(
  //                             RateUserEvevntsStart(
  //                                 userId: widget.userId,
  //                                 rate: rate,
  //                                 review: rateController.text),
  //                           );
  //                         },
  //                         onRatingUpdate: (newRate) {
  //                           setState(() {
  //                             rate = newRate;
  //                           });
  //                         }),
  //                   );
  //                 }
  //               },
  //               listener: (context, state) {
  //                 if (state is RateUserStatesSuccess) {
  //                   rateController.text = "";
  //                   FlashHelper.successBar(context,
  //                       message: translator.currentLanguage == "en"
  //                           ? "Done"
  //                           : "تم تقييم المنتج بنجاح");
  //                   getUserCommentsBloc.add(
  //                     GetUserCommentsEventsStart(
  //                       userId: widget.userId,
  //                     ),
  //                   );
  //                   Get.back();
  //                 } else if (state is RateUserStatesFailed) {
  //                   _handleError(context: context, state: state);
  //                 }
  //               },
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget _body() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // color: AppTheme.thirdColor,
      color: Colors.white,
      child: TabBarView(
        controller: _controller,
        children: <Widget>[
          // ***********   current ****************

          BlocBuilder(
              bloc: getUserProductsBloc,
              builder: (context, state) {
                if (state is GetUserProductsStatesStart) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitThreeBounce(
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  );
                } else if (state is GetUserProductsStatesSuccess) {
                  return state.userAdsModel.data.isEmpty
                      ? Center(
                          child: Text(translator.currentLanguage == "en"
                              ? "Empty"
                              : "لايوجد"))
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: SafeArea(
                            child: ListView.builder(
                              primary: false,
                              itemCount: state.userAdsModel.data.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return productCard(
                                    context: context,
                                    organizationName: state.userAdsModel.data[index].organizationName,
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
                                            advertId: state
                                                .userAdsModel.data[index].id,
                                            adType: state.userAdsModel
                                                .data[index].adType,
                                            myAdvert: false,
                                          ),
                                        ),
                                      );
                                    },
                                    isMine: true,
                                    name: state.userAdsModel.data[index].name,
                                    img: state.userAdsModel.data[index].image,
                                    address:
                                        state.userAdsModel.data[index].address,
                                    brandName: state
                                        .userAdsModel.data[index].adOwner.name,
                                    price:
                                        state.userAdsModel.data[index].price ??
                                            "",
                                    currency:
                                        state.userAdsModel.data[index].currency.name ??
                                            "",
                                    description:
                                        state.userAdsModel.data[index].desc,
                                    onToggleTapped: () {},
                                    isFav: state
                                        .userAdsModel.data[index].isFavourite);
                              },
                            ),
                          ),
                        );
                } else if (state is GetUserProductsStatesFailed) {
                  if (state.errType == 0) {
                    FlashHelper.errorBar(context,
                        message: translator.currentLanguage == 'en'
                            ? "Please check your network connection."
                            : "برجاء التاكد من الاتصال بالانترنت ");
                    return noInternetWidget(context);
                  } else {
                    // FlashHelper.errorBar(context, message: state.msg ?? "");
                    return Container();
                  }
                } else {
                  // FlashHelper.errorBar(context, message: state.msg ?? "");
                  return Container();
                }
              }),

          // ***********   current ****************
          BlocBuilder(
              bloc: getUserCommentsBloc,
              builder: (context, state) {
                if (state is GetUserCommentsStatesStart) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitThreeBounce(
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  );
                } else if (state is GetUserCommentsStatesSuccess) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: SafeArea(
                      child: Column(
                        children: [
                          state.userComments.isEmpty
                              ? Center(
                                  child: Text(translator.currentLanguage == "en"
                                      ? "Empty"
                                      : "لا يوجد"),
                                )
                              : ListView.builder(
                                  itemCount: state.userComments.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return myCommentsCard(
                                        context: context,
                                        name: state.userComments[index].name ??
                                            "",
                                        date: state
                                            .userComments[index].createdAt
                                            .toString(),
                                        stars: state.userComments[index].rate
                                                is double
                                            ? state.userComments[index].rate
                                            : double.parse(state
                                                .userComments[index].rate
                                                .toString()),
                                        comment:
                                            state.userComments[index].review ??
                                                "",
                                        img: state.userComments[index].image ??
                                            AppTheme.defaultImage);
                                  },
                                ),
                          InkWell(
                            onTap: () {
                              Get.to(AllCompanyCommentsView(
                                companyId: widget.userId,
                              ));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 35,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(getColorHexFromStr("#F8F8F8")),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  translator.currentLanguage == "en"
                                      ? "Show More"
                                      : "اظهار المزيد",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          btn(
                              context,
                              translator.currentLanguage == "en"
                                  ? "Rate"
                                  : "تقييم", () {
                            openRatingDialog(context: context);
                          }),
                        ],
                      ),
                    ),
                  );
                } else if (state is GetUserCommentsStatesFailed) {
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
        ],
      ),
    );
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        primary: true,
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 2,
            automaticallyImplyLeading: false,
            floating: false,
            pinned: false,
            backgroundColor: Colors.white,
            // title: new Text(
            //   "الصفحه الشخصيه",
            //   style: TextStyle(
            //     fontFamily: "Neosans",
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.cover ??
                                    "https://cdn.pixabay.com/photo/2016/12/19/21/36/winters-1919143__480.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          child: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 6,
                          left: 30,
                          right: 30,
                          child: Center(
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.image ??
                                        "https://cdn.pixabay.com/photo/2016/12/19/21/36/winters-1919143__480.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    widget.name ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppTheme.boldFont,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/icons/location-on.png",
                        width: 13,
                        height: 13,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.address ?? "",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontFamily: AppTheme.fontName,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.time ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppTheme.fontName,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            launchWhatsApp(message: "", phone: widget.whatsApp);
                          },
                          child: Image.asset(
                            "assets/icons/whats.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launch(('tel://${widget.phone}'));
                          },
                          child: Image.asset(
                            "assets/icons/phone.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(
                              BlocProvider(
                                create: (_) => SendMessageBloc(),
                                child: ChatScreen(
                                  receiverId: widget.userId,
                                  receiverName: widget.name,
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            "assets/icons/chat.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildTaps(),
              SafeArea(
                child: _body(),
              ),
              // SizedBox(height: 200,),
            ]),
          ),
          // SliverLayoutBuilder(
          //   builder: (context, x) {
          //     return _buildTaps();
          //   },
          // ),

          //             _body(),
          //     SliverFixedExtentList(
          //   itemExtent: 20,  // I'm forcing item heights
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) => ListTile(
          //           title: Text(
          //             generatedList[index],
          //             style: TextStyle(fontSize: 20.0),
          //           ),
          //         ),
          //     childCount: generatedList.length,
          //   ),
          // ),
        ],
      ),
      // body: CustomScrollView(
      //   primary: true,
      //   child: Column(
      //     children: <Widget>[
      //       Container(
      //         width: MediaQuery.of(context).size.width,
      //         height: MediaQuery.of(context).size.height / 4,
      //         child: Stack(
      //           overflow: Overflow.visible,
      //           children: <Widget>[
      //             Container(
      //               width: MediaQuery.of(context).size.width,
      //               height: MediaQuery.of(context).size.height / 4,
      //               decoration: BoxDecoration(
      //                 image: DecorationImage(
      //                   image: NetworkImage(
      //                     "https://cdn.pixabay.com/photo/2016/12/19/21/36/winters-1919143__480.jpg",
      //                   ),
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //             ),
      //             Container(
      //               height: MediaQuery.of(context).size.height / 4,
      //               child: AppBar(
      //                 elevation: 0,
      //                 backgroundColor: Colors.transparent,
      //               ),
      //             ),
      //             Positioned(
      //               top: MediaQuery.of(context).size.height / 6,
      //               left: 30,
      //               right: 30,
      //               child: Center(
      //                 child: Container(
      //                   width: 110,
      //                   height: 110,
      //                   decoration: BoxDecoration(
      //                     image: DecorationImage(
      //                       image: NetworkImage(
      //                         "https://cdn.pixabay.com/photo/2016/12/19/21/36/winters-1919143__480.jpg",
      //                       ),
      //                       fit: BoxFit.cover,
      //                     ),
      //                     borderRadius: BorderRadius.circular(6),
      //                     border: Border.all(
      //                       color: Colors.white,
      //                       width: 3,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       SingleChildScrollView(
      //         child: Column(
      //           children: <Widget>[
      //             SizedBox(
      //               height: 60,
      //             ),
      //             Text(
      //               "احمد على",
      //               style: TextStyle(
      //                 color: Colors.black,
      //                 fontFamily: AppTheme.boldFont,
      //               ),
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: <Widget>[
      //                 Image.asset(
      //                   "assets/icons/location-on.png",
      //                   width: 13,
      //                   height: 13,
      //                 ),
      //                 SizedBox(
      //                   width: 5,
      //                 ),
      //                 Text(
      //                   "مكه المكرمه المملكه العربيه السعوديه",
      //                   style: TextStyle(
      //                     color: AppTheme.primaryColor,
      //                     fontFamily: AppTheme.fontName,
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 5,
      //             ),
      //             Text(
      //               "انضم الينا منذ سنه",
      //               style: TextStyle(
      //                 color: Colors.black,
      //                 fontFamily: AppTheme.fontName,
      //                 fontSize: 13,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 5,
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 children: <Widget>[
      //                   SizedBox(
      //                     width: 10,
      //                   ),
      //                   Image.asset(
      //                     "assets/icons/whats.png",
      //                     width: 40,
      //                     height: 40,
      //                   ),
      //                   Image.asset(
      //                     "assets/icons/phone.png",
      //                     width: 40,
      //                     height: 40,
      //                   ),
      //                   Image.asset(
      //                     "assets/icons/chat.png",
      //                     width: 40,
      //                     height: 40,
      //                   ),
      //                   SizedBox(
      //                     width: 10,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             _buildTaps(),
      //             _body(),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
