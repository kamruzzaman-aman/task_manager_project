// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/auth_controller.dart';
import 'package:task_manager_project/ui/screens/auth/login_screen.dart';
import 'package:task_manager_project/ui/screens/profile/edit_profile_screen.dart';
import 'package:task_manager_project/ui/screens/task/add_new_task_screen.dart';

import 'base64_image.dart';

AppBar taskAppsBar(context, {enableOnTap = true}) {
  return AppBar(
    toolbarHeight: 70,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.green,
    flexibleSpace: SafeArea(
      child: GetBuilder<AuthController>(
        builder: (authController) {
          return ListTile(
            onTap: () {
              if (enableOnTap) {
                Get.to(() => const EditProfileScreen());
              }
            },
            leading: CircleAvatar(
              // backgroundColor: Colors.transparent,
              radius: 24,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: buildImageWidget(authController.user?.photo),
              ),
            ),
            title: Text(
              fullName(authController.user),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(authController.user?.email ?? " ",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400)),
          );
        },
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          if (enableOnTap) {
            Get.to(() => const AddNewTaskScreen());
          }
        },
        icon: const Icon(Icons.add_task),
        color: Colors.white,
      ),
      IconButton(
        onPressed: () async {
          await AuthController.clearAuthData();
          Get.offAll(() => const LoginScreen());
        },
        icon: const Icon(Icons.output),
        color: Colors.white,
      ),
    ],
  );
}

String fullName(user) {
  return '${user?.firstName ?? ""} ${user?.lastName ?? ""}';
}

//The code you've provided defines a getter named fullName in Dart. A getter is a special method that allows you to access the value of an object's property.
/*
class Person {
  String firstName;
  String lastName;

  Person(this.firstName, this.lastName);

  String get fullName {
    return '$firstName $lastName';
  }
}

void main() {
  var person = Person('John', 'Doe');
  print(person.fullName); // Outputs: John Doe
}

*/
