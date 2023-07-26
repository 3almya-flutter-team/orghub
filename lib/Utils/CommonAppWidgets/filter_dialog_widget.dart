import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/AllClassificationsService/bloc.dart';
import 'package:orghub/ComonServices/AllClassificationsService/events.dart';
import 'package:orghub/ComonServices/AllClassificationsService/states.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/bloc.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/events.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/states.dart';
import 'package:orghub/ComonServices/AllMarksService/bloc.dart';
import 'package:orghub/ComonServices/AllMarksService/events.dart';
import 'package:orghub/ComonServices/AllMarksService/states.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/bloc.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/events.dart';
import 'package:orghub/ComonServices/CityService/bloc.dart';
import 'package:orghub/ComonServices/CityService/events.dart';
import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/ComonServices/CountryService/bloc.dart';
import 'package:orghub/ComonServices/CountryService/events.dart';
import 'package:orghub/ComonServices/CountryService/states.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CreateProduct/view.dart';
import 'package:orghub/Screens/Home/AllCategories/bloc.dart';
import 'package:orghub/Screens/Home/AllCategories/events.dart';
import 'package:orghub/Screens/Home/AllCategories/states.dart';
import 'package:orghub/Screens/SearchPage/bloc.dart';
import 'package:orghub/Screens/SearchPage/states.dart';
import 'package:orghub/Screens/SearchPage/view.dart';
import 'package:orghub/Utils/FormBuilder/src/fields/form_builder_dropdown.dart';
import 'package:orghub/Utils/FormBuilder/src/fields/form_builder_text_field.dart';
import 'package:orghub/Utils/FormBuilder/src/form_builder.dart';

import 'package:kiwi/kiwi.dart' as kiwi;

class FilterDialogWidget extends StatefulWidget {
  final String term;
  FilterDialogWidget({Key key, this.term}) : super(key: key);

  @override
  _FilterDialogWidgetState createState() => _FilterDialogWidgetState();
}

class _FilterDialogWidgetState extends State<FilterDialogWidget> {
  GetAllMarksBloc getAllMarksBloc =
      kiwi.KiwiContainer().resolve<GetAllMarksBloc>();
  GetAllSpecificationsBloc getAllSpecificationsBloc =
      kiwi.KiwiContainer().resolve<GetAllSpecificationsBloc>();
  GetAllClassificationsBloc getAllClassificationsBloc =
      kiwi.KiwiContainer().resolve<GetAllClassificationsBloc>();

  GetAllCurrenciesBloc getAllCurrenciesBloc =
      kiwi.KiwiContainer().resolve<GetAllCurrenciesBloc>();

  GetAllCategoriesBloc getAllCategoriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCategoriesBloc>();

  GetAllCountries getAllCountriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCountries>();

  GetAllCitiesBloc getAllCitiesBloc =
      kiwi.KiwiContainer().resolve<GetAllCitiesBloc>();

  SearchBloc searchBloc = kiwi.KiwiContainer().resolve<SearchBloc>();

  GlobalKey<FormBuilderState> filterFormKey = GlobalKey<FormBuilderState>();

  bool _showPriceField = false;
  int _selectedCountryId;

  @override
  void initState() {
    getAllMarksBloc.add(GetAllMarksEventStart());
    getAllSpecificationsBloc.add(GetAllSpecificationsEventStart());
    getAllClassificationsBloc.add(GetAllClassificationsEventStart());
    getAllCurrenciesBloc.add(GetAllCurrenciesEventStart());
    getAllCategoriesBloc.add(GetAllCategoriesEventStart());
    getAllCountriesBloc.add(GetAllCountriesEventStart());
    super.initState();
  }

  @override
  void dispose() {
    searchBloc.close();
    getAllMarksBloc.close();
    getAllSpecificationsBloc.close();
    getAllCurrenciesBloc.close();
    getAllClassificationsBloc.close();
    getAllCategoriesBloc.close();
    getAllCountriesBloc.close();
    getAllCitiesBloc.close();
    super.dispose();
  }

  void _handleError({BuildContext context, OnSearchStatesFailed state}) {
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

  void _submit({BuildContext context}) {
    filterFormKey.currentState.save();

    Map<String, dynamic> filterData = filterFormKey.currentState.value;
    filterData.putIfAbsent("keyword", () => widget.term);

    // searchBloc.add(
    //   OnSearchEventsStart(filterData: filterData),
    // );

    Get.to(SearchScreen(
      type: "afterFilter",
      filterData: filterData,
    ));
  }

  List<AdType> types = [
    AdType(
      nameAr: "بيع",
      nameEn: "sell",
    ),
    AdType(
      nameAr: "شراء",
      nameEn: "buy",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height / 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Material(
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FormBuilder(
                  key: filterFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          translator.currentLanguage == "en"
                              ? "Filter"
                              : "فلتر",
                          style: TextStyle(
                            fontFamily: "Neosans",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderDropdown(
                            attribute: "ad_type",
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                color: Colors.red,
                                fontSize: 13,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, top: 15, bottom: 15, right: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                borderSide: BorderSide(
                                    width: .5, color: Colors.grey[100]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey[200]),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey[200]),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey[200]),
                              ),
                              filled: true,
                              focusColor: AppTheme.primaryColor,
                              fillColor: Color(
                                getColorHexFromStr("#FAFAFA"),
                              ),
                            ),
                            onChanged: (val) {
                              if (val == "sell") {
                                // show price field
                                setState(() {
                                  _showPriceField = true;
                                });
                              } else {
                                setState(() {
                                  _showPriceField = false;
                                });
                              }
                            },
                            hint: Text(
                              translator.currentLanguage == "en"
                                  ? "Advert Type"
                                  : 'نوع الاعلان',
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontSize: 12,
                                color: Color(getColorHexFromStr("#949494")),
                              ),
                            ),
                            items: types
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type.nameEn,
                                    child: Text(
                                      translator.currentLanguage == "en"
                                          ? "${type.nameEn}"
                                          : "${type.nameAr}",
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
                        ),
                        //----------------------
                        // SELECT PRODUCT CATEGORY
                        //----------------------

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
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDropdown(
                                    attribute: "category_id",
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        color: Colors.red,
                                        fontSize: 13,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          top: 15,
                                          bottom: 15,
                                          right: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: .5, color: Colors.grey[100]),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      filled: true,
                                      focusColor: AppTheme.primaryColor,
                                      fillColor: Color(
                                        getColorHexFromStr("#FAFAFA"),
                                      ),
                                    ),
                                    hint: Text(
                                      translator.currentLanguage == 'en'
                                          ? "Choose Category"
                                          : 'اختار القسم',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 12,
                                        color: Color(
                                            getColorHexFromStr("#949494")),
                                      ),
                                    ),
                                    items: state.allCategories
                                        .map(
                                          (category) => DropdownMenuItem(
                                            value: category.id,
                                            child: Text(
                                              "${category.name}",
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
                              } else if (state is GetAllCategoriesStateFaild) {
                                if (state.errType == 0) {
                                  FlashHelper.errorBar(context,
                                      message: translator.currentLanguage ==
                                              'en'
                                          ? "Please check your network connection."
                                          : "برجاء التاكد من الاتصال بالانترنت ");
                                  return Text("Net work error");
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

                        //----------------------
                        // END SELECT PRODUCT CATEGORY
                        //----------------------

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
                                      errorStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        color: Colors.red,
                                        fontSize: 13,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          top: 15,
                                          bottom: 15,
                                          right: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: .5, color: Colors.grey[100]),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      filled: true,
                                      focusColor: AppTheme.primaryColor,
                                      fillColor: Color(
                                        getColorHexFromStr("#FAFAFA"),
                                      ),
                                    ),
                                    hint: Text(
                                      translator.currentLanguage == 'en'
                                          ? "Select Country"
                                          : 'اختر الدوله',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 12,
                                        color: Color(
                                            getColorHexFromStr("#949494")),
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
                                    items: state.allCountriesModel.data
                                        .map(
                                          (country) => DropdownMenuItem(
                                            value: country.id,
                                            child: Text(
                                              "${country.name}",
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
                              } else if (state is GetAllCountriesStateFaild) {
                                if (state.errType == 0) {
                                  FlashHelper.errorBar(context,
                                      message: translator.currentLanguage ==
                                              'en'
                                          ? "Please check your network connection."
                                          : "برجاء التاكد من الاتصال بالانترنت ");
                                  return Text("Net work error");
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
                                          errorStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              top: 15,
                                              bottom: 15,
                                              right: 15),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(9),
                                            ),
                                            borderSide: BorderSide(
                                                width: .5,
                                                color: Colors.grey[100]),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(9),
                                            ),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.grey[200]),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(9),
                                            ),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.grey[200]),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(9),
                                            ),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.grey[200]),
                                          ),
                                          filled: true,
                                          focusColor: AppTheme.primaryColor,
                                          fillColor: Color(
                                            getColorHexFromStr("#FAFAFA"),
                                          ),
                                        ),
                                        hint: Text(
                                          translator.currentLanguage == 'en'
                                              ? "Select City"
                                              : 'اختر المدينه',
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontSize: 12,
                                            color: Color(
                                                getColorHexFromStr("#949494")),
                                          ),
                                        ),
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
                                  } else if (state is GetAllCitesStateFaild) {
                                    if (state.errType == 0) {
                                      FlashHelper.errorBar(context,
                                          message: translator.currentLanguage ==
                                                  'en'
                                              ? "Please check your network connection."
                                              : "برجاء التاكد من الاتصال بالانترنت ");
                                      return Text("Net work error");
                                    } else {
                                      FlashHelper.errorBar(context,
                                          message: "");
                                      return Container();
                                    }
                                  } else {
                                    // FlashHelper.errorBar(context, message: "");
                                    return Container();
                                  }
                                }),

                        //----------------------
                        // END SELECT PRODUCT City
                        //----------------------

                        !_showPriceField
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderTextField(
                                  attribute: "price",
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: translator.currentLanguage == 'en'
                                        ? "Price"
                                        : "السعر",
                                    hintStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                    errorStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        top: 15,
                                        bottom: 15,
                                        right: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                      borderSide: BorderSide(
                                          width: .5, color: Colors.grey[100]),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey[200]),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey[200]),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey[200]),
                                    ),
                                    filled: true,
                                    focusColor: AppTheme.primaryColor,
                                    fillColor: Color(
                                      getColorHexFromStr("#FAFAFA"),
                                    ),
                                  ),
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
                              } else if (state is GetAllCurrenciesStateSucess) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDropdown(
                                    attribute: "currency_id",
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        color: Colors.red,
                                        fontSize: 13,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          top: 15,
                                          bottom: 15,
                                          right: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: .5, color: Colors.grey[100]),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      filled: true,
                                      focusColor: AppTheme.primaryColor,
                                      fillColor: Color(
                                        getColorHexFromStr("#FAFAFA"),
                                      ),
                                    ),
                                    hint: Text(
                                      translator.currentLanguage == 'en'
                                          ? "Select Currency Type"
                                          : 'اختر العمله',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 12,
                                        color: Color(
                                            getColorHexFromStr("#949494")),
                                      ),
                                    ),
                                    items: state.allCurrenciesModel.data
                                        .map(
                                          (currency) => DropdownMenuItem(
                                            value: currency.id,
                                            child: Text(
                                              "${currency.name}",
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
                              } else if (state is GetAllCurrenciesStateFaild) {
                                if (state.errType == 0) {
                                  FlashHelper.errorBar(context,
                                      message: translator.currentLanguage ==
                                              'en'
                                          ? "Please check your network connection."
                                          : "برجاء التاكد من الاتصال بالانترنت ");
                                  return Text("Net work error");
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

                        //----------------------
                        // SELECT PRODUCT MARK
                        //----------------------

                        BlocBuilder(
                            bloc: getAllMarksBloc,
                            builder: (context, state) {
                              if (state is GetAllMarksStateStart) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SpinKitThreeBounce(
                                    color: AppTheme.primaryColor,
                                    size: 30,
                                  ),
                                );
                              } else if (state is GetAllMarksStateSucess) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDropdown(
                                    attribute: "mark_id",
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        color: Colors.red,
                                        fontSize: 13,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          top: 15,
                                          bottom: 15,
                                          right: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: .5, color: Colors.grey[100]),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      filled: true,
                                      focusColor: AppTheme.primaryColor,
                                      fillColor: Color(
                                        getColorHexFromStr("#FAFAFA"),
                                      ),
                                    ),
                                    hint: Text(
                                      translator.currentLanguage == 'en'
                                          ? "Select Mark"
                                          : 'اختر الماركه',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 12,
                                        color: Color(
                                            getColorHexFromStr("#949494")),
                                      ),
                                    ),
                                    items: state.allMarksModel.data
                                        .map(
                                          (mark) => DropdownMenuItem(
                                            value: mark.id,
                                            child: Text(
                                              "${mark.name}",
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
                              } else if (state is GetAllMarksStateFaild) {
                                if (state.errType == 0) {
                                  FlashHelper.errorBar(context,
                                      message: translator.currentLanguage ==
                                              'en'
                                          ? "Please check your network connection."
                                          : "برجاء التاكد من الاتصال بالانترنت ");
                                  return Text("Net work error");
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

                        //----------------------
                        // END SELECT PRODUCT MARK
                        //----------------------

                        //----------------------
                        // SELECT PRODUCT Classifications
                        //----------------------

                        BlocBuilder(
                            bloc: getAllClassificationsBloc,
                            builder: (context, state) {
                              if (state is GetAllClassificationsStateStart) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SpinKitThreeBounce(
                                    color: AppTheme.primaryColor,
                                    size: 30,
                                  ),
                                );
                              } else if (state
                                  is GetAllClassificationsStateSucess) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDropdown(
                                    attribute: "classification_id",
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        color: Colors.red,
                                        fontSize: 13,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          top: 15,
                                          bottom: 15,
                                          right: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: .5, color: Colors.grey[100]),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[200]),
                                      ),
                                      filled: true,
                                      focusColor: AppTheme.primaryColor,
                                      fillColor: Color(
                                        getColorHexFromStr("#FAFAFA"),
                                      ),
                                    ),
                                    hint: Text(
                                      translator.currentLanguage == 'en'
                                          ? "Advert Details"
                                          : 'موصفات الاعلان',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 12,
                                        color: Color(
                                            getColorHexFromStr("#949494")),
                                      ),
                                    ),
                                    items: state.allClassificationsModel.data
                                        .map(
                                          (classify) => DropdownMenuItem(
                                            value: classify.id,
                                            child: Text(
                                              "${classify.name}",
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
                              } else if (state
                                  is GetAllClassificationsStateFaild) {
                                if (state.errType == 0) {
                                  FlashHelper.errorBar(context,
                                      message: translator.currentLanguage ==
                                              'en'
                                          ? "Please check your network connection."
                                          : "برجاء التاكد من الاتصال بالانترنت ");
                                  return Text("Net work error");
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
                        // END SELECT PRODUCT Classifications
                        //----------------------

                        SizedBox(
                          height: 20,
                        ),

                        // BlocConsumer(
                        //   bloc: searchBloc,
                        //   builder: (context, state) {
                        //     if (state is OnSearchStatesStart) {
                        //       return SpinKitCircle(
                        //         color: AppTheme.primaryColor,
                        //         size: 30,
                        //       );
                        //     } else {
                        //       return InkWell(
                        //         onTap: () {
                        //           _submit(context: context);
                        //         },
                        //         child: Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           height: 40,
                        //           decoration: BoxDecoration(
                        //             color: AppTheme.primaryColor,
                        //             borderRadius: BorderRadius.circular(10),
                        //           ),
                        //           child: Center(
                        //             child: Text(
                        //              translator.currentLanguage == "en" ? "Search": "بحث",
                        //               style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 15,
                        //                   fontWeight: FontWeight.w800),
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     }
                        //   },
                        //   listener: (context, state) {
                        //     if (state is OnSearchStatesSuccess) {
                        //       // Get.back();
                        //     } else if (state is OnSearchStatesFailed) {
                        //       _handleError(context: context, state: state);
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 25,
                  height: 25,
                  margin: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 15,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: BlocConsumer(
                bloc: searchBloc,
                builder: (context, state) {
                  if (state is OnSearchStatesStart) {
                    return SpinKitCircle(
                      color: AppTheme.primaryColor,
                      size: 30,
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        _submit(context: context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6),
                        width: MediaQuery.of(context).size.width / 2,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            translator.currentLanguage == "en"
                                ? "Search"
                                : "بحث",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    );
                  }
                },
                listener: (context, state) {
                  if (state is OnSearchStatesSuccess) {
                    // Get.back();
                  } else if (state is OnSearchStatesFailed) {
                    _handleError(context: context, state: state);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
