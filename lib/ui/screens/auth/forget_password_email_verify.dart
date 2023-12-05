import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';
import 'package:task_manager_project/ui/screens/auth/forget_password_pin_verification_screen.dart';
import 'package:task_manager_project/ui/screens/auth/regex_validator.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';

class ForgetPasswordEmailVefiry extends StatefulWidget {
  const ForgetPasswordEmailVefiry({super.key});

  @override
  State<ForgetPasswordEmailVefiry> createState() =>
      _ForgetPasswordEmailVefiryState();
}

class _ForgetPasswordEmailVefiryState extends State<ForgetPasswordEmailVefiry> {
  final TextEditingController _userEmailTEController = TextEditingController();
  bool verifyEmailInProgress = false;
  final GlobalKey<FormState> _verifyEmailFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _verifyEmailFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "A 6 digit verification pin will send to your email address",
                      style: Theme.of(context).textTheme.bodyMedium,
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
                          return "Enter your Email";
                        }
                        if (!isEmailValid(value)) {
                          return "Enter your valid Email";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: verifyEmailInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          verifyEmail();
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    // Text("Forget Password ?"),

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
                                  Navigator.pop(context);
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

  Future<void> verifyEmail() async {
    String email = _userEmailTEController.text.trim();
    if (!_verifyEmailFormKey.currentState!.validate()) {
      return;
    }
    verifyEmailInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response =
        await NetworkCaller().getRequest(Urls.verifyEmailForPin(email));
    verifyEmailInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      if (mounted) {
        showSnackMessage(context, "A 6 digit pin has been sent");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ForgetPasswordPinVerification(
                    email: email,
                  )),
        );
      }
    } else {
      if (mounted) {
        showSnackMessage(context, "Email not found", true);
      }
    }
  }

      @override
  void dispose() {
    _userEmailTEController.dispose();
    super.dispose();
  }
}


