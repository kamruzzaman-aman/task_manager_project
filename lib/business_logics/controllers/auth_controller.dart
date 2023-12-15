import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_project/data/models/user_auth_model.dart';

class AuthController extends GetxController {
  static String? token;
  UserAuthModel? user;   //instance gula use korar jonno static rakha jabey na

  Future<void> saveUserInformation(
      String userToken, UserAuthModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', userToken);
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));

    // Update the static variables in the calling code
    //Save howar sathey sathey ui update korar jonno store kora hosche
    token = userToken;
    user = model;
    update();
  }

  Future<void> updateUserInformation(UserAuthModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    user = model;
    // Notify listeners that the user has been updated
    update();
  }

  Future<void> initializeUserCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    user = UserAuthModel.fromJson(
        jsonDecode(sharedPreferences.getString('user') ?? '{}'));
    update();
  }

  Future<bool> checkAuthState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // String? token = sharedPreferences.getString('token');
    // if (token != null) {
    //   await initializeUserCache();
    //   return true;
    // }

    //or------------

    if (sharedPreferences.containsKey('token')) {
      await initializeUserCache();
      return true;
    }
    return false;
  }

  static Future<void> clearAuthData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;
  }
}
