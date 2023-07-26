import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/CityService/bloc.dart';
import 'package:orghub/ComonServices/CityService/events.dart';
import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/ComonServices/CountryService/bloc.dart';
import 'package:orghub/ComonServices/CountryService/events.dart';
import 'package:orghub/ComonServices/CountryService/states.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/BottomNavigation/view.dart';
import 'package:orghub/Screens/CustomWidgets/AppBar.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/ProductDetails/bloc.dart';
import 'package:orghub/Screens/ProductDetails/events.dart';
import 'package:orghub/Screens/ProductDetails/states.dart';
import 'package:orghub/Screens/ProductOrder/bloc.dart';
import 'package:orghub/Screens/ProductOrder/events.dart';
import 'package:orghub/Screens/ProductOrder/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:orghub/Utils/FormBuilder/src/fields/form_builder_dropdown.dart';
import 'package:orghub/Utils/FormBuilder/src/fields/form_builder_text_field.dart';
import 'package:orghub/Utils/FormBuilder/src/fields/form_builder_touch_spin.dart';
import 'package:orghub/Utils/FormBuilder/src/form_builder.dart';
import 'package:orghub/Utils/FormBuilder/src/form_builder_validators.dart';
import 'package:toast/toast.dart';

class ProductOrderScreen extends StatefulWidget {
  final int advertId;
  ProductOrderScreen({Key key, this.advertId}) : super(key: key);

  @override
  _ProductOrderScreenState createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  GetAllCountries getAllCountriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCountries>();

  GetAllCitiesBloc getAllCitiesBloc =
      kiwi.KiwiContainer().resolve<GetAllCitiesBloc>();

  GetSingleAdvertDataBloc getSingleAdvertDataBloc =
      kiwi.KiwiContainer().resolve<GetSingleAdvertDataBloc>();

  @override
  void initState() {
    getAllCountriesBloc.add(GetAllCountriesEventStart());
    getSingleAdvertDataBloc.add(
      GetSingleAdvertEventsStart(advertId: widget.advertId),
    );
    super.initState();
  }

  @override
  void dispose() {
    getAllCountriesBloc.close();
    getAllCitiesBloc.close();
    getSingleAdvertDataBloc.close();
    super.dispose();
  }

  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  void _submit({BuildContext context}) {
    if (!_fbKey.currentState.validate()) {
      return;
    } else {
      _fbKey.currentState.save();

      Map<String, dynamic> orderData = _fbKey.currentState.value;

      orderData.putIfAbsent("ad_id", () => widget.advertId);

      BlocProvider.of<MakeNewOrderBloc>(context).add(
        MakeNewOrderEventsStart(
          orderData: orderData,
        ),
      );
    }
  }

  void _handleError({BuildContext context, MakeNewOrderStatesFailed state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      FlashHelper.errorBar(context, message: state.msg ?? "");
      // }
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  int _selectedCountryId;

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection: translator.currentLanguage == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: appBar(
          leading: true,
          title: translator.currentLanguage == "en"
              ? "Order Details"
              : "تفاصيل الطلب",
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),

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
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                              3),
                                      child: Column(
                                        children: <Widget>[
                                          Image.network(
                                            state.advertData.image,
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4),
                                            height: 100,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            state.advertData.name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: AppTheme.boldFont,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                              2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          _item("الماركه",
                                              state.advertData.mark.name),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          _item(
                                              translator.currentLanguage == "en"
                                                  ? "Quantity"
                                                  : "عدد القطع",
                                              state.advertData.stock
                                                  .toString()),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          _item(
                                              translator.currentLanguage == "en"
                                                  ? "Type"
                                                  : "النوع",
                                              state.advertData.classification
                                                  .name),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          _item(
                                              translator.currentLanguage == "en"
                                                  ? "Classifications"
                                                  : "المواصفات",
                                              state.advertData.specification
                                                  .name),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 5,
                                  left: translator.currentLanguage == 'en' ? null: 10,
                                  right: translator.currentLanguage == 'en' ? 10: null,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5, left: 5),
                                        child: Text(
                                          translator.currentLanguage == "en"
                                              ? "Order Id :"
                                              : "رقم الطلب :",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            // fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        state.advertData.id.toString(),
                                        style: TextStyle(
                                          color: Color(
                                              getColorHexFromStr("#848584")),
                                          fontSize: 12,
                                          // fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: translator.currentLanguage == 'en' ? null: 10,
                                  right: translator.currentLanguage == 'en' ? 10: null,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5, left: 5),
                                        child: Text(
                                          translator.currentLanguage == "en"
                                              ? "Cost :"
                                              : "التكلفه :",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: AppTheme.boldFont,
                                            fontSize: 16,
                                            // fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "${state.advertData.price} ${state.advertData.currency.name ?? ""}",
                                            style: TextStyle(
                                              color: Color(getColorHexFromStr(
                                                  "#01C51B")),
                                              fontSize: 12,
                                              // fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }),

                  Divider(),
                  // Hero(
                  //   tag: "ordre20",
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Material(
                  //       child: TextField(
                  //         decoration: InputDecoration(
                  //           labelText: "عنوان التوصيل",
                  //           labelStyle: TextStyle(
                  //             fontFamily: AppTheme.boldFont,
                  //             color: Colors.black,
                  //             fontSize: 15,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                      attribute: "address",
                      decoration: InputDecoration(
                        labelText: translator.currentLanguage == "en"
                            ? "Address"
                            : "العنوان",
                        hintText: translator.currentLanguage == "en"
                            ? "Address in details"
                            : "العنوان بالتفصيل",
                        hintStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 12,
                          color: Color(getColorHexFromStr("#949494")),
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
                  // SELECT PRODUCT COUNTRY
                  //----------------------

                  BlocBuilder(
                      bloc: getAllCountriesBloc,
                      builder: (context, state) {
                        if (state is GetAllCountriesStateStart) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SpinKitThreeBounce(
                              color: AppTheme.primaryColor,
                              size: 30,
                            ),
                          );
                        } else if (state is GetAllCountriesStateSucess) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderDropdown(
                              attribute: "country_id",
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                enabled: state.allCountriesModel.data.isEmpty
                                    ? false
                                    : true,
                                labelText: translator.currentLanguage == "en"
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
                                  color: Color(getColorHexFromStr("#949494")),
                                ),
                              ),
                              onChanged: (val) {
                                print(val);
                                setState(() {
                                  _selectedCountryId = val;
                                });

                                getAllCitiesBloc.add(
                                  GetAllCitiesEventStart(
                                    countryId: val,
                                  ),
                                );
                              },
                              validators: [
                                FormBuilderValidators.required(
                                    errorText:
                                        translator.currentLanguage == "en"
                                            ? "Required"
                                            : "يجب اختيار الدوله")
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
                                              getColorHexFromStr("#949494")),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        } else if (state is GetAllCountriesStateFaild) {
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
                            } else if (state is GetAllCitesStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "city_id",
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    enabled: state.allCitiesModel.data.isEmpty
                                        ? false
                                        : true,
                                    labelText:
                                        translator.currentLanguage == "en"
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
                                    translator.currentLanguage == "en"
                                        ? "Select City"
                                        : 'اختر المدينه',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),

                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText:
                                            translator.currentLanguage == 'en'
                                                ? "Required"
                                                : "يجب اختيار المدينه"),
                                  ],
                                  items: state.allCitiesModel.data
                                      .map(
                                        (city) => DropdownMenuItem(
                                          value: city.id,
                                          child: Text(
                                            "${city.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state is GetAllCitesStateFaild) {
                              if (state.errType == 0) {
                                // FlashHelper.errorBar(context,
                                //     message: translator.currentLanguage == 'en'
                                //         ? "Please check your network connection."
                                //         : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context, message: "");
                                return errorWidget(context, state.msg ?? "",state.statusCode);
                              }
                            } else {
                              // FlashHelper/.errorBar(context, message: "");
                              return Container();
                            }
                          }),

                  //----------------------
                  // END SELECT PRODUCT City
                  //----------------------
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Text(translator.currentLanguage == "en"
                        ? "Quantity"
                        : "الكميه المطلوبه :"),
                  ),
                  FormBuilderTouchSpin(
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: AppTheme.fontName,
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 30, top: 10, bottom: 10, right: 30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(
                        getColorHexFromStr("#F8FAFC"),
                      ),
                      enabled: true,
                      // labelText: "الكميه المطلوبه",
                      labelStyle: TextStyle(
                        color: Color(
                          getColorHexFromStr("#A8BBCC"),
                        ),
                        fontWeight: FontWeight.w800,
                        backgroundColor: Color(
                          getColorHexFromStr("#F1F4F9"),
                        ),
                        fontSize: 12,
                      ),
                    ),
                    attribute: "qty",
                    validators: [
                      FormBuilderValidators.required(
                        errorText: translator.currentLanguage == "en"
                            ? "required"
                            : "مطلوب",
                      ),
                      // FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(
                        1,
                        errorText: translator.currentLanguage == "en"
                            ? "Value must be more than or equal 1"
                            : "يجب اختيار قيمه > صفر",
                      )
                    ],
                    initialValue: 0,
                    step: 1,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  BlocConsumer<MakeNewOrderBloc, MakeNewOrderStates>(
                    builder: (context, state) {
                      if (state is MakeNewOrderStatesStart)
                        return SpinKitCircle(
                          color: AppTheme.primaryColor,
                          size: 40.0,
                        );
                      else
                        return btn(
                            context,
                            translator.currentLanguage == "en"
                                ? "Send Order"
                                : "ارسال الطلب", () {
                          _submit(context: context);
                        });
                    },
                    listener: (context, state) {
                      if (state is MakeNewOrderStatesSuccess) {
                        Get.to(BottomNavigationView());
                        Toast.show(
                            translator.currentLanguage == "en"
                                ? "Done"
                                : "تم عمل الطلب بنجاح",
                            context);
                      } else if (state is MakeNewOrderStatesFailed) {
                        _handleError(state: state, context: context);
                      }
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _item(String key, String val) {
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 7, left: 7),
        child: Text(
          key + " : ",
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 14,
            // fontWeight: FontWeight.w700,
          ),
        ),
      ),
      AutoSizeText(
        val,
        maxLines: 2,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          // fontWeight: FontWeight.w600
        ),
      ),
    ],
  );
}

class OrderData {
  int countryId;
  int cityId;
  int adId;
  String address;
  int qty;

  OrderData({
    this.countryId,
    this.cityId,
    this.adId,
    this.address,
    this.qty,
  });

  Map<String, dynamic> toJson() {
    return {
      "countryId": countryId,
      "cityId": cityId,
      "adId": adId,
      "address": address,
      "qty": qty,
    };
  }
}
