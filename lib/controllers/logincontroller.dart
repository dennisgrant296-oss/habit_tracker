import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Logincontroller extends GetxController {
  var passwordVisible = false.obs;
  var isLoading = false.obs;

  var userId = 0.obs;
  var userFullName = "".obs;
  var userEmail = "".obs;
  var userUsername = "".obs;

  Future<bool> login(String username, String password) async {
    isLoading.value = true;

    try {
      var url = Uri.parse("http://localhost/flutter_habit_tracker/login.php");

      var response = await http.post(
        url,
        body: {'username': username, 'password': password},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      var data = jsonDecode(response.body);

      if (data['success'] == 1) {
        userId.value = int.parse(data['user']['id'].toString());
        userFullName.value = data['user']['full_name'];
        userEmail.value = data['user']['email'];
        userUsername.value = data['user']['username'];

        Get.snackbar("Success", "Welcome ${data['user']['full_name']}!");
        isLoading.value = false;
        return true;
      } else {
        Get.snackbar("Login Failed", data['message']);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Connection failed: $e");
      isLoading.value = false;
      return false;
    }
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }
}
