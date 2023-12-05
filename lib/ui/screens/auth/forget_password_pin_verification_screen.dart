import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';
import 'package:task_manager_project/ui/screens/auth/login_screen.dart';
import 'package:task_manager_project/ui/screens/auth/reset_password_screen.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';

class ForgetPasswordPinVerification extends StatefulWidget {
  const ForgetPasswordPinVerification({super.key, required this.email});
  final String email;

  @override
  State<ForgetPasswordPinVerification> createState() =>
      _ForgetPasswordPinVerificationState();
}

class _ForgetPasswordPinVerificationState
    extends State<ForgetPasswordPinVerification> {
  String pin = "";
  bool verifyPinInProgress = false;
  final GlobalKey<FormState> _pinFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyBackground(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _pinFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "PIN Verification",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "A 6 digit verification pin will send to your email address",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 24,
                    ),

                    PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length != 6) {
                          return "Pin must be 6 digit";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        borderWidth: 0.2,
                        activeFillColor: Colors.white,
                        activeColor: Colors.white,
                        inactiveColor: const Color.fromARGB(255, 202, 244, 203),
                        selectedColor: Colors.green,
                        selectedFillColor: Colors.green,
                        inactiveFillColor: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        debugPrint(v);
                        pin = v;
                      },
                      onChanged: (value) {
                        debugPrint(value);
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        return true;
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: verifyPinInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_pinFormKey.currentState!.validate()) {
                            verifyEmail();
                          }
                        },
                        child: const Text(
                          "Verify",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
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

  Future<void> verifyEmail() async {
    verifyPinInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.verifyPinForReset(widget.email, pin));
    verifyPinInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      if (mounted) {
        showSnackMessage(context, "Pin Verification Success");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                    email: widget.email,
                    pin: pin,
                  )),
        );
      }
    } else {
      if (mounted) {
        showSnackMessage(context, "Pin not match", true);
      }
    }
  }
}
