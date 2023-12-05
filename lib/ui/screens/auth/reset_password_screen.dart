import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';
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
  bool verifyPassInProgress = false;

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
                    Visibility(
                      visible: verifyPassInProgress == false,
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
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
    verifyPassInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> resetData = {
      "email": widget.email,
      "OTP": widget.pin,
      "password": _passwordTEController.text.trim()
    };

    NetworkResponse response = await NetworkCaller()
        .postRequest(Urls.recoverResetPassword, body: resetData);
    verifyPassInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      if (mounted) {
        showSnackMessage(context, "Password Reset Success!");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnackMessage(
            context, "Password Reset Not Success, try again!", true);
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

