import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/auth_controller.dart';
import 'package:task_manager_project/ui/screens/auth/login_screen.dart';
import 'package:task_manager_project/ui/screens/task/main_bottom_nav_screen.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToLoginPage();
  }

  void goToLoginPage() async{
    final bool isLoggedIn = await Get.find<AuthController>().checkAuthState();
    Timer(const Duration(seconds: 8), () {
      Get.offAll(()=>isLoggedIn?  MainBottomNavScreen():const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/logo.svg",
          ),
          const SizedBox(
            height: 20,
          ),
          const LinearProgressIndicator(
            color: Colors.green,
            backgroundColor: Colors.greenAccent,
          ),
        ],
      )),
    ));
  }
}
