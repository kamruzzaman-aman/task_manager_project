import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/sign_up_controller.dart';
import 'package:task_manager_project/ui/screens/auth/login_screen.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';

import '../../widgets/snack_message.dart';
import 'regex_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SignUpController _signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Join With Us",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailTEController,
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
                      height: 14,
                    ),
                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(hintText: "First Name"),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "First name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(hintText: "Last Name"),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Last name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Mobile"),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter mobile number";
                        }
                        if (!isPhoneNumberValid(value!)) {
                          return "Enter your valid number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
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
                      height: 14,
                    ),
                    GetBuilder<SignUpController>(
                      builder: (signUpController) {
                        return Visibility(
                          visible: signUpController.signUpInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _signUp();
                            },
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }
                    ),
                    const SizedBox(
                      height: 30,
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

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final response = await _signUpController.signUp(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
        _passwordTEController.text.trim(),
      );
      if (response) {
        _clearTextFields();
        if (mounted) {
          showSnackMessage(context, _signUpController.signUpMessage);
        }
      } else {
        if (mounted) {
          showSnackMessage(context, _signUpController.signUpMessage, true);
        }
      }
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
