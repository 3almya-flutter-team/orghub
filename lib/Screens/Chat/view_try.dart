// import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:orghub/Helpers/app_theme.dart';

// class ChatScreen extends StatefulWidget {
//   ChatScreen({Key key}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   TextEditingController msgController = TextEditingController();
//   AnimationController _controller;
//   AnimationController _opacityController;
//   AnimationController _opacity2Controller;
//   AnimationController _hieghtController;
//   Animation<int> _animation;
//   Animation<double> _hieghtAnimation;
//   Animation<double> _opacityAnimation;
//   Animation<double> _opacity2Animation;

//   bool show = false;
//   bool showIcons = false;

//   @override
//   void initState() {
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _opacityController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _hieghtController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _opacity2Controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _animation = new IntTween(begin: 0, end: 45).animate(_controller)
//       ..addListener(() {
//         setState(() {});
//       });
//     _hieghtAnimation =
//         new Tween(begin: 40.0, end: 150.0).animate(_hieghtController)
//           ..addListener(() {
//             setState(() {
//               // showIcons = true;
//             });
//           });
//     _opacityAnimation =
//         new Tween(begin: 1.0, end: 0.0).animate(_opacityController)
//           ..addListener(() {
//             setState(() {});
//           });
//     _opacity2Animation =
//         new Tween(begin: 0.0, end: 1.0).animate(_opacity2Controller)
//           ..addListener(() {
//             setState(() {});
//           });

//     _controller.addListener(() {
//       if (_controller.isCompleted) {
//         print("_controller -=-=-=-");
//       }

//       if (_controller.isAnimating) {
//         _opacityController.forward();
//         _hieghtController.forward();
//         setState(() {});
//       }
//     });

//     _opacityController.addListener(() {
//       if (_opacityController.isCompleted) {
//         setState(() {
//           show = true;
//           _opacity2Controller.forward();
//         });

//         print("_opacityController Completed-=-=-=-");
//       }
//     });

//     _opacity2Controller.addListener(() {
//       if (_opacity2Controller.isAnimating) {
//         setState(() {});
//         print("00000000000000000000000000000000000000000 -=-=-=-");
//       }
//     });
//     _hieghtController.addListener(() {
//       if (_hieghtController.isCompleted) {
//         setState(() {
//           showIcons = true;
//         });
//         print("00000000000000000000000000000000000000000 -=-=-=-");
//       }
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           "احمد عزب",
//           style: TextStyle(
//             color: AppTheme.primaryColor,
//             fontSize: 15,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios,
//               size: 20,
//               color: AppTheme.primaryColor,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             }),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.bottomRight,
//               child: InkWell(
//                 splashColor: Colors.transparent,
//                 onTap: () {
//                   if (showIcons) {
//                     _controller.reverse();
//                     // _opacityController.reverse();
//                     // _opacity2Controller.reverse();
//                     _hieghtController.reverse();
//                     setState(() {
//                       showIcons = false;
//                     });
//                   } else {
//                     // setState(() {
//                     //   showIcons = true;
//                     // });
//                     _controller.forward().then((value) {
//                       print("first done");
//                     });
//                   }
//                 },
//                 child: Container(
//                   width: 35,
//                   height: _hieghtAnimation.value,
//                   // height: 40,
//                   margin: EdgeInsets.all(8),
//                   padding: EdgeInsets.only(bottom: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: !showIcons
//                         ? []
//                         : [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(.3),
//                               blurRadius: 9.0, // soften the shadow
//                               spreadRadius: 0.0, //extend the shadow
//                               offset: Offset(
//                                 5.0, // Move to right 10  horizontally
//                                 5.0, // Move to bottom 10 Vertically
//                               ),
//                             )
//                           ],
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   // alignment: Alignment.bottomCenter,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       !showIcons
//                           ? Expanded(
//                               child: Container(),
//                             )
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Image.asset(
//                                   "assets/icons/mic.png",
//                                   width: 20,
//                                   height: 20,
//                                 ),
//                                 SizedBox(
//                                   height: 18,
//                                 ),
//                                 Image.asset(
//                                   "assets/icons/file.png",
//                                   width: 20,
//                                   height: 20,
//                                 ),
//                                 SizedBox(
//                                   height: 18,
//                                 ),
//                                 Image.asset(
//                                   "assets/icons/metro.png",
//                                   width: 20,
//                                   height: 20,
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                               ],
//                             ),
//                       RotationTransition(
//                         turns:
//                             new AlwaysStoppedAnimation(_animation.value / 360),
//                         child: Opacity(
//                           opacity: show
//                               ? _opacity2Animation.value
//                               : _opacityAnimation.value,
//                           child: Image.asset(
//                             "assets/icons/attach.png",
//                             width: 25,
//                             height: 25,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.all(8),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 40,
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: msgController,
//                         keyboardType: TextInputType.text,
//                         style: TextStyle(
//                             fontFamily: AppTheme.fontName,
//                             color: AppTheme.secondaryColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13),
//                         decoration: InputDecoration(
//                           errorStyle: TextStyle(
//                             fontFamily: AppTheme.fontName,
//                             color: Colors.red,
//                             fontSize: 13,
//                           ),
//                           contentPadding: EdgeInsets.only(
//                               left: 15, top: 15, bottom: 15, right: 15),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(12),
//                             ),
//                             borderSide: BorderSide(
//                               width: 0,
//                               style: BorderStyle.none,
//                             ),
//                           ),
//                           filled: true,
//                           fillColor: AppTheme.filledColor,
//                           enabled: true,
//                           hintText: translator.currentLanguage == "en"
//                               ? "Write your message here .."
//                               : "اكتب رسالتك  هنا",
//                           hintStyle: TextStyle(
//                               color: AppTheme.secondaryColor,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
