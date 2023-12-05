import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager_project/app.dart';
import 'package:task_manager_project/business_logics/controllers/auth_controller.dart';
import 'package:task_manager_project/ui/screens/auth/login_screen.dart';

import 'network_response.dart';

class NetworkCaller {

//Post Request

  Future<NetworkResponse> postRequest(String url,
      {Map<String, dynamic>? body, bool isLogin=false}) async {
    try {
      log(url);
      log(body.toString());

      final Response response = await post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {
            "Content-type": "Application/json",
            // "token": "kk",
            "token": AuthController.token.toString(),
          });
          
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        return NetworkResponse(
            isSuccess: true,
            jsonResponse: jsonDecode(response.body),
            statusCode: 200);
      } else if(response.statusCode==401){
        if (isLogin==false) {
          backToLogin();
        }
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(response.body),
            statusCode: response.statusCode);
      } 
      else {
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(response.body),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }



//Get Request
  Future<NetworkResponse> getRequest(String url) async {
    try {
      log(url);

      final Response response = await get(Uri.parse(url),
          headers: {
            "Content-type": "Application/json",
            // "token": "kk",
            "token": AuthController.token.toString(),
          });
          
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        return NetworkResponse(
            isSuccess: true,
            jsonResponse: jsonDecode(response.body),
            statusCode: 200);
      } else if(response.statusCode==401){
          backToLogin();
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(response.body),
            statusCode: response.statusCode);
      } 
      else {
        return NetworkResponse(
            isSuccess: false,
            jsonResponse: jsonDecode(response.body),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }


//401 Unauthorized Handling
Future<void> backToLogin() async{
  await AuthController.clearAuthData();
  Navigator.pushAndRemoveUntil(MyApp.navigationKey.currentContext!, MaterialPageRoute(builder: (context)=>const LoginScreen()), (route)=>false);
}


}
