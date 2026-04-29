import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/logincontroller.dart';
import 'package:habit_tracker/controllers/signupcontroller.dart';
import 'package:habit_tracker/habits_screen.dart';
import 'package:habit_tracker/homescreen.dart';
import 'package:habit_tracker/login.dart';
import 'package:habit_tracker/profiles.dart';
import 'package:habit_tracker/signup.dart';

void main() {
  Get.put(Logincontroller());
  Get.put(Signupcontroller());
  // Get.put(SettingsController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Habit Forge',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/habits', page: () => const HabitsScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: const Color(0xFF00D4A0),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4A0),
          secondary: Color(0xFF00D4A0),
          surface: Color(0xFF1A1A2E),
          background: Color(0xFF1A1A2E),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
    );
  }
}
