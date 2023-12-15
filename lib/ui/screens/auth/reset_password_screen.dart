import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/verify_controller.dart';
import 'package:task_manager_project/ui/screens/auth/login_screen.dart';
import 'package:task_manager_project/ui/screens/auth/regex_validator.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.pin});

  final String email;
  final String pin;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();

  final TextEditingController _confirmPassTEController =
      TextEditingController();
  final GlobalKey<FormState> _passFormKey = GlobalKey<FormState>();
  EmailPassVerifyController _emailPassVerifyController =
      Get.find<EmailPassVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _passFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Set Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Minimum length password 8 character with Latter and Number combination",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "Password"),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your password";
                        }

                        if (!isPasswordValid(value!)) {
                          return "must be 8-10 including case and special char";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _confirmPassTEController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(hintText: "Confirm Password"),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your password";
                        }
                        if (!isPasswordValid(value!)) {
                          return "must be 8-10 including case and special char";
                        }
                        String password = _passwordTEController.text.trim();
                        if (password != value) {
                          return "Password Not Match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GetBuilder<EmailPassVerifyController>(
                      builder: (emailPassVerifyController) {
                        return Visibility(
                          visible: emailPassVerifyController.verifyPassInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_passFormKey.currentState!.validate()) {
                                recoverPassReset();
                              }
                            },
                            child: const Text(
                              "Confirm",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Have Account? ",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                              children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(()=>const LoginScreen());
                                  
                                },
                              text: "Sign in",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                            )
                          ])),
                    ),
                  ],
                ),
              )),
        ),
      ),
    ));
  }

  Future<void> recoverPassReset() async {
    final response = await _emailPassVerifyController.recoverPassReset(
        widget.email, widget.pin, _passwordTEController.text.trim());

    if (response) {
      if (mounted) {
        showSnackMessage(context, _emailPassVerifyController.resetPassMessage);
        Get.offAll(() => const LoginScreen());
      }
    } else {
      if (mounted) {
          showSnackMessage(context, _emailPassVerifyController.resetPassMessage, true);
      }
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPassTEController.dispose();
    super.dispose();
  }
}
