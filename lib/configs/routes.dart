import 'package:get/get.dart';
import '../splash_screen.dart';
import '../login.dart';
import '../signup.dart';
import '../homescreen.dart';
import '../habits_screen.dart';
import '../stats_screen.dart';
import '../profiles.dart';

var routes = [
  GetPage(name: "/", page: () => const SplashScreen()),
  GetPage(name: "/login", page: () => const LoginScreen()),
  GetPage(name: "/signup", page: () => const SignupScreen()),
  GetPage(name: "/home", page: () => const HomeScreen()),
  GetPage(name: "/habits", page: () => const HabitsScreen()),
  GetPage(name: "/stats", page: () => const StatsScreen()),
  GetPage(name: "/profile", page: () => const ProfileScreen()),
];
