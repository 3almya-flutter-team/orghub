import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
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
import 'package:orghub/Screens/Auth/Activation/bloc.dart';
import 'package:orghub/Screens/Auth/Activation/view.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/bloc.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/client_input_model.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/events.dart';
import 'package:orghub/Screens/Auth/ClientSignUp/states.dart';
import 'package:orghub/Screens/Auth/SignIn/bloc.dart';
import 'package:orghub/Screens/Auth/SignIn/view.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/CustomWidgets/DropDown.dart';
import 'package:orghub/Screens/CustomWidgets/TextFields.dart';
import 'package:orghub/Utils/FormBuilder/src/widgets/image_source_sheet.dart';
import 'package:toast/toast.dart';
import '../card.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class ClientSignUpView extends StatefulWidget {
  @override
  _ClientSignUpViewState createState() => _ClientSignUpViewState();
}

class _ClientSignUpViewState extends State<ClientSignUpView> {
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

  ClientInputData clientInputData = ClientInputData();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getAllCountriesBloc.add(GetAllCountriesEventStart());
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
                Text("من فضلك قم باختيار الدوله "),
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
                              clientInputData.countryId = countries[index].id;
                              clientInputData.countryName =
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
                Text("من فضلك قم باختيار المدينه "),
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
                              clientInputData.cityId = cities[index].id;
                              clientInputData.cityName = cities[index].name;
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
                clientInputData.profileImage = image;
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

      BlocProvider.of<ClientSignUpBloc>(context).add(
        ClientRegisterEventStart(
          clientInputData: clientInputData,
        ),
      );
    }
  }

  void _handleError({BuildContext context, ClientRegisterStateFailed state}) {
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
                    clientInputData.profileImage == null
                        ? Container()
                        : Container(
                            constraints: BoxConstraints(
                              maxHeight: 100,
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Image.file(clientInputData.profileImage),
                          ),
                    sizedBox(),
                    txtField(
                      context: context,
                      hintText: translator.currentLanguage == "en"
                          ? "User name"
                          : "اسم المستخدم",
                      onSaved: (val) {
                        setState(() {
                          clientInputData.fullname = val;
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
                          clientInputData.phone = val;
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
                          clientInputData.whatsapp = val;
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
                          clientInputData.email = val;
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
                              txt: clientInputData.countryName == null
                                  ? translator.currentLanguage == "en"
                                      ? "Select Country"
                                      : "اختر الدوله"
                                  : clientInputData.countryName,
                            );
                          } else {
                            return Container();
                          }
                        }),
                    clientInputData.countryId == null
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
                                  txt: clientInputData.cityName == null
                                      ? translator.currentLanguage == "en"
                                          ? "Select City"
                                          : "اختر المدينه"
                                      : clientInputData.cityName,
                                );
                              } else {
                                return Container();
                              }
                            }),
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
                            clientInputData.password = val;
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
                    BlocConsumer<ClientSignUpBloc, ClientRegisterStates>(
                      builder: (context, state) {
                        if (state is ClientRegisterStateStart)
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
                        if (state is ClientRegisterStateSuccess) {
                          Toast.show("تم تسجيل الحساب بنجاح برجاء", context);
                          Get.to(
                            BlocProvider(
                              create: (_) => ActivateAccountBloc(),
                              child: ActivationView(
                                userName: clientInputData.email ?? "",
                                type: translator.currentLanguage == "en"
                                    ? "Account activation"
                                    : "تفعيل الحساب",
                                status: "provider sign up",
                              ),
                            ),
                          );
                        } else if (state is ClientRegisterStateFailed) {
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
