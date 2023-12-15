import 'package:get/get.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';

class EmailPassVerifyController extends GetxController {
  //Reset password
  bool _verifyPassInProgress = false;
  bool get verifyPassInProgress => _verifyPassInProgress;
  String _resetPassMessage = "";
  String get resetPassMessage => _resetPassMessage;
  Future<bool> recoverPassReset(email, otp, password) async {
    _verifyPassInProgress = true;
    update();

    Map<String, dynamic> resetData = {
      "email": email,
      "OTP": otp,
      "password": password
    };

    NetworkResponse response = await NetworkCaller()
        .postRequest(Urls.recoverResetPassword, body: resetData);
    _verifyPassInProgress = false;
    update();

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      _resetPassMessage = "Password Reset Success!";
      return true;
    } else {
      _resetPassMessage = "Password Reset Not Success, try again!";
      return false;
    }
  }

  //Pin Verify
  bool _verifyPinInProgress = false;
  bool get verifyPinInProgress => _verifyPinInProgress;
  String _pinVerifyMessage = "";
  String get pinVerifyMessage => _pinVerifyMessage;
  Future<bool> verifyPin(email, pin) async {
    _verifyPinInProgress = true;
    update();
    NetworkResponse response =
        await NetworkCaller().getRequest(Urls.verifyPinForReset(email, pin));
    _verifyPinInProgress = false;
    update();

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      _pinVerifyMessage = "Pin Verification Success";
      return true;
    } else {
      _pinVerifyMessage = "Pin not match";
      return false;
    }
  }

  //Email Verify
  bool _verifyEmailInProgress = false;
  bool get verifyEmailInProgress => _verifyEmailInProgress;
  String _emailVerifyMessage = "";
  String get emailVerifyMessage => _emailVerifyMessage;
  Future<bool> verifyEmail(getEmail) async {
    _verifyEmailInProgress = true;
    update();
    NetworkResponse response =
        await NetworkCaller().getRequest(Urls.verifyEmailForPin(getEmail));
    _verifyEmailInProgress = false;
    update();

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      _emailVerifyMessage = "A 6 digit pin has been sent";
      return true;
    } else {
      _emailVerifyMessage = "Email not found";
      return false;
    }
  }
}
