import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/BottomNavigation/view.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/events.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/states.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/bloc.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/events.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/states.dart';
import 'package:orghub/Screens/ProductDetails/model.dart';
import 'package:orghub/Screens/UpdateProduct/bloc.dart';
import 'package:orghub/Screens/UpdateProduct/view.dart';

Widget productDetailsCard(
    {BuildContext context,
    Function onShareTapped,
    bool myAdvert,
    Function onFavTapped,
    Function onReportTapped,
    AddAdvertToFavBloc addAdvertToFavBloc,
    DeleteAdvertBloc deleteAdvertBloc,
    bool isFav,
    int advertId,
    int countryId,
    String address,
    String currency,
    String productName,
    String productId,
    String viewers,
    String brand,
    dynamic rate,
    String date,
    String quantity,
    String type,
    String specifications,
    String classifications,
    String description,
    String category,
    List<Tag> tags,
    String price}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.3),
          blurRadius: 10.0, // soften the shadow
          spreadRadius: 0.0, //extend the shadow
          offset: Offset(
            1.0, // Move to right 10  horizontally
            1.0, // Move to bottom 10 Vertically
          ),
        )
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      color: AppTheme.decorationColor,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#032435")),
                        fontSize: 16,
                        // fontFamily: AppTheme.boldFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: AppTheme.secondary2Color,
                      size: 10,
                    ),
                  ),
                  Text(
                    viewers,
                    style: TextStyle(
                      color: AppTheme.secondary2Color,
                      fontSize: 9,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              myAdvert
                  ? InkWell(
                      onTap: () {
                        Get.to(
                          BlocProvider(
                            create: (_) => UpdateAdvertBloc(),
                            child: UpdateProductScreen(
                              advertId: advertId,
                              countryId: countryId,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        "assets/icons/edit.png",
                        width: 30,
                        height: 30,
                      ),
                    )
                  : BlocConsumer(
                      bloc: addAdvertToFavBloc,
                      builder: (context, state) {
                        if (state is AddAdvertToFavStatesStart) {
                          return CupertinoActivityIndicator(
                            animating: true,
                            radius: 5,
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              // _setAdvertRate(context: context, id: advertId);
                              addAdvertToFavBloc.add(
                                AddAdvertToFavEvevntsStart(advertId: advertId),
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(getColorHexFromStr("#FAFAFA")),
                                border: Border.all(
                                  color: Colors.grey[100],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            // child: Image.asset(
                            //   "assets/icons/fav.png",
                            //   width: 30,
                            //   height: 30,
                            // ),
                          );
                        }
                        // else {
                        //   return Container(
                        //     width: 30,
                        //     height: 30,
                        //     decoration: BoxDecoration(
                        //       color: Color(getColorHexFromStr("#FAFAFA")),
                        //       border: Border.all(
                        //         color: Colors.grey[100],
                        //       ),
                        //       borderRadius: BorderRadius.circular(4),
                        //     ),
                        //     child: Center(
                        //       child: Icon(
                        //         isFav ? Icons.favorite : Icons.favorite_border,
                        //         color: AppTheme.primaryColor,
                        //       ),
                        //     ),
                        //   );
                        // }
                      },
                      listener: (context, state) {
                        if (state is AddAdvertToFavStatesSuccess) {
                          if (state.favAdvertData.isFavourite) {
                            isFav = true;
                            FlashHelper.successBar(context,
                                message: "تم اضافه المنتج فى المفضله بنجاح");
                          } else {
                            isFav = false;
                            FlashHelper.successBar(context,
                                message: "تم مسح المنتج فى المفضله بنجاح");
                          }
                        } else if (state is AddAdvertToFavStatesFailed) {
                          _handleError(context: context, state: state);
                        }
                      },
                    ),
              SizedBox(
                width: 6,
              ),
              myAdvert
                  ? BlocConsumer(
                      bloc: deleteAdvertBloc,
                      builder: (context, state) {
                        if (state is DeleteAdvertStatesStart) {
                          return CupertinoActivityIndicator(
                            animating: true,
                            radius: 5,
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              // _setAdvertRate(context: context, id: advertId);
                              deleteAdvertBloc.add(
                                DeleteAdvertEvevntsStart(advertId: advertId),
                              );
                            },
                            child: Image.asset(
                              "assets/icons/delete.png",
                              width: 30,
                              height: 30,
                            ),
                          );
                        }
                      },
                      listener: (context, state) {
                        if (state is DeleteAdvertStatesSuccess) {
                          Get.to(BottomNavigationView());
                        } else if (state is DeleteAdvertStatesFailed) {
                          _handleError(context: context, state: state);
                        }
                      },
                    )
                  : InkWell(
                      onTap: onShareTapped,
                      child: Image.asset(
                        "assets/icons/sharex.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
              SizedBox(
                width: 6,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              StarRating(
                size: 17.0,
                rating: rate is double ? rate : double.parse(rate.toString()),
                color: Color(
                  getColorHexFromStr("#FFD500"),
                ),
                starCount: 5,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                rate.toString(),
                style: TextStyle(
                  color: AppTheme.secondary2Color,
                  fontSize: 13,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(getColorHexFromStr("#032435")),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          _item(translator.currentLanguage == "en" ? "Ads id" : "رقم الاعلان",
              productId),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _item(translator.currentLanguage == "en" ? "Brand" : "الماركة",
                  brand),
              price == null
                  ? Container()
                  : Text(
                      "$price $currency",
                      style: TextStyle(
                          color: Color(getColorHexFromStr("#01C51B")),
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    )
            ],
          ),
          // _item(
          //     translator.currentLanguage == "en" ? "Brand" : "الماركة", brand),
          _item(translator.currentLanguage == "en" ? "Quantity" : "الكمية",
              quantity),
          _item(translator.currentLanguage == "en" ? "Type" : "النوع", type),
          _item(
              translator.currentLanguage == "en"
                  ? "Specifications"
                  : "المواصفات",
              specifications),
          _item(
              translator.currentLanguage == "en"
                  ? "Classifications"
                  : "التصنيفات",
              classifications),
          Container(
            margin: EdgeInsets.all(6),
            width: MediaQuery.of(context).size.width - 30,
            child: Text(
              description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppTheme.secondary2Color,
                fontSize: 12,
                // fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 45,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            decoration: AppTheme.containerDecoration,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Text(
                                  tags[index].name,
                                  style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              myAdvert
                  ? Container()
                  : InkWell(
                      onTap: onReportTapped,
                      child: Text(
                        translator.currentLanguage == "en"
                            ? "Report"
                            : "الابلاغ",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          // fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    ),
  );
}

// void _setAdvertRate({BuildContext context, int id}) {
//   addAdvertToFavBloc.add(
//     AddAdvertToFavEvevntsStart(advertId: id),
//   );
// }

void _handleError({BuildContext context, dynamic state}) {
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

Widget _item(String key, String val) {
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 6, left: 6),
        child: Text(
          key + " : ",
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 15,
            // fontWeight: FontWeight.w700,
          ),
        ),
      ),
      Text(
        val,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          // fontWeight: FontWeight.w600
        ),
      ),
    ],
  );
}
