import 'package:dio/dio.dart'as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:location/location.dart';
import 'package:orghub/ComonServices/CityService/bloc.dart';
import 'package:orghub/ComonServices/CityService/events.dart';
// import 'package:orghub/ComonServices/CityService/model.dart';
import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/ComonServices/CountryService/bloc.dart';
import 'package:orghub/ComonServices/CountryService/events.dart';
// import 'package:orghub/ComonServices/CountryService/model.dart';
import 'package:orghub/ComonServices/CountryService/states.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/provider_input_model.dart';
import 'package:orghub/Screens/BottomNavigation/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/MapPage/Bloc/LocationService/location_service_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_states.dart';
import 'package:orghub/Screens/MapPage/map_page.dart';
// import 'package:orghub/Screens/More/view.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/UpdateService/bloc.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/UpdateService/events.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/UpdateService/states.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/bloc.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/events.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/states.dart';
import 'package:orghub/Screens/UpdatePassword/view.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/location_bottom_sheets.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:orghub/Utils/FormBuilder/flutter_form_builder.dart';
import 'package:orghub/Utils/FormBuilder/src/form_builder.dart';
import 'package:orghub/Utils/FormBuilder/src/widgets/image_source_sheet.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class UpdateCompanyProfileView extends StatefulWidget {
  @override
  _UpdateCompanyProfileViewState createState() =>
      _UpdateCompanyProfileViewState();
}

class _UpdateCompanyProfileViewState extends State<UpdateCompanyProfileView> {
  GetAllCountries getAllCountriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCountries>();

  GetAllCitiesBloc getAllCitiesBloc =
      kiwi.KiwiContainer().resolve<GetAllCitiesBloc>();

  GetCompanyProfileDataBloc getCompanyProfileDataBloc =
      kiwi.KiwiContainer().resolve<GetCompanyProfileDataBloc>();

  ProviderInputData providerInputData = ProviderInputData();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String organizationLocation;

  int _selectedCountryId;

  @override
  void initState() {
    super.initState();

    getAllCountriesBloc.add(GetAllCountriesEventStart());
    getCompanyProfileDataBloc.add(GetCompanyProfileEventStart());
  }

  MapBloc mapBloc = kiwi.KiwiContainer().resolve<MapBloc>();

  LocationServiceBloc locationServiceBloc =
      kiwi.KiwiContainer().resolve<LocationServiceBloc>();

  @override
  void dispose() {
    getAllCountriesBloc.close();
    getAllCitiesBloc.close();
    mapBloc.close();
    locationServiceBloc.close();
    getCompanyProfileDataBloc.close();
    super.dispose();
  }

  // void getOrganizationLocation(BuildContext context) async {
  //   double lat = await Prefs.getDoubleF("myLat");
  //   double long = await Prefs.getDoubleF("myLong");
  //   print(lat.toString());
  //   print(long.toString());
  //   showLocationPicker(
  //     context,
  //     "AIzaSyD8of-XmJr7P140k3J1Bs0ixcXh2JvxFN0",
  //     initialCenter: LatLng(
  //       lat,
  //       long,
  //     ),
  //   ).then((location) {
  //     print(location.address ?? "");
  //     print(location.latLng.latitude ?? "");
  //     print(location.latLng.longitude ?? "");
  //     setState(() {
  //       organizationLocation = location.address;
  //       providerInputData.organizationLocation = location.address;
  //       providerInputData.organizationLat = location.latLng.latitude;
  //       providerInputData.organizationLng = location.latLng.longitude;
  //     });
  //   });
  // }

  void openImagePicker({BuildContext context, String type}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImageSourceSheet(
            preferredCameraDevice: CameraDevice.rear,
            maxHeight: 100,
            maxWidth: 100,
            onImageSelected: (image) {
              print(image.toString());
              if (type == "profile") {
                providerInputData.profileImage = image;
                setState(() {});
              } else if (type == "licenceimage") {
                print("=-=---==-=-=-=");
                providerInputData.organizationlicenceimage = image;
                setState(() {});
              } else {
                providerInputData.coverImage = image;
                setState(() {});
              }

              Navigator.of(context).pop();
            },
          );
        });
  }

  void _submit({BuildContext context}) {
    if (!_fbKeys.currentState.validate()) {
      return;
    } else {
      _fbKeys.currentState.save();

      // if (providerInputData.organizationLat == null ||
      //     providerInputData.organizationLng == null ||
      //     providerInputData.organizationLocation == null) {
      //   FlashHelper.errorBar(context, message: translator.currentLanguage == "en"
      //                           ? "Company Location is required": "موقع الشركه مطلوب");
      //   return;
      // }

      Map<String, dynamic> profileData = _fbKeys.currentState.value;
      profileData.putIfAbsent("organization_location",
          () => providerInputData.organizationLocation);
      profileData.putIfAbsent(
          "organization_lat", () => providerInputData.organizationLat);
      profileData.putIfAbsent(
          "organization_lng", () => providerInputData.organizationLng);

      profileData.putIfAbsent(
        "image",
        () => providerInputData.profileImage == null
            ? null
            : dio.MultipartFile.fromFileSync(
                providerInputData.profileImage.path,
                filename: basename(providerInputData.profileImage.path),
              ),
      );
      profileData.putIfAbsent(
        "organization_licence_image",
        () => providerInputData.organizationlicenceimage == null
            ? null
            : dio.MultipartFile.fromFileSync(
                providerInputData.organizationlicenceimage.path,
                filename:
                    basename(providerInputData.organizationlicenceimage.path),
              ),
      );
      profileData.putIfAbsent(
        "cover",
        () => providerInputData.coverImage == null
            ? null
            :dio. MultipartFile.fromFileSync(
                providerInputData.coverImage.path,
                filename: basename(providerInputData.coverImage.path),
              ),
      );

      BlocProvider.of<CompanyUpdateBloc>(context).add(
        CompanyUpdateEventStart(
          profileData: profileData,
        ),
      );
    }
  }

  void _handleError({BuildContext context, CompanyUpdateStateFailed state}) {
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
      if (state.statusCode == 422) {
        FlashHelper.errorBar(context, message: state.msg ?? "");
      } else {
        FlashHelper.errorBar(context, message: state.msg ?? "");
      }
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  GlobalKey<FormBuilderState> _fbKeys = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection: translator.currentLanguage == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 17,
                color: AppTheme.appBarTextColor,
              ),
              onPressed: () {
                Get.back();
              }),
          title: Text(
            translator.currentLanguage == "en"
                ? "Update profile"
                : "تعديل بياناتى",
            style: TextStyle(
              color: AppTheme.appBarTextColor,
            ),
          ),
        ),
        body: BlocBuilder(
            bloc: getCompanyProfileDataBloc,
            builder: (context, oldDataState) {
              if (oldDataState is GetCompanyProfileStateStart) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                );
              } else if (oldDataState is GetCompanyProfileStateSuccess) {
                return FormBuilder(
                  key: _fbKeys,
                  child: ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                openImagePicker(
                                    context: context, type: "cover");
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 4,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: providerInputData.coverImage != null
                                        ? FileImage(
                                            providerInputData.coverImage)
                                        : NetworkImage(
                                            oldDataState
                                                .companyProfileModel.data.cover,
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height / 7,
                              left: 30,
                              right: 30,
                              child: InkWell(
                                onTap: () {
                                  openImagePicker(
                                      context: context, type: "profile");
                                },
                                child: Center(
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: providerInputData.profileImage !=
                                                null
                                            ? FileImage(
                                                providerInputData.profileImage)
                                            : NetworkImage(
                                                oldDataState.companyProfileModel
                                                    .data.image,
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
                            ),
                          ],
                        ),
                      ),
                      //------------------------------------
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "organization_name",
                          validators: [FormBuilderValidators.required()],
                          initialValue: oldDataState
                              .companyProfileModel.data.organizationName,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "Company name"
                                : "اسم الشركة",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "fullname",
                          validators: [FormBuilderValidators.required()],
                          initialValue:
                              oldDataState.companyProfileModel.data.fullname,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "User name"
                                : "اسم المستخدم",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "phone",
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric()
                          ],
                          initialValue:
                              oldDataState.companyProfileModel.data.phone,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "Mobile"
                                : "رقم الجوال",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "whatsapp",
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric()
                          ],
                          initialValue:
                              oldDataState.companyProfileModel.data.whatsapp,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "WhatsApp number"
                                : "رقم الواتس اب",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "email",
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email()
                          ],
                          initialValue:
                              oldDataState.companyProfileModel.data.email,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "Email"
                                : "البريد الالكترونى",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
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
                                  initialValue: oldDataState.companyProfileModel
                                              .data.country ==
                                          null
                                      ? null
                                      : oldDataState
                                          .companyProfileModel.data.country.id,
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
                                    // contentPadding: EdgeInsets.all(8),

                                    enabled:
                                        state.allCountriesModel.data.isEmpty
                                            ? false
                                            : true,
                                    labelText:
                                        translator.currentLanguage == "en"
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
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    print("=-=-=-=::::::::::::::::::-=> $val");
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
                                    message: translator.currentLanguage == 'en'
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
                                      // initialValue: oldDataState
                                      //             .companyProfileModel
                                      //             .data
                                      //             .city ==
                                      //         null
                                      //     ? null
                                      //     : oldDataState
                                      //         .companyProfileModel.data.city.id,
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
                                        // contentPadding: EdgeInsets.all(8),
                                        // enabled:
                                        //     state.allCitiesModel.data.isEmpty
                                        //         ? false
                                        //         : true,
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
                                          color: Color(
                                              getColorHexFromStr("#949494")),
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
                                } else if (state is GetAllCitesStateFaild) {
                                  if (state.errType == 0) {
                                    FlashHelper.errorBar(context,
                                        message: translator.currentLanguage ==
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
                      // END SELECT PRODUCT City
                      //----------------------

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "organization_address",
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          initialValue: oldDataState
                              .companyProfileModel.data.organizationAddress,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "Company address"
                                : "عنوان الشركة",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      BlocConsumer(
                          bloc: mapBloc,
                          builder: (context, state) {
                            if (state is MapStatesStart) {
                              return SpinKitHourGlass(
                                color: AppTheme.primaryColor,
                                size: 40.0,
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderTextField(
                                  onTap: () {
                                    mapBloc.add(MapEventsStart());
                                  },
                                  attribute: "organization_location",
                                  initialValue: organizationLocation ?? oldDataState.companyProfileModel
                                      .data.organizationLocation,
                                  textAlign: TextAlign.center,
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
                                    enabled: false,
                                    hintText: translator.currentLanguage == "en"
                                        ? "Company location"
                                        : "موقع الشركة",
                                    hintStyle: TextStyle(
                                      color: AppTheme.secondary2Color,
                                      fontSize: 9,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          listener: (context, state) {
                            if (state is MapStatesSuccess) {
                              Get.to(MapPage(),
                                      arguments: state.userCurrentAddress)
                                  .then((value) {
                                setState(() {
                                  organizationLocation =
                                      (value as UserCurrentAddress).address;
                                  providerInputData.organizationLocation =
                                      (value as UserCurrentAddress).address;
                                  providerInputData.organizationLat =
                                      (value as UserCurrentAddress).lat;
                                  providerInputData.organizationLng =
                                      (value as UserCurrentAddress).long;
                                });
                                print(
                                    "from map page ya prince =-=-=> ${(value as UserCurrentAddress).address.toString()}");
                              });
                            } else if (state is MapStatesFailed) {
                              print(
                                  "=-=-==-=-=-=-=-=-xxcxcxcxcxc=x-=c-x=c-=x-c=x-c=x-c=x-c=xcxcxcx=-=-=-=-=-=-=");
                              // open location settings to enable location service
                              displayDefultBottomSheet(
                                  context: context,
                                  onClicked: () {
                                    print("OPEN APP SETTINGS");
                                    openAppSettings();
                                  },
                                  text: "");
                            }
                          }),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "organization_website",
                          // validators: [
                          //   FormBuilderValidators.required(),
                          // ],
                          initialValue: oldDataState
                              .companyProfileModel.data.organizationWebsite,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "Company Website"
                                : "الموقع الالكترونى للشركه",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            openImagePicker(
                                context: context, type: "licenceimage");
                          },
                          child: TextField(
                            textAlign: TextAlign.center,
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
                              enabled: false,
                              hintText: translator.currentLanguage == "en"
                                  ? "Licence image"
                                  : "صورة الرخصة",
                              hintStyle: TextStyle(
                                color: AppTheme.secondary2Color,
                                fontSize: 9,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      () {
                        if (providerInputData.organizationlicenceimage !=
                            null) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            margin: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: AppTheme.primaryColor,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: FileImage(
                                    providerInputData.organizationlicenceimage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else if (oldDataState.companyProfileModel.data
                                .organizationLicenceImage !=
                            null) {
                          return Container(
                            margin: EdgeInsets.all(8),
                            constraints: BoxConstraints(
                              maxHeight: 100,
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Image.network(oldDataState
                                .companyProfileModel
                                .data
                                .organizationLicenceImage),
                          );
                        } else {
                          return Container();
                        }
                      }(),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "organization_licence_number",
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                          initialValue: oldDataState.companyProfileModel.data
                              .organizationLicenceNumber,
                          textAlign: TextAlign.center,
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey[200]),
                            ),
                            filled: true,
                            focusColor: AppTheme.primaryColor,
                            fillColor: Color(
                              getColorHexFromStr("#FAFAFA"),
                            ),
                            enabled: true,
                            hintText: translator.currentLanguage == "en"
                                ? "Licence Number"
                                : "رقم الرخصه",
                            hintStyle: TextStyle(
                              color: AppTheme.secondary2Color,
                              fontSize: 9,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      //------------------------------

                      BlocConsumer<CompanyUpdateBloc, CompanyUpdateStates>(
                        builder: (context, state) {
                          if (state is CompanyUpdateStateStart)
                            return SpinKitCircle(
                              color: AppTheme.primaryColor,
                              size: 40.0,
                            );
                          else
                            return btn(
                              context,
                              translator.currentLanguage == "en"
                                  ? "Update"
                                  : "تعديل",
                              () {
                                _submit(context: context);
                              },
                            );
                        },
                        listener: (context, state) {
                          if (state is CompanyUpdateStateSuccess) {
                            Toast.show(
                                translator.currentLanguage == "en"
                                    ? "Done"
                                    : "تم تعديل الحساب  ",
                                context);
                            Get.to(
                              BottomNavigationView(
                                pageIndex: 3,
                              ),
                            );
                          } else if (state is CompanyUpdateStateFailed) {
                            _handleError(state: state, context: context);
                          }
                        },
                      ),
                      SizedBox(),
                      FlatButton(
                          onPressed: () {
                            Get.to(UpdatePasswordView());
                          },
                          child: Text(
                            translator.currentLanguage == "en"
                                ? "Update Password"
                                : "تعديل كلمه المرور",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          )),
                    ],
                  ),
                );
              } else if (oldDataState is GetCompanyProfileStateFailed) {
                if (oldDataState.errType == 0) {
                  // FlashHelper.errorBar(context,
                  //     message: "برجاء التاكد من الاتصال بالانترنت ");
                  return noInternetWidget(context);
                } else {
                  // FlashHelper.errorBar(context,
                  //     message: oldDataState.msg ?? "");
                  return errorWidget(context, oldDataState.msg ?? "",oldDataState.statusCode);
                }
              } else {
                // FlashHelper.errorBar(context, message: oldDataState.msg ?? "");
                return Container();
              }
            }),
      ),
    );
  }
}
