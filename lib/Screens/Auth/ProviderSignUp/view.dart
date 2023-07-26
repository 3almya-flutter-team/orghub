import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/ComonServices/CityService/bloc.dart';
import 'package:orghub/ComonServices/CityService/events.dart';
import 'package:orghub/ComonServices/CityService/model.dart';
import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/ComonServices/CountryService/bloc.dart';
import 'package:orghub/ComonServices/CountryService/events.dart';
import 'package:orghub/ComonServices/CountryService/model.dart';
import 'package:orghub/ComonServices/CountryService/states.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
// import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Screens/Auth/Activation/bloc.dart';
import 'package:orghub/Screens/Auth/Activation/view.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/bloc.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/events.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/provider_input_model.dart';
import 'package:orghub/Screens/Auth/ProviderSignUp/states.dart';
import 'package:orghub/Screens/Auth/SignIn/bloc.dart';
import 'package:orghub/Screens/Auth/SignIn/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/DropDown.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:orghub/Screens/MapPage/Bloc/LocationService/location_service_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_states.dart';
import 'package:orghub/Screens/MapPage/map_page.dart';
import 'package:orghub/Utils/CommonAppWidgets/location_bottom_sheets.dart';
import 'package:orghub/Utils/FormBuilder/src/widgets/image_source_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import '../card.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class ProviderSignUpView extends StatefulWidget {
  @override
  _ProviderSignUpViewState createState() => _ProviderSignUpViewState();
}

class _ProviderSignUpViewState extends State<ProviderSignUpView> {
  bool obscureText = true;
  String name, mobile, email, password;
  int cityId;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // ignore: close_sinks
  GetAllCountries getAllCountriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCountries>();
  // ignore: close_sinks
  GetAllCitiesBloc getAllCitiesBloc =
      kiwi.KiwiContainer().resolve<GetAllCitiesBloc>();

  ProviderInputData providerInputData = ProviderInputData();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String organizationLocation;

  MapBloc mapBloc = kiwi.KiwiContainer().resolve<MapBloc>();

  LocationServiceBloc locationServiceBloc =
      kiwi.KiwiContainer().resolve<LocationServiceBloc>();

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    getAllCountriesBloc.add(GetAllCountriesEventStart());
  }

  @override
  void dispose() {
    mapBloc.close();
    locationServiceBloc.close();
    super.dispose();
  }

  void displayCountriesBottomSheet(
      {BuildContext context, List<CountryData> countries}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(9),
            child: Column(
              children: [
                Text(translator.currentLanguage == "en"
                    ? "Please choose your country"
                    : "من فضلك قم باختيار الدوله "),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: countries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              providerInputData.countryId = countries[index].id;
                              providerInputData.countryName =
                                  countries[index].name;
                            });
                            getAllCitiesBloc.add(
                              GetAllCitiesEventStart(
                                  countryId: countries[index].id),
                            );
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(countries[index].name ?? ""),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }

  void displayCitiesBottomSheet({BuildContext context, List<CityData> cities}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(9),
            child: Column(
              children: [
                Text(translator.currentLanguage == "en"
                    ? "Please choose your city"
                    : "من فضلك قم باختيار المدينه "),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: cities.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              providerInputData.cityId = cities[index].id;
                              providerInputData.cityName = cities[index].name;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(cities[index].name ?? ""),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }

  // LocationData _locationData;
  // void _getCurrentLocation() async {
  //   print(";;;;;;;;;;;;;");
  //   _serviceEnabled = await location.serviceEnabled();
  //   print(";;;;;;;;;;;;; $_serviceEnabled");
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //   _permissionGranted = await location.hasPermission();
  //   print(";;;;;;;;;;;;; $_permissionGranted");
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   LocationData locationData = await location.getLocation();
  //   print("=-=-=>>>> ${locationData.latitude}");
  //   setState(() {
  //     _locationData = locationData;
  //   });
  // }

  // void getOrganizationLocation(BuildContext context) {
  //   print("xxxx");

  //   if (_locationData != null) {
  //     showLocationPicker(context, "AIzaSyD8of-XmJr7P140k3J1Bs0ixcXh2JvxFN0",
  //             initialCenter:
  //                 LatLng(_locationData.latitude, _locationData.longitude))
  //         .then((location) {
  //       print(location.address ?? "");
  //       print(location.latLng.latitude ?? "");
  //       print(location.latLng.longitude ?? "");
  //       setState(() {
  //         organizationLocation = location.address;
  //         providerInputData.organizationLocation = location.address;
  //         providerInputData.organizationLat = location.latLng.latitude;
  //         providerInputData.organizationLng = location.latLng.longitude;
  //       });
  //     });
  //   } else {
  //     Toast.show("من فضلك قم باعطاء صلاحيه الموقع للتطبيق", context);
  //   }
  // }

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
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();

      if (providerInputData.organizationLat == null ||
          providerInputData.organizationLng == null ||
          providerInputData.organizationLocation == null) {
        FlashHelper.errorBar(context,
            message: translator.currentLanguage == "en"
                ? "Company location is required"
                : "موقع الشركه مطلوب");
        return;
      }
      if (providerInputData.organizationlicenceimage == null) {
        FlashHelper.errorBar(context,
            message: translator.currentLanguage == "en"
                ? "Licence image  is required"
                : " صوره الرخصه مطلوبه");
        return;
      }

      BlocProvider.of<ProviderSignUpBloc>(context).add(
        ProviderRegisterEventStart(
          providerInputData: providerInputData,
        ),
      );
    }
  }

  void _handleError({BuildContext context, ProviderRegisterStateFailed state}) {
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

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection: translator.currentLanguage == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    authCard(
                      changeLang: () {
                        translator.currentLanguage == "en"
                            ? translator.setNewLanguage(
                                context,
                                newLanguage: 'ar',
                                remember: true,
                                restart: false,
                              )
                            : translator.setNewLanguage(
                                context,
                                newLanguage: 'en',
                                remember: true,
                                restart: false,
                              );
                        setState(() {});
                      },
                      context: context,
                      onTap: () {
                        Get.to(
                          BlocProvider(
                            create: (_) => UserLoginBloc(),
                            child: SignInView(),
                          ),
                        );
                      },
                      key: translator.currentLanguage == "en"
                          ? "Already have account ?"
                          : "لديك حساب بالفعل ؟",
                      val: translator.currentLanguage == "en"
                          ? "Sign in"
                          : "تسجيل دخول",
                      isIntro: false,
                      type: translator.currentLanguage == "en"
                          ? "Create account"
                          : "انشاء حساب",
                    ),
                    sizedBox(),
                    routeContainer(
                        context: context,
                        onTap: () {
                          openImagePicker(context: context, type: "profile");
                        },
                        txt: translator.currentLanguage == "en"
                            ? "Profile image"
                            : "صورة الشخصيه"),
                    providerInputData.profileImage == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.all(8),
                            constraints: BoxConstraints(
                              maxHeight: 100,
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Image.file(providerInputData.profileImage),
                          ),

                    // sizedBox(),
                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "Company name"
                          : "اسم الشركة",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.organizationName = val;
                        });
                      },
                      validator: (val) {
                        if (val == null || val == "") {
                          return "اسم الشركه مطلوب";
                        }
                      },
                      textInputType: TextInputType.text,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "User name"
                          : "اسم المستخدم",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.fullname = val;
                        });
                      },
                      validator: (val) {
                        if (val == null || val == "") {
                          return " اسم المستخدم مطلوب";
                        }
                      },
                      textInputType: TextInputType.text,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "Mobile"
                          : "رقم الجوال",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.phone = val;
                        });
                      },
                      validator: (val) {
                        if (val == null || val == "") {
                          return "رقم الجوال مطلوب";
                        }
                      },
                      textInputType: TextInputType.phone,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "WhatsApp number"
                          : "رقم الواتس اب",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.whatsapp = val;
                        });
                      },
                      validator: (val) {},
                      textInputType: TextInputType.phone,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "Email"
                          : "البريد الالكترونى",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.email = val;
                        });
                      },
                      validator: (String val) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);

                        if (val.isEmpty) {
                          return translator.currentLanguage == "en"
                              ? "Email is required"
                              : "البريد الالكترونى  مطلوب";
                        } else if (!regex.hasMatch(val.trim()))
                          return translator.currentLanguage == "en"
                              ? "Enter a valid email"
                              : "ادخل بريد الكتروني صحيح";
                        else
                          return null;
                      },
                      textInputType: TextInputType.emailAddress,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    BlocBuilder<GetAllCountries, GetAllCountriesStates>(
                        bloc: getAllCountriesBloc,
                        builder: (context, state) {
                          if (state is GetAllCountriesStateStart) {
                            return SpinKitThreeBounce(
                              size: 20,
                              color: AppTheme.primaryColor,
                            );
                          } else if (state is GetAllCountriesStateSucess) {
                            return routeContainer(
                              context: context,
                              onTap: () {
                                print("here");
                                displayCountriesBottomSheet(
                                    context: context,
                                    countries: state.allCountriesModel.data);
                              },
                              txt: providerInputData.countryName == null
                                  ? translator.currentLanguage == "en"
                                      ? "Select Country"
                                      : "اختر الدوله"
                                  : providerInputData.countryName,
                            );
                          } else {
                            return Container();
                          }
                        }),
                    providerInputData.countryId == null
                        ? Container()
                        : BlocBuilder<GetAllCitiesBloc, GetAllCitesStates>(
                            bloc: getAllCitiesBloc,
                            builder: (context, state) {
                              if (state is GetAllCitesStateStart) {
                                return SpinKitThreeBounce(
                                  size: 20,
                                  color: AppTheme.primaryColor,
                                );
                              } else if (state is GetAllCitesStateSucess) {
                                return routeContainer(
                                  context: context,
                                  onTap: () {
                                    print("here");
                                    displayCitiesBottomSheet(
                                        context: context,
                                        cities: state.allCitiesModel.data);
                                  },
                                  txt: providerInputData.cityName == null
                                      ? translator.currentLanguage == "en"
                                          ? "Select City"
                                          : "اختر المدينه"
                                      : providerInputData.cityName,
                                );
                              } else {
                                return Container();
                              }
                            }),
                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "Company address"
                          : "عنوان الشركة",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.organizationAddress = val;
                        });
                      },
                      validator: (val) {},
                      textInputType: TextInputType.text,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    // routeContainer(
                    //   context: context,
                    //   onTap: () {
                    //     // print("here");
                    //     // getOrganizationLocation(context);
                    //   },
                    //   txt: organizationLocation == null
                    //       ? translator.currentLanguage == "en"
                    //           ? "Company location"
                    //           : "موقع الشركة"
                    //       : organizationLocation,
                    // ),

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
                                child: routeContainer(
                                  context: context,
                                  onTap: () {
                                    print("090909090=-=-=-=>");
                                    mapBloc.add(MapEventsStart());
                                  },
                                  txt: organizationLocation == null
                                      ? translator.currentLanguage == "en"
                                          ? "Company location"
                                          : "موقع الشركة"
                                      : organizationLocation,
                                ));
                          }
                        },
                        listener: (context, state) {
                          if (state is MapStatesSuccess) {
                            print("I am here");
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

                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "Company Website"
                          : "الموقع الالكترونى للشركه",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.organizationWebsite = val;
                        });
                      },
                      validator: (val) {},
                      textInputType: TextInputType.text,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    routeContainer(
                        context: context,
                        onTap: () {
                          openImagePicker(
                              context: context, type: "licenceimage");
                        },
                        txt: translator.currentLanguage == "en"
                            ? "Licence image"
                            : "صورة الرخصة"),
                    providerInputData.organizationlicenceimage == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.all(8),
                            constraints: BoxConstraints(
                              maxHeight: 100,
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Image.file(
                                providerInputData.organizationlicenceimage),
                          ),

                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "Licence Number"
                          : "رقم الرخصه",
                      onSaved: (val) {
                        setState(() {
                          providerInputData.organizationlicenceNumber = val;
                        });
                      },
                      validator: (val) {},
                      textInputType: TextInputType.text,
                      controller: null,
                      obscureText: false,
                    ),
                    sizedBox(),
                    passwordTextField(
                        context: context,
                        validator: (String val) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            // print("not equal $password");
                            return translator.currentLanguage == "en"
                                ? "Please check password"
                                : "من فضلك تأكد من كلمه المرور";
                          } else if (val.toString().length < 6) {
                            return translator.currentLanguage == "en"
                                ? "It must contain at least 6 numbers or letters"
                                : "يجب ان تحتوى علي 6 ارقام او احرف علي الأقل";
                          } else if (val.isEmpty)
                            return translator.currentLanguage == "en"
                                ? "Password is required"
                                : "كلمة المرور مطلوبة";
                          else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            providerInputData.password = val;
                          });
                        },
                        controller: _passwordController,
                        obscureText: obscureText,
                        onSuffixIconTapped: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        hintText: translator.currentLanguage == "en"
                            ? "Password"
                            : "كلمة المرور"),
                    sizedBox(),
                    passwordTextField(
                        context: context,
                        validator: (String val) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            return translator.currentLanguage == "en"
                                ? "Please check password"
                                : "من فضلك تأكد من كلمه المرور";
                          } else if (val.isEmpty)
                            return translator.currentLanguage == "en"
                                ? "Password is required"
                                : "كلمة المرور مطلوبة";
                          else {
                            return null;
                          }
                        },
                        onSaved: (String val) {
                          setState(() {
                            password = val;
                          });
                        },
                        controller: _confirmPasswordController,
                        obscureText: obscureText,
                        onSuffixIconTapped: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        hintText: translator.currentLanguage == "en"
                            ? "Confirm password"
                            : "تأكيد كلمة المرور"),
                    sizedBox(),
                    BlocConsumer<ProviderSignUpBloc, ProviderRegisterStates>(
                      builder: (context, state) {
                        if (state is ProviderRegisterStateStart)
                          return SpinKitCircle(
                            color: AppTheme.primaryColor,
                            size: 40.0,
                          );
                        else
                          return btn(
                            context,
                            translator.currentLanguage == "en"
                                ? "Create account"
                                : "انشاء حساب",
                            () {
                              _submit(context: context);
                            },
                          );
                      },
                      listener: (context, state) {
                        if (state is ProviderRegisterStateSuccess) {
                          Toast.show("تم تسجيل الحساب بنجاح برجاء", context);
                          Get.to(
                            BlocProvider(
                              create: (_) => ActivateAccountBloc(),
                              child: ActivationView(
                                userName: providerInputData.email ?? "",
                                type: translator.currentLanguage == "en"
                                    ? "Account activation"
                                    : "تفعيل الحساب",
                                status: "provider sign up",
                              ),
                            ),
                          );
                        } else if (state is ProviderRegisterStateFailed) {
                          _handleError(state: state, context: context);
                        }
                      },
                    ),
                    sizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
