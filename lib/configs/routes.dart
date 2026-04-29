import 'package:get/get.dart';
import '../login.dart';
import '../signup.dart';
import '../homescreen.dart';
import '../habits_screen.dart';
import '../profiles.dart';

var routes = [
  GetPage(name: "/login", page: () => const LoginScreen()),
  GetPage(name: "/signup", page: () => const SignupScreen()),
  GetPage(name: "/home", page: () => const HomeScreen()),
  GetPage(name: "/habits", page: () => const HabitsScreen()),
  GetPage(name: "/profile", page: () => const ProfileScreen()),
];
