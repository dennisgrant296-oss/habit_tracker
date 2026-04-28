import 'package:get/get.dart';

class SettingsController extends GetxController {
  var notificationsEnabled = true.obs;
  var selectedLanguage = 'English'.obs;

  void setNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void setLanguage(String value) {
    selectedLanguage.value = value;
  }
}
