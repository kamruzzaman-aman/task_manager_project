import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/bindings/binding.dart';
import 'package:task_manager_project/ui/screens/onboarding/splash_screen.dart';

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black38,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
              ),
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          hintStyle: TextStyle(color: Colors.black38),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        // primaryColor: Colors.blue,
        // primarySwatch: Colors.green,
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(double.infinity, 40)),
              backgroundColor: MaterialStatePropertyAll(Color(0xFF21BF73)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                // side: BorderSide(color: Colors.red),
              )),
              foregroundColor: MaterialStatePropertyAll(Colors.white)),
        ),

        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Colors.white
        // ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      initialBinding: ControllerBinder(),
    );
  }
}
