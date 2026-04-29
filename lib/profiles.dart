import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User data
  String userName = "Alex Johnson";
  String userEmail = "alex@habitforge.com";
  String userAvatar = "AJ";
  String userBio = "Building better habits, one day at a time. 💪";
  DateTime joinDate = DateTime(2024, 1, 15);

  // User statistics (calculated from habits)
  int totalHabits = 12;
  int currentStreak = 7;
  int bestStreak = 21;
  int totalCompletions = 156;
  int totalMinutes = 3240; // 54 hours

  // App settings
  bool notificationsEnabled = true;
  bool reminderEnabled = true;
  String selectedLanguage = "English";
  String reminderTime = "09:00 AM";

  // Achievement badges
  List<Map<String, dynamic>> badges = [
    {
      "icon": Icons.emoji_events,
      "name": "7 Day Streak",
      "color": Colors.amber,
      "earned": true,
      "date": "Jan 20, 2024",
    },
    {
      "icon": Icons.local_fire_department,
      "name": "21 Day Streak",
      "color": Colors.orange,
      "earned": true,
      "date": "Feb 15, 2024",
    },
    {
      "icon": Icons.fitness_center,
      "name": "50 Workouts",
      "color": Colors.green,
      "earned": false,
      "progress": 0.75,
    },
    {
      "icon": Icons.water_drop,
      "name": "Hydration Hero",
      "color": Colors.cyan,
      "earned": true,
      "date": "Mar 10, 2024",
    },
    {
      "icon": Icons.menu_book,
      "name": "Bookworm",
      "color": Colors.purple,
      "earned": false,
      "progress": 0.4,
    },
    {
      "icon": Icons.self_improvement,
      "name": "Zen Master",
      "color": Colors.indigo,
      "earned": false,
      "progress": 0.6,
    },
    {
      "icon": Icons.directions_run,
      "name": "Marathon",
      "color": Colors.red,
      "earned": false,
      "progress": 0.3,
    },
    {
      "icon": Icons.spa,
      "name": "Mindful Month",
      "color": Colors.teal,
      "earned": true,
      "date": "Apr 5, 2024",
    },
  ];

  Future<void> _updateProfileInDatabase(
    String fullName,
    String email,
    String bio,
  ) async {
    int userId =
        1; // Replace with actual logged-in user ID from your Logincontroller

    try {
      var url = Uri.parse(
        "http://localhost/flutter_habit_tracker/update_profile.php",
      );

      var response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'full_name': fullName,
          'email': email,
          'bio': bio,
        },
      );

      var data = jsonDecode(response.body);

      if (data['success'] == 1) {
        setState(() {
          userName = fullName;
          userEmail = email;
          userBio = bio;
          userAvatar = fullName.substring(0, 2).toUpperCase();
        });

        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Update failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Update error: $e");
      Get.snackbar(
        "Error",
        "Connection failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showEditProfileDialog() {
    TextEditingController nameController = TextEditingController(
      text: userName,
    );
    TextEditingController emailController = TextEditingController(
      text: userEmail,
    );
    TextEditingController bioController = TextEditingController(text: userBio);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF00D4A0)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  labelStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF00D4A0)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: bioController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Bio",
                  labelStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description, color: Color(0xFF00D4A0)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _updateProfileInDatabase(
                        nameController.text,
                        emailController.text,
                        bioController.text,
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D4A0),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("SAVE CHANGES"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReminderTimeDialog() {
    List<String> timeSlots = [
      "08:00 AM",
      "09:00 AM",
      "10:00 AM",
      "11:00 AM",
      "12:00 PM",
      "01:00 PM",
      "02:00 PM",
      "03:00 PM",
      "04:00 PM",
      "05:00 PM",
      "06:00 PM",
      "07:00 PM",
    ];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Reminder Time",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              ...timeSlots.map((time) {
                bool isSelected = reminderTime == time;
                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? const Color(0xFF00D4A0)
                        : Colors.white54,
                  ),
                  title: Text(
                    time,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF00D4A0)
                          : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      reminderTime = time;
                    });
                    Get.back();
                    _showSuccessSnackbar("Reminder time set to $time");
                  },
                );
              }).toList(),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    List<String> languages = [
      "English",
      "Spanish",
      "French",
      "German",
      "Portuguese",
      "Japanese",
    ];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Language",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              ...languages.map((lang) {
                bool isSelected = selectedLanguage == lang;
                return ListTile(
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? const Color(0xFF00D4A0)
                        : Colors.white54,
                    size: 20,
                  ),
                  title: Text(
                    lang,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF00D4A0)
                          : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedLanguage = lang;
                    });
                    Get.back();
                    _showSuccessSnackbar("Language changed to $lang");
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDataExportDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Export Data", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Export your habit data as CSV?",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: const Color(0xFF16213E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showSuccessSnackbar("Data exported successfully!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4A0),
              foregroundColor: Colors.black,
            ),
            child: const Text("EXPORT"),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 350,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Your Statistics",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildStatRow(
                "Total Habits",
                "$totalHabits",
                Icons.checklist_rounded,
              ),
              _buildStatRow(
                "Current Streak",
                "$currentStreak days",
                Icons.local_fire_department,
              ),
              _buildStatRow(
                "Best Streak",
                "$bestStreak days",
                Icons.emoji_events,
              ),
              _buildStatRow(
                "Total Completions",
                "$totalCompletions",
                Icons.check_circle,
              ),
              _buildStatRow(
                "Total Minutes",
                "${totalMinutes ~/ 60} hrs",
                Icons.timer,
              ),
              _buildStatRow("Member Since", _formatDate(joinDate), Icons.cake),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D4A0),
                  foregroundColor: Colors.black,
                ),
                child: const Text("CLOSE"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00D4A0), size: 22),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: const Color(0xFF00D4A0),
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.year}";
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: const Color(0xFF16213E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed("/login");
              Get.snackbar(
                "Logged Out",
                "Come back soon!",
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("LOGOUT"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "PROFILE",
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.analytics_rounded),
              onPressed: _showStatisticsDialog,
              color: const Color(0xFF00D4A0),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showEditProfileDialog,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(
                          0xFF00D4A0,
                        ).withOpacity(0.2),
                        child: Text(
                          userAvatar,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00D4A0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userBio,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showEditProfileDialog,
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: const Text("EDIT"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D4A0),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _showStatisticsDialog,
                          icon: const Icon(Icons.analytics_rounded, size: 18),
                          label: const Text("STATS"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00D4A0),
                            side: const BorderSide(color: Color(0xFF00D4A0)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Stats Cards
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildStatCard(
                      "HABITS",
                      "$totalHabits",
                      Icons.checklist_rounded,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      "STREAK",
                      "$currentStreak",
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      "BEST",
                      "$bestStreak",
                      Icons.emoji_events,
                      Colors.amber,
                    ),
                    _buildStatCard(
                      "DONE",
                      "$totalCompletions",
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Achievements Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ACHIEVEMENTS",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2,
                            color: Color(0xFF00D4A0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${badges.where((b) => b['earned'] == true).length}/${badges.length}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: badges.length,
                        itemBuilder: (context, index) {
                          var badge = badges[index];
                          bool earned = badge['earned'] == true;
                          return Container(
                            width: 85,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: earned
                                  ? (badge['color'] as Color).withOpacity(0.15)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: earned
                                    ? badge['color']
                                    : Colors.white.withOpacity(0.1),
                                width: earned ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  badge['icon'],
                                  color: earned
                                      ? badge['color']
                                      : Colors.white24,
                                  size: 30,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  badge['name'],
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: earned
                                        ? Colors.white
                                        : Colors.white38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (!earned && badge['progress'] != null)
                                  const SizedBox(height: 4),
                                if (!earned && badge['progress'] != null)
                                  LinearProgressIndicator(
                                    value: badge['progress'],
                                    backgroundColor: Colors.white24,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF00D4A0),
                                        ),
                                    minHeight: 2,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "SETTINGS",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2,
                        color: Color(0xFF00D4A0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.notifications_rounded,
                      title: "Notifications",
                      trailing: Switch(
                        value: notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            notificationsEnabled = value;
                          });
                          _showSuccessSnackbar(
                            value
                                ? "Notifications enabled"
                                : "Notifications disabled",
                          );
                        },
                        activeColor: const Color(0xFF00D4A0),
                      ),
                    ),
                    _buildSettingsTile(
                      icon: Icons.alarm_rounded,
                      title: "Daily Reminder",
                      subtitle: reminderTime,
                      trailing: Switch(
                        value: reminderEnabled,
                        onChanged: (value) {
                          setState(() {
                            reminderEnabled = value;
                          });
                          if (value) {
                            _showReminderTimeDialog();
                          } else {
                            _showSuccessSnackbar("Reminders disabled");
                          }
                        },
                        activeColor: const Color(0xFF00D4A0),
                      ),
                    ),
                    _buildSettingsTile(
                      icon: Icons.language_rounded,
                      title: "Language",
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedLanguage,
                            style: const TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                      onTap: _showLanguageDialog,
                    ),
                    _buildSettingsTile(
                      icon: Icons.download_rounded,
                      title: "Export Data",
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: Colors.white54,
                      ),
                      onTap: _showDataExportDialog,
                    ),
                    _buildSettingsTile(
                      icon: Icons.info_rounded,
                      title: "About",
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: Colors.white54,
                      ),
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text(
                              "About Habit Forge",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.bolt_rounded,
                                  size: 50,
                                  color: Color(0xFF00D4A0),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Version 2.0.0",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Build better habits, one day at a time.",
                                  style: TextStyle(color: Colors.white54),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "© 2024 Habit Forge",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF16213E),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  "Close",
                                  style: TextStyle(color: Color(0xFF00D4A0)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Button
              Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _confirmLogout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text("LOG OUT"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF00D4A0), size: 24),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
