import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orghub/Helpers/app_theme.dart';

Widget appBar({BuildContext context, String title, bool leading}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: AppTheme.appBarColor,
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: leading
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
              color: AppTheme.appBarTextColor,
            ),
            onPressed: () {
              Get.back();
            })
        : Container(),
    title: Text(
      title,
      style: TextStyle(
          color: AppTheme.appBarTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w900),
    ),
  );
}

Widget appBarWithAction(
    {BuildContext context, String title, bool leading, Widget actionIcon}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: AppTheme.appBarColor,
    elevation: 0,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      actionIcon,
    ],
    leading: leading
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: AppTheme.appBarTextColor,
            ),
            onPressed: () {
              Get.back();
            })
        : Container(),
    title: Text(
      title,
      style: TextStyle(
          color: AppTheme.appBarTextColor,
          fontSize: 17,
          fontWeight: FontWeight.w900),
    ),
  );
}

// Widget appBarWithTwoAction(
//     {BuildContext context,
//     String title,
//     Function onDeleteTapped,
//     Function onEditTapped}) {
//   return
//    AppBar(
//     centerTitle: true,
//     backgroundColor: AppTheme.appBarColor,
//     elevation: 0,
//     automaticallyImplyLeading: false,
//     actions: <Widget>[
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(
//             onTap: onDeleteTapped,
//             child: Image.asset(
//               "assets/icons/delete11.png",
//               color: AppTheme.appBarTextColor,
//               width: 15,
//               height: 25,
//             )),
//       ),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(
//             onTap: onEditTapped,
//             child: Image.asset(
//               "assets/icons/edit.png",
//               color: AppTheme.appBarTextColor,
//               width: 20,
//               height: 20,
//             )),
//       ),
//     ],
//     leading: IconButton(
//         icon: Icon(
//           Icons.arrow_back_ios,
//           size: 25,
//           color: AppTheme.appBarTextColor,
//         ),
//         onPressed: () {
//           Navigator.of(context).pop();
//         }),
//     title: Text(
//       title,
//       style: TextStyle(color: AppTheme.appBarTextColor, fontSize: 17),
//     ),
//   );
// }
