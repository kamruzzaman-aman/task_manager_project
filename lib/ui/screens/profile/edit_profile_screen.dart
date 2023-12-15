
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_project/business_logics/controllers/auth_controller.dart';
import 'package:task_manager_project/business_logics/controllers/update_delete_controller.dart';
import 'package:task_manager_project/ui/screens/auth/regex_validator.dart';
import 'package:task_manager_project/ui/widgets/app_bar.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Rx<XFile?> photo = Rx<XFile?>(null);

  final AuthController _authController = Get.find<AuthController>();
  final UpdateDeleteTask _updateController = Get.find<UpdateDeleteTask>();

  @override
  void initState() {
    super.initState();
    _emailTEController.text = _authController.user?.email ?? "";
    _firstNameTEController.text = _authController.user?.firstName ?? "";
    _lastNameTEController.text = _authController.user?.lastName ?? "";
    _mobileTEController.text = _authController.user?.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: taskAppsBar(context, enableOnTap: false),
      body: BodyBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  photoPickerField(),
                  const SizedBox(
                    height: 8,
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
                    height: 8,
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
                    height: 8,
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
                    height: 8,
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
                    height: 8,
                  ),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: "Password (Optional)"),
                    validator: (String? value) {
                      if (value!.isNotEmpty) {
                        if (!isPasswordValid(value)) {
                          return "must be 8-10 including case and special char";
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<UpdateDeleteTask>(
                      builder: (updateProfile) {
                        return Visibility(
                          visible: updateProfile.updateInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              updateProfileScreen();
                            },
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProfileScreen() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await _updateController.updateProfile(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
        _passwordTEController.text.trim(),
        photo.value);
    if (response) {
      if (mounted) {
        showSnackMessage(context, _updateController.updateMessage);
      }
    } else {
      if (mounted) {
        showSnackMessage(context, _updateController.updateMessage);
      }
    }
  }

  Container photoPickerField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BuildBottomSheet(
                      xPhoto: (XFile? getPhoto) {
                        if (getPhoto != null) {
                          photo.value = getPhoto;
                        }
                      },
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Obx(
                  () => Visibility(
                      visible: photo.value == null,
                      replacement: Text(photo.value?.name ?? ""),
                      child: const Text('Select a photo')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

// ignore: must_be_immutable
class BuildBottomSheet extends StatefulWidget {
  BuildBottomSheet({super.key, required this.xPhoto});

  Function xPhoto;

  @override
  State<BuildBottomSheet> createState() => _BuildBottomSheetState();
}

class _BuildBottomSheetState extends State<BuildBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () async {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.camera, imageQuality: 50);
                  widget.xPhoto(image);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.green),
                    ),
                    child: const Icon(
                      Icons.camera,
                      color: Colors.green,
                    )),
              ),
              IconButton(
                onPressed: () async {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 50);
                  widget.xPhoto(image);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.green),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.green,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
