import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signupcontroller extends GetxController {
  var passwordVisible = false.obs;
  var isLoading = false.obs;

  Future<bool> signup(
    String fullName,
    String email,
    String password,
    String username,
  ) async {
    isLoading.value = true;

    try {
      var url = Uri.parse("http://localhost/flutter_habit_tracker/create.php");

      var response = await http.post(
        url,
        body: {
          'full_name': fullName,
          'email': email,
          'password': password,
          'username': username,
        },
      );

      var data = jsonDecode(response.body);

      if (data['success'] == 1) {
        Get.snackbar("Success", "Account created! Please login.");
        return true;
      } else {
        Get.snackbar("Signup Failed", data['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Connection failed: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }
}
