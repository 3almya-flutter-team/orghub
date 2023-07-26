// import 'package:shared_preferences/shared_preferences.dart';

// class CheckUserAuth {
//    Future<bool> _isAuthenticated() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String token = preferences.getString("authToken");
//     if (!preferences.getKeys().toList().contains("authToken")) {
//       return false;
//     } else {
//       if (token == null || token == "") {
//         return false;
//       } else {
//         return true;
//       }
//     }
//   }
// }

