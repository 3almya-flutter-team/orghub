// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:orghub/Screens/Auth/Activation/view.dart';
// import 'package:orghub/Screens/Auth/SignIn/bloc.dart';
// import 'package:orghub/Screens/Auth/SignIn/view.dart';
// // import 'file:///E:/projects/org_hub/lib/Screens/Auth/card.dart';
// import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
// import 'package:orghub/Screens/CustomWidgets/TextFields.dart';

// import '../card.dart';

// class ClientSignUpView extends StatefulWidget {
//   @override
//   _ClientSignUpViewState createState() => _ClientSignUpViewState();
// }

// class _ClientSignUpViewState extends State<ClientSignUpView> {
//   bool obscureText = true;
//   String name, mobile, email, password;
//   int cityId;
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _confirmPasswordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Column(
//             children: <Widget>[
//               authCard(
//                 context: context,
//                 onTap: () {
//                   Get.to(
//                         BlocProvider(
//                           create: (_) => UserLoginBloc(),
//                           child: SignInView(),
//                         ),
//                       );
//                 },
//                 key: translator.currentLanguage == "en"
//                     ? "Already have account ?"
//                     : "لديك حساب بالفعل ؟",
//                 val: translator.currentLanguage == "en"
//                     ? "Sign in"
//                     : "تسجيل دخول",
//                 isIntro: false,
//                 type: translator.currentLanguage == "en"
//                     ? "Sign in"
//                     : "تسجيل الدخول",
//               ),
//               sizedBox(),
//               txtField(
//                 context: context,
//                 hintText: translator.currentLanguage == "en" ? "Name" : "الاسم",
//                 onSaved: (val) {},
//                 validator: (val) {},
//                 textInputType: TextInputType.text,
//                 controller: null,
//                 obscureText: false,
//               ),
//               sizedBox(),
//               txtField(
//                 context: context,
//                 hintText: translator.currentLanguage == "en"
//                     ? "Mobile"
//                     : "رقم الجوال",
//                 onSaved: (val) {},
//                 validator: (val) {},
//                 textInputType: TextInputType.phone,
//                 controller: null,
//                 obscureText: false,
//               ),
//               sizedBox(),
//               txtField(
//                 context: context,
//                 hintText: translator.currentLanguage == "en"
//                     ? "Email"
//                     : "البريد الالكترونى",
//                 onSaved: (val) {},
//                 validator: (val) {},
//                 textInputType: TextInputType.emailAddress,
//                 controller: null,
//                 obscureText: false,
//               ),
//               sizedBox(),

//               passwordTextField(
//                   context: context,
//                   validator: (String val) {
//                     if (_passwordController.text !=
//                         _confirmPasswordController.text) {
//                       // print("not equal $password");
//                       return translator.currentLanguage == "en"
//                           ? "Please check password"
//                           : "من فضلك تأكد من كلمه المرور";
//                     } else if (val.toString().length < 6) {
//                       return translator.currentLanguage == "en"
//                           ? "It must contain at least 6 numbers or letters"
//                           : "يجب ان تحتوي علي 6 ارقام او احرف علي الأقل";
//                     } else if (val.isEmpty)
//                       return translator.currentLanguage == "en"
//                           ? "Password is required"
//                           : "كلمة المرور مطلوبة";
//                     else {
//                       return null;
//                     }
//                   },
//                   onSaved: null,
//                   controller: _passwordController,
//                   obscureText: obscureText,

//                   onSuffixIconTapped: () {
//                     setState(() {
//                       obscureText = !obscureText;
//                     });
//                   },
//                   hintText: translator.currentLanguage == "en"
//                       ? "Password"
//                       : "كلمة المرور"),
//              sizedBox(),
//               passwordTextField(
//                   context: context,

//                   validator: (String val) {
//                     if (_passwordController.text !=
//                         _confirmPasswordController.text) {
//                       return translator.currentLanguage == "en"
//                           ? "Please check password"
//                           : "من فضلك تأكد من كلمه المرور";
//                     } else if (val.isEmpty)
//                       return translator.currentLanguage == "en"
//                           ? "Password is required"
//                           : "كلمة المرور مطلوبة";
//                     else {
//                       return null;
//                     }
//                   },
//                   onSaved: (String val) {
//                     setState(() {
//                       password = val;
//                     });
//                   },
//                   controller: _confirmPasswordController,
//                   obscureText: obscureText,
//                   onSuffixIconTapped: () {
//                     setState(() {
//                       obscureText = !obscureText;
//                     });
//                   },
//                   hintText: translator.currentLanguage == "en"
//                       ? "Confirm password"
//                       : "تأكيد كلمة المرور"),


// //              txtField(
// //                context: context,
// //                hintText: translator.currentLanguage == "en"
// //                    ? "Password"
// //                    : "كلمة المرور",
// //                onSaved: (val) {},
// //                validator: (val) {},
// //                textInputType: TextInputType.text,
// //                controller: null,
// //                obscureText: true,
// //              ),
// //              sizedBox(),
// //              txtField(
// //                context: context,
// //                hintText: translator.currentLanguage == "en"
// //                    ? "Confirm password"
// //                    : "تأكيد كلمة المرور",
// //                onSaved: (val) {},
// //                validator: (val) {},
// //                textInputType: TextInputType.text,
// //                controller: null,
// //                obscureText: true,
// //              ),
//               sizedBox(),
//               btn(
//                 context,
//                 translator.currentLanguage == "en"
//                     ? "Create account"
//                     : "انشاء حساب",
//                     () { Get.to(
//                   ActivationView(
//                     mobile: "2121231322",
//                     type: translator.currentLanguage =="en"?"Account activation":"تفعيل الحساب",
//                     status: "client sign up",
//                   ),
//                 );},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
