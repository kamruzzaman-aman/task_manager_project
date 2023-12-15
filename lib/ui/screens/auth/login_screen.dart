import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/login_controller.dart';
import 'package:task_manager_project/ui/screens/auth/forget_password_email_verify.dart';
import 'package:task_manager_project/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager_project/ui/screens/task/main_bottom_nav_screen.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';
import '../../widgets/snack_message.dart';
import 'regex_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

final TextEditingController _userEmailTEController = TextEditingController();
final TextEditingController _userpasswordTEController = TextEditingController();

final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

final LoginController _loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _userEmailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Email"),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return "Enter your eamil";
                        }
                        if (!isEmailValid(value)) {
                          return "Enter your valid eamil";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _userpasswordTEController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "Password"),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your password";
                        }

                        // if (!isPasswordValid(value!)) {
                        //   return "must be 8-10 including case and special char";
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GetBuilder<LoginController>(
                      builder: (loginController) {
                        return Visibility(
                          visible: loginController.loginInProgress==false,   //!true = false
                          //jodi _loginInProgress = true set hoy, ar true hoile progress hobey otherwish button dekhabe
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: login,
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    // Text("Forget Password ?"),

                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Forget Password? ",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                              children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(()=>const ForgetPasswordEmailVefiry());
                                },
                              text: "Click Here",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            )
                          ])),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Don't have account? ",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                              children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(()=>const SignUpScreen());
                                },
                              text: "Sign Up",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                            )
                          ])),
                    )
                  ],
                ),
              )),
        ),
      ),
    ));
  }

  Future<void> login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    final response = await _loginController.login( _userEmailTEController.text.trim(), _userpasswordTEController.text);
 
    if (response) {
      Get.offAll(()=> MainBottomNavScreen());
      }
     else {
      if (mounted) {
          showSnackMessage(context, _loginController.failedMessage, true);
        }
      }
    }
  

  @override
  void dispose() {
    _userEmailTEController.dispose();
    _userpasswordTEController.dispose();

    super.dispose();
  }
}
