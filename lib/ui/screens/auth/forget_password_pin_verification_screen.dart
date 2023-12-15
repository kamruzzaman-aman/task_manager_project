import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_project/business_logics/controllers/verify_controller.dart';
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
  final GlobalKey<FormState> _pinFormKey = GlobalKey<FormState>();

  final EmailPassVerifyController _emailPassVerifyController =
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
                    GetBuilder<EmailPassVerifyController>(
                        builder: (emailPassVerify) {
                      return Visibility(
                        visible: emailPassVerify.verifyPinInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_pinFormKey.currentState!.validate()) {
                              verifyPin();
                            }
                          },
                          child: const Text(
                            "Verify",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }),
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
                                  Get.to(() => const LoginScreen());
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

  Future<void> verifyPin() async {
    final response =
        await _emailPassVerifyController.verifyPin(widget.email, pin);

    if (response) {
      if (mounted) {
        showSnackMessage(context, _emailPassVerifyController.pinVerifyMessage);
      }
      Get.off(() => ResetPasswordScreen(
            email: widget.email,
            pin: pin,
          ));
    } else {
      if (mounted) {
        showSnackMessage(
            context, _emailPassVerifyController.pinVerifyMessage, true);
      }
    }
  }
}
