import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';

class SignUpController extends GetxController {
  bool _signUpInProgress = false;
  bool get signUpInProgress => _signUpInProgress;
  String _signUpMessage = "";
  String get signUpMessage => _signUpMessage;
   Future<bool> signUp(email, firstName, lastName, mobile, password) async {
    _signUpInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.registration, body: {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": "",
    });

    _signUpInProgress = false;
    update();
    if (response.isSuccess) {
      _signUpMessage = "Account has been created! Please login.";
      return true;
    } else {
      _signUpMessage = "Account creation failed! Please try again.";
      return false;
    }
  }
}
