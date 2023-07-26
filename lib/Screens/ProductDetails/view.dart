import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/bloc.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/events.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/states.dart';
import 'package:orghub/ComonServices/CityService/bloc.dart';
import 'package:orghub/ComonServices/CityService/events.dart';
import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/ComonServices/CountryService/bloc.dart';
import 'package:orghub/ComonServices/CountryService/events.dart';
import 'package:orghub/ComonServices/CountryService/states.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Helpers/txt.dart';
import 'package:orghub/Screens/AllComments/view.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/bloc.dart';
import 'package:orghub/Screens/Chat/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:orghub/Screens/MyComments/card.dart';
import 'package:orghub/Screens/OfferDetail/view.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/events.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/states.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/events.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/states.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/events.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/states.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/bloc.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/bloc.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/events.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/states.dart';
import 'package:orghub/Screens/ProductDetails/Report/view.dart';
import 'package:orghub/Screens/ProductDetails/SendOffer/bloc.dart';
import 'package:orghub/Screens/ProductDetails/SendOffer/events.dart';
import 'package:orghub/Screens/ProductDetails/SendOffer/states.dart';
import 'package:orghub/Screens/ProductDetails/bloc.dart';
import 'package:orghub/Screens/ProductDetails/events.dart';
import 'package:orghub/Screens/ProductDetails/states.dart';
import 'package:orghub/Screens/ProductDetails/widgets/CompanyCard.dart';
import 'package:orghub/Screens/ProductDetails/widgets/RateCard.dart';
import 'package:orghub/Screens/ProductDetails/widgets/card.dart';
import 'package:orghub/Screens/ProductOrder/bloc.dart';
import 'package:orghub/Screens/ProductOrder/view.dart';
import 'package:orghub/Screens/Profile/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:orghub/Utils/FormBuilder/flutter_form_builder.dart';
import 'package:share/share.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsView extends StatefulWidget {
  final int advertId;
  final String adType;
  final bool myAdvert;

  const ProductDetailsView({Key key, this.advertId, this.adType, this.myAdvert})
      : super(key: key);
  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  bool isFav = true;

  GetSingleAdvertDataBloc getSingleAdvertDataBloc =
      kiwi.KiwiContainer().resolve<GetSingleAdvertDataBloc>();

  GetAddOffersBloc getAddOffersBloc =
      kiwi.KiwiContainer().resolve<GetAddOffersBloc>();

  GetSomeAdvertReviewsBloc getSomeAdvertReviewsBloc =
      kiwi.KiwiContainer().resolve<GetSomeAdvertReviewsBloc>();

  GetRelatedAdvertsBloc getRelatedAdvertsBloc =
      kiwi.KiwiContainer().resolve<GetRelatedAdvertsBloc>();

  AddAdvertToFavBloc addAdvertToFavBloc =
      kiwi.KiwiContainer().resolve<AddAdvertToFavBloc>();
  DeleteAdvertBloc deleteAdvertBloc =
      kiwi.KiwiContainer().resolve<DeleteAdvertBloc>();

  GetAllCurrenciesBloc getAllCurrenciesBloc =
      kiwi.KiwiContainer().resolve<GetAllCurrenciesBloc>();
  SendOfferBloc sendOfferBloc = kiwi.KiwiContainer().resolve<SendOfferBloc>();
  GetAllCountries getAllCountries =
      kiwi.KiwiContainer().resolve<GetAllCountries>();
  GetAllCitiesBloc getAllCitiesBloc =
      kiwi.KiwiContainer().resolve<GetAllCitiesBloc>();

  @override
  void initState() {
    // GET ADVERT DETAILS
    getSingleAdvertDataBloc
        .add(GetSingleAdvertEventsStart(advertId: widget.advertId));

    // GET SOME ADVERT REVIEWS
    getSomeAdvertReviewsBloc
        .add(GetSomeAddReviewEventsSatart(advertId: widget.advertId));

    // GET SOME ADVERT REVIEWS
    getRelatedAdvertsBloc
        .add(GetRelatedAdvertsEventsStart(advertId: widget.advertId));
    getAddOffersBloc.add(GetAddOffersEventsSatart(advertId: widget.advertId));

    getAllCurrenciesBloc.add(GetAllCurrenciesEventStart());

    getAllCountries.add(GetAllCountriesEventStart());

    super.initState();
  }

  @override
  void dispose() {
    getSingleAdvertDataBloc.close();
    getAddOffersBloc.close();
    deleteAdvertBloc.close();
    getSomeAdvertReviewsBloc.close();
    getRelatedAdvertsBloc.close();
    addAdvertToFavBloc.close();
    getAllCurrenciesBloc.close();
    sendOfferBloc.close();
    getAllCountries.close();
    super.dispose();
  }

  double rate;
  TextEditingController rateController = TextEditingController();

  void _setAdvertRate({BuildContext context}) {
    if (rate != null) {
      BlocProvider.of<RateAdvertBloc>(context).add(
        RateAdvertEvevntsStart(
          advertId: widget.advertId,
          rate: rate,
          review: rateController.text,
        ),
      );
    } else {
      FlashHelper.errorBar(context,
          message: translator.currentLanguage == "en"
              ? "Please rate advert first"
              : "من فضلك قم بتقييم المنتج اولا");
    }
  }

  void _handleError({BuildContext context, RateAdvertStatesFailed state}) {
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

  _sendOffer() {
    if (!_fbkeys.currentState.validate()) {
      return;
    } else {
      _fbkeys.currentState.save();
      Map<String, dynamic> offerData = _fbkeys.currentState.value;
      offerData.putIfAbsent(
        "ad_id",
        () => widget.advertId,
      );
      sendOfferBloc.add(
        SendOfferEventsStart(
          offerData: offerData,
        ),
      );
    }
  }

  _handleSendOfferError({BuildContext context, SendOfferStatesFailed state}) {
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
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  int _selectedCountryId;
  GlobalKey<FormBuilderState> _fbkeys = GlobalKey<FormBuilderState>();
  void _openMakeOfferBottomSheet({BuildContext context}) {
    showCupertinoModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context, scrollController) {
          return Material(
            child: StatefulBuilder(builder: (context, StateSetter rebuild) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        FormBuilder(
                          key: _fbkeys,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  translator.currentLanguage == "en"
                                      ? "Offer Price"
                                      : "عرض السعر",
                                  style: TextStyle(
                                    fontFamily: "NeoSans",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              //----------------------
                              // SELECT PRODUCT COUNTRY
                              //----------------------

                              BlocBuilder(
                                  bloc: getAllCountries,
                                  builder: (context, state) {
                                    if (state is GetAllCountriesStateStart) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SpinKitThreeBounce(
                                          color: AppTheme.primaryColor,
                                          size: 30,
                                        ),
                                      );
                                    } else if (state
                                        is GetAllCountriesStateSucess) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FormBuilderDropdown(
                                          attribute: "country_id",
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8),
                                            enabled: state.allCountriesModel
                                                    .data.isEmpty
                                                ? false
                                                : true,
                                            labelText:
                                                translator.currentLanguage ==
                                                        "en"
                                                    ? "Country"
                                                    : "الدوله",
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: AppTheme.fontName,
                                            ),
                                          ),
                                          // initialValue: 'بيع',
                                          hint: Text(
                                            translator.currentLanguage == "en"
                                                ? "Select Country"
                                                : 'اختر الدوله',
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                          onChanged: (val) {
                                            print(val);
                                            rebuild(() {
                                              _selectedCountryId = val;
                                            });

                                            getAllCitiesBloc.add(
                                              GetAllCitiesEventStart(
                                                countryId: val,
                                              ),
                                            );
                                          },
                                          validators: [
                                            FormBuilderValidators.required()
                                          ],
                                          items: state.allCountriesModel.data
                                              .map(
                                                (country) => DropdownMenuItem(
                                                  value: country.id,
                                                  child: Text(
                                                    "${country.name}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(
                                                          getColorHexFromStr(
                                                              "#949494")),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    } else if (state
                                        is GetAllCountriesStateFaild) {
                                      if (state.errType == 0) {
                                        FlashHelper.errorBar(context,
                                            message: translator
                                                        .currentLanguage ==
                                                    'en'
                                                ? "Please check your network connection."
                                                : "برجاء التاكد من الاتصال بالانترنت ");
                                        return noInternetWidget(context);
                                      } else {
                                        FlashHelper.errorBar(context,
                                            message: state.msg ?? "");
                                        return Container();
                                      }
                                    } else {
                                      FlashHelper.errorBar(context,
                                          message: state.msg ?? "");
                                      return Container();
                                    }
                                  }),

                              //----------------------
                              // END SELECT PRODUCT COUNTRY
                              //----------------------

                              //----------------------
                              // SELECT PRODUCT CITY
                              //----------------------

                              _selectedCountryId == null
                                  ? Container()
                                  : BlocBuilder(
                                      bloc: getAllCitiesBloc,
                                      builder: (context, state) {
                                        if (state is GetAllCitesStateStart) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SpinKitThreeBounce(
                                              color: AppTheme.primaryColor,
                                              size: 30,
                                            ),
                                          );
                                        } else if (state
                                            is GetAllCitesStateSucess) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FormBuilderDropdown(
                                              attribute: "city_id",
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                enabled: state.allCitiesModel
                                                        .data.isEmpty
                                                    ? false
                                                    : true,
                                                labelText: translator
                                                            .currentLanguage ==
                                                        "en"
                                                    ? "City"
                                                    : "المدينه",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontFamily: AppTheme.fontName,
                                                ),
                                              ),
                                              // initialValue: 'بيع',
                                              hint: Text(
                                                translator.currentLanguage ==
                                                        "en"
                                                    ? "Select City"
                                                    : 'اختر المدينه',
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontSize: 12,
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          "#949494")),
                                                ),
                                              ),

                                              validators: [
                                                FormBuilderValidators.required()
                                              ],
                                              items: state.allCitiesModel.data
                                                  .map(
                                                    (city) => DropdownMenuItem(
                                                      value: city.id,
                                                      child: Text(
                                                        "${city.name}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              getColorHexFromStr(
                                                                  "#949494")),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          );
                                        } else if (state
                                            is GetAllCitesStateFaild) {
                                          if (state.errType == 0) {
                                            FlashHelper.errorBar(context,
                                                message: translator
                                                            .currentLanguage ==
                                                        'en'
                                                    ? "Please check your network connection."
                                                    : "برجاء التاكد من الاتصال بالانترنت ");
                                            return noInternetWidget(context);
                                          } else {
                                            FlashHelper.errorBar(context,
                                                message: "");
                                            return Container();
                                          }
                                        } else {
                                          FlashHelper.errorBar(context,
                                              message: "");
                                          return Container();
                                        }
                                      }),

                              //----------------------
                              // END SELECT PRODUCT City
                              //----------------------

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderTextField(
                                  attribute: "address",
                                  decoration: InputDecoration(
                                    labelText:
                                        translator.currentLanguage == "en"
                                            ? "Address"
                                            : "العنوان",
                                    hintText: translator.currentLanguage == "en"
                                        ? "Address in detail"
                                        : "العنوان بالتفصيل",
                                    hintStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  validators: [],
                                ),
                              ),

                              //----------------------
                              // SELECT PRODUCT Currency
                              //----------------------

                              BlocBuilder(
                                  bloc: getAllCurrenciesBloc,
                                  builder: (context, state) {
                                    if (state is GetAllCurrenciesStateStart) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SpinKitThreeBounce(
                                          color: AppTheme.primaryColor,
                                          size: 30,
                                        ),
                                      );
                                    } else if (state
                                        is GetAllCurrenciesStateSucess) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FormBuilderDropdown(
                                          attribute: "currency_id",
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(
                                                getColorHexFromStr("#FAFAFA")),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                              borderSide: BorderSide(
                                                color: Colors.grey[100],
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                color: Colors.grey[100],
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(8),
                                            // labelText: "العمله",
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: AppTheme.fontName,
                                            ),
                                          ),
                                          // initialValue: 'بيع',
                                          hint: Text(
                                            translator.currentLanguage == "en"
                                                ? "Select currency"
                                                : 'اختر العمله',
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                          validators: [
                                            FormBuilderValidators.required()
                                          ],
                                          items: state.allCurrenciesModel.data
                                              .map(
                                                (currency) => DropdownMenuItem(
                                                  value: currency.id,
                                                  child: Text(
                                                    "${currency.name}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(
                                                        getColorHexFromStr(
                                                            "#949494"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    } else if (state
                                        is GetAllCurrenciesStateFaild) {
                                      if (state.errType == 0) {
                                        FlashHelper.errorBar(context,
                                            message: translator
                                                        .currentLanguage ==
                                                    'en'
                                                ? "Please check your network connection."
                                                : "برجاء التاكد من الاتصال بالانترنت ");
                                        return noInternetWidget(context);
                                      } else {
                                        // FlashHelper.errorBar(context, message: "");
                                        return Container();
                                      }
                                    } else {
                                      // FlashHelper.errorBar(context, message: "");
                                      return Container();
                                    }
                                  }),

                              //----------------------
                              // END SELECT PRODUCT Currency
                              //----------------------

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderTextField(
                                  attribute: "offer_price",
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Color(getColorHexFromStr("#FAFAFA")),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(8),
                                    hintStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                    hintText: translator.currentLanguage == 'en'
                                        ? "Price"
                                        : "السعر",
                                  ),
                                  validators: [],
                                ),
                              ),

                              BlocConsumer(
                                bloc: sendOfferBloc,
                                builder: (context, state) {
                                  if (state is SendOfferStatesStart) {
                                    return SpinKitFadingCircle(
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    );
                                  } else {
                                    return btn(
                                      context,
                                      translator.currentLanguage == "en"
                                          ? "Send"
                                          : "ارسال",
                                      () {
                                        _sendOffer();
                                      },
                                    );
                                  }
                                },
                                listener: (context, state) {
                                  if (state is SendOfferStatesSuccess) {
                                    FlashHelper.successBar(context,
                                        message:
                                            translator.currentLanguage == "en"
                                                ? "Done"
                                                : "تم ارسال عرضك بنجاح");
                                    Navigator.of(context).pop();
                                  } else if (state is SendOfferStatesFailed) {
                                    _handleSendOfferError(
                                        context: context, state: state);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  void openReportBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context, scrollController) {
        return ReportView(
          advertId: widget.advertId,
        );
      },
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
    FlashHelper.init(context);
    return Scaffold(
      backgroundColor: Color(getColorHexFromStr("#F5F8FA")),
      appBar: appBar(
        context: context,
        leading: true,
        title: translator.currentLanguage == "en"
            ? "Product details"
            : "تفاصيل المنتج",
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              BlocBuilder(
                  bloc: getSingleAdvertDataBloc,
                  builder: (context, state) {
                    if (state is GetSingleAdvertStatesStart) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SpinKitThreeBounce(
                          color: AppTheme.primaryColor,
                          size: 30,
                        ),
                      );
                    } else if (state is GetSingleAdvertStatesSuccess) {
                      return state.advertData.images == null
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.only(
                                top: 30,
                              ),
                              child: Image.asset(
                                "assets/icons/logox.png",
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                            ))
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: Swiper(
                                itemBuilder: (context, int index) {
                                  return Image(
                                    image: NetworkImage(state
                                            .advertData.images.isEmpty
                                        ? AppTheme.defaultImage
                                        : state.advertData.images[index].img),
                                    fit: BoxFit.contain,
                                  );
                                },
                                itemCount: state.advertData.images.length,
                                pagination: new SwiperPagination(),
                                autoplay: true,
                                outer: false,
                              ),
                            );
                    } else if (state is GetSingleAdvertStatesFailed) {
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
              Padding(
                padding: const EdgeInsets.only(top: 260),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      BlocBuilder(
                          bloc: getSingleAdvertDataBloc,
                          builder: (context, state) {
                            if (state is GetSingleAdvertStatesStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state is GetSingleAdvertStatesSuccess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: productDetailsCard(
                                    addAdvertToFavBloc: addAdvertToFavBloc,
                                    deleteAdvertBloc: deleteAdvertBloc,
                                    context: context,
                                    countryId: state.advertData.country == null
                                        ? null
                                        : state.advertData.country.id,
                                    myAdvert: widget.myAdvert,
                                    onShareTapped: () {
                                      Share.share("link");
                                    },
                                    onFavTapped: () {
                                      setState(() {
                                        isFav = !isFav;
                                      });
                                    },
                                    advertId: widget.advertId,
                                    isFav: state.advertData.isFavourite,
                                    onReportTapped: () {
                                      openReportBottomSheet(context);
                                    },
                                    type: state.advertData.adType ?? "",
                                    description: state.advertData.desc ?? "",
                                    date: Jiffy(state.advertData.createdAt)
                                        .yMMMMd
                                        .toString(),
                                    rate: state.advertData.totalRate == null ||
                                            state.advertData.totalRate == ""
                                        ? 0.0
                                        : state.advertData.totalRate,
                                    productName: state.advertData.name ?? "",
                                    productId: state.advertData.id.toString(),
                                    brand: state.advertData.mark.name ?? "",
                                    address: state.advertData.address ?? "",
                                    category:
                                        state.advertData.category.name ?? "",
                                    quantity: state.advertData.stock.toString(),
                                    specifications:
                                        state.advertData.specification.name ??
                                            "",
                                    currency:
                                        state.advertData.currency.name ?? "",
                                    classifications:
                                        state.advertData.classification.name ??
                                            "",
                                    tags: state.advertData.tags,
                                    price: state.advertData.price ??
                                        "", // ad type is buy
                                    viewers: state.advertData.adViewsCount),
                              );
                            } else if (state is GetSingleAdvertStatesFailed) {
                              if (state.errType == 0) {
                                FlashHelper.errorBar(context,
                                    message: translator.currentLanguage == 'en'
                                        ? "Please check your network connection."
                                        : "برجاء التاكد من الاتصال بالانترنت ");
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
                      widget.myAdvert
                          ? Container()
                          : widget.adType == "sell"
                              ? Hero(
                                  tag: "ordre20",
                                  child: btn(
                                    context,
                                    translator.currentLanguage == "en"
                                        ? "Product request"
                                        : "طلب منتج",
                                    () {
                                      Get.to(BlocProvider(
                                          create: (_) => MakeNewOrderBloc(),
                                          child: ProductOrderScreen(
                                            advertId: widget.advertId,
                                          )));
                                    },
                                  ),
                                )
                              : Material(
                                  child: btn(
                                    context,
                                    translator.currentLanguage == "en"
                                        ? "Offer price"
                                        : "عرض سعر",
                                    () {
                                      _openMakeOfferBottomSheet(
                                          context: context);
                                    },
                                  ),
                                ),
                      widget.myAdvert
                          ? Container()
                          : BlocBuilder(
                              bloc: getSingleAdvertDataBloc,
                              builder: (context, state) {
                                if (state is GetSingleAdvertStatesStart) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SpinKitThreeBounce(
                                      color: AppTheme.primaryColor,
                                      size: 30,
                                    ),
                                  );
                                } else if (state
                                    is GetSingleAdvertStatesSuccess) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: companyCard(
                                        context: context,
                                        onTap: () {
                                          Get.to(ProfileScreen(
                                            userId: state.advertData.adOwner.id,
                                            address: "",
                                            name:
                                                state.advertData.adOwner.name ??
                                                    "",
                                            phone: state
                                                    .advertData.adOwner.phone ??
                                                "",
                                            whatsApp: state.advertData.adOwner
                                                    .whatsapp ??
                                                "",
                                            time: "",
                                            cover:
                                                state.advertData.adOwner.cover,
                                            image:
                                                state.advertData.adOwner.image,
                                          ));
                                        },
                                        img: state.advertData.adOwner.image,
                                        name:
                                            state.advertData.adOwner.name ?? "",
                                        onChatTapped: () {
                                          Get.to(
                                            BlocProvider(
                                              create: (_) => SendMessageBloc(),
                                              child: ChatScreen(
                                                receiverId:
                                                    state.advertData.adOwner.id,
                                                receiverName: state.advertData
                                                        .adOwner.name ??
                                                    "",
                                              ),
                                            ),
                                          );
                                        },
                                        onCallTapped: () {
                                          launch(
                                              ('tel://${state.advertData.adOwner.phone}'));
                                        },
                                        onWhatsAppTap: () {
                                          launchWhatsApp(
                                              message: "",
                                              phone: state
                                                  .advertData.adOwner.whatsapp);
                                        }),
                                  );
                                } else if (state
                                    is GetSingleAdvertStatesFailed) {
                                  if (state.errType == 0) {
                                    FlashHelper.errorBar(context,
                                        message: translator.currentLanguage ==
                                                'en'
                                            ? "Please check your network connection."
                                            : "برجاء التاكد من الاتصال بالانترنت ");
                                    return noInternetWidget(context);
                                  } else {
                                    // FlashHelper.errorBar(context,
                                    //     message: state.msg ?? "");
                                    return errorWidget(context, state.msg ?? "",
                                        state.statusCode);
                                  }
                                } else {
                                  // FlashHelper.errorBar(context,
                                  //     message: state.msg ?? "");
                                  return Container();
                                }
                              }),
                      widget.myAdvert
                          ? Container()
                          : BlocConsumer<RateAdvertBloc, RateAdvertStates>(
                              builder: (context, state) {
                                if (state is RateAdvertStatesStart) {
                                  return addRateCard(
                                      context: context,
                                      isLoading: true,
                                      withShadow: true,
                                      controller: rateController,
                                      onAddCommentTapped: () => null,
                                      onRatingUpdate: (rate) => null);
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: addRateCard(
                                        context: context,
                                        isLoading: false,
                                        withShadow: true,
                                        controller: rateController,
                                        onAddCommentTapped: () {
                                          _setAdvertRate(context: context);
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
                                if (state is RateAdvertStatesSuccess) {
                                  rateController.text = "";

                                  // GET SOME ADVERT REVIEWS
                                  getSomeAdvertReviewsBloc.add(
                                      GetSomeAddReviewEventsSatart(
                                          advertId: widget.advertId));

                                  FlashHelper.successBar(context,
                                      message:
                                          translator.currentLanguage == "en"
                                              ? "Done"
                                              : "تم تقييم المنتج بنجاح");
                                } else if (state is RateAdvertStatesFailed) {
                                  _handleError(context: context, state: state);
                                }
                              },
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                          child: BlocBuilder(
                              bloc: getSomeAdvertReviewsBloc,
                              builder: (context, state) {
                                if (state is GetSomeAddReviewStatesStart) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SpinKitThreeBounce(
                                      color: AppTheme.primaryColor,
                                      size: 30,
                                    ),
                                  );
                                } else if (state
                                    is GetSomeAddReviewStatesSuccess) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: titleText(
                                          translator.currentLanguage == "en"
                                              ? "Comments & evaluations"
                                              : "التعليقات والتقيمات",
                                        ),
                                      ),
                                      state.addReviews.isEmpty ||
                                              state.addReviews == null
                                          ? Center(
                                              child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  translator.currentLanguage ==
                                                          "en"
                                                      ? "No Comments"
                                                      : "لايوجد تعليقات"),
                                            ))
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  state.addReviews.length,
                                              scrollDirection: Axis.vertical,
                                              primary: false,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return myCommentsCard(
                                                    context: context,
                                                    name: state
                                                        .addReviews[index]
                                                        .fullname,
                                                    date: "11/22/3333",
                                                    stars: state
                                                                    .addReviews[
                                                                        index]
                                                                    .rate ==
                                                                null ||
                                                            state
                                                                    .addReviews[
                                                                        index]
                                                                    .rate ==
                                                                ""
                                                        ? 0.0
                                                        : state
                                                            .addReviews[index]
                                                            .rate,
                                                    comment: state
                                                            .addReviews[index]
                                                            .review ??
                                                        "",
                                                    img: state.addReviews[index]
                                                            .image ??
                                                        AppTheme.defaultImage);
                                              },
                                            ),
                                      state.addReviews.isEmpty ||
                                              state.addReviews == null
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                Get.to(AllAdsCommentsView(
                                                  advertId: widget.advertId,
                                                ));
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 35,
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          "#F8F8F8")),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    translator.currentLanguage ==
                                                            "en"
                                                        ? "Show More"
                                                        : "اظهار المزيد",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  );
                                } else if (state
                                    is GetSomeAddReviewStatesFailed) {
                                  if (state.errType == 0) {
                                    FlashHelper.errorBar(context,
                                        message: translator.currentLanguage ==
                                                'en'
                                            ? "Please check your network connection."
                                            : "برجاء التاكد من الاتصال بالانترنت ");
                                    return noInternetWidget(context);
                                  } else {
                                    // FlashHelper.errorBar(context,
                                    //     message: state.msg ?? "");
                                    return Container();
                                  }
                                } else {
                                  // FlashHelper.errorBar(context,
                                  //     message: state.msg ?? "");
                                  return Container();
                                }
                              }),
                        ),
                      ),
                      widget.myAdvert
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      translator.currentLanguage == "en"
                                          ? "Similar Products"
                                          : "منتجات مشابهه",
                                      style: TextStyle(
                                        fontFamily: AppTheme.boldFont,
                                      ),
                                    ),
                                  ),
                                  BlocBuilder(
                                      bloc: getRelatedAdvertsBloc,
                                      builder: (context, state) {
                                        if (state
                                            is GetRelatedAdvertsStatesStart) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SpinKitThreeBounce(
                                              color: AppTheme.primaryColor,
                                              size: 30,
                                            ),
                                          );
                                        } else if (state
                                            is GetRelatedAdvertsStatesSuccess) {
                                          return state.adverts.isEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(translator
                                                                .currentLanguage ==
                                                            "en"
                                                        ? "Empty"
                                                        : "لا يوجد"),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      state.adverts.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  primary: false,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return productCard(
                                                        context: context,
                                                        organizationName: state
                                                                .adverts[index]
                                                                .organizationName ??
                                                            "",
                                                        onTap: () {
                                                          print("=-=-=");
                                                          Navigator.of(context).push(
                                                              PageRouteBuilder(
                                                                  pageBuilder:
                                                                      (_, __,
                                                                          ___) {
                                                            return MultiBlocProvider(
                                                              providers: [
                                                                BlocProvider<
                                                                    RateAdvertBloc>(
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
                                                              child:
                                                                  ProductDetailsView(
                                                                advertId: state
                                                                    .adverts[
                                                                        index]
                                                                    .id,
                                                                adType: state
                                                                    .adverts[
                                                                        index]
                                                                    .adType,
                                                                myAdvert: false,
                                                              ),
                                                            );
                                                          }));
                                                        },
                                                        name: state
                                                            .adverts[index]
                                                            .name,
                                                        img: state
                                                                .adverts[index]
                                                                .image ??
                                                            "https://cdn.pixabay.com/photo/2015/01/21/14/14/imac-606765_1280.jpg",
                                                        address:
                                                            "${state.adverts[index].country.name ?? ""},${state.adverts[index].city.name ?? ""}",
                                                        brandName: state
                                                            .adverts[index]
                                                            .adOwner
                                                            .name,
                                                        isMine: false,
                                                        price: state
                                                                .adverts[index]
                                                                .price ??
                                                            "",
                                                        currency: state
                                                                .adverts[index]
                                                                .currency
                                                                .name ??
                                                            "",
                                                        description: state
                                                            .adverts[index]
                                                            .desc,
                                                        onToggleTapped: () {
                                                          // setState(() {
                                                          //   isFav = !isFav;
                                                          // });
                                                        },
                                                        isFav: state
                                                            .adverts[index]
                                                            .isFavourite);
                                                  },
                                                );
                                        } else if (state
                                            is GetRelatedAdvertsStatesFailed) {
                                          if (state.errType == 0) {
                                            FlashHelper.errorBar(context,
                                                message: translator
                                                            .currentLanguage ==
                                                        'en'
                                                    ? "Please check your network connection."
                                                    : "برجاء التاكد من الاتصال بالانترنت ");
                                            return noInternetWidget(context);
                                          } else {
                                            // FlashHelper.errorBar(context,
                                            //     message: state.msg ?? "");
                                            return Container();
                                          }
                                        } else {
                                          // FlashHelper.errorBar(context,
                                          //     message: state.msg ?? "");
                                          return Container();
                                        }
                                      }),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      !widget.myAdvert
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      translator.currentLanguage == "en"
                                          ? "Offers in this product"
                                          : "العروض على المنتج",
                                      style: TextStyle(
                                        fontFamily: AppTheme.boldFont,
                                      ),
                                    ),
                                  ),
                                  BlocBuilder(
                                      bloc: getAddOffersBloc,
                                      builder: (context, state) {
                                        if (state is GetAddOffersStatesStart) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SpinKitThreeBounce(
                                              color: AppTheme.primaryColor,
                                              size: 30,
                                            ),
                                          );
                                        } else if (state
                                            is GetAddOffersStatesSuccess) {
                                          return state.offers.isEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(translator
                                                                .currentLanguage ==
                                                            "en"
                                                        ? "Empty"
                                                        : "لا يوجد"),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      state.offers.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  primary: false,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Get.to(OfferDetailView(
                                                          offerId: state
                                                              .offers[index].id,
                                                          from: "product",
                                                        ));
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        margin:
                                                            EdgeInsets.all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .2),
                                                              blurRadius:
                                                                  10.0, // soften the shadow
                                                              spreadRadius:
                                                                  0.0, //extend the shadow
                                                              offset: Offset(
                                                                2.0, // Move to right 10  horizontally
                                                                2.0, // Move to bottom 10 Vertically
                                                              ),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12)),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  translator.currentLanguage ==
                                                                          "en"
                                                                      ? "Product Name :"
                                                                      : "اسم المنتج:",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(state
                                                                    .offers[
                                                                        index]
                                                                    .ad
                                                                    .name),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  translator.currentLanguage ==
                                                                          "en"
                                                                      ? "Offer Price :"
                                                                      : "المبلغ المعروض :",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(state
                                                                    .offers[
                                                                        index]
                                                                    .offerPrice),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  translator.currentLanguage ==
                                                                          "en"
                                                                      ? "Status :"
                                                                      : "الحاله:",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(state
                                                                    .offers[
                                                                        index]
                                                                    .transOfferStatus),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                        } else if (state
                                            is GetAddOffersStatesFailed) {
                                          if (state.errType == 0) {
                                            // FlashHelper.errorBar(context,
                                            //     message: translator
                                            //                 .currentLanguage ==
                                            //             'en'
                                            //         ? "Please check your network connection."
                                            //         : "برجاء التاكد من الاتصال بالانترنت ");
                                            return noInternetWidget(context);
                                          } else {
                                            // FlashHelper.errorBar(context,
                                            //     message: state.msg ?? "");
                                            return errorWidget(
                                                context,
                                                state.msg ?? "",
                                                state.statusCode);
                                          }
                                        } else {
                                          // FlashHelper.errorBar(context,
                                          //     message: state.msg ?? "");
                                          return Container();
                                        }
                                      }),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
