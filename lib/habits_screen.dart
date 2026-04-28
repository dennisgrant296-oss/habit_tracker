import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  // Habit categories with their own lists
  List<Map<String, dynamic>> dailyHabits = [
    {
      "id": 1,
      "name": "Morning Meditation",
      "duration": "15 min",
      "completed": false,
      "icon": Icons.self_improvement,
      "color": Colors.purple,
      "streak": 5,
    },
    {
      "id": 2,
      "name": "Workout",
      "duration": "45 min",
      "completed": false,
      "icon": Icons.fitness_center,
      "color": Colors.orange,
      "streak": 3,
    },
    {
      "id": 3,
      "name": "Read",
      "duration": "30 min",
      "completed": false,
      "icon": Icons.menu_book,
      "color": Colors.blue,
      "streak": 7,
    },
    {
      "id": 4,
      "name": "Drink Water",
      "duration": "8 glasses",
      "completed": false,
      "icon": Icons.water_drop,
      "color": Colors.cyan,
      "streak": 12,
    },
    {
      "id": 5,
      "name": "Journal",
      "duration": "10 min",
      "completed": false,
      "icon": Icons.edit_note,
      "color": Colors.green,
      "streak": 4,
    },
  ];

  List<Map<String, dynamic>> weeklyHabits = [
    {
      "id": 6,
      "name": "Meal Prep",
      "duration": "2 hours",
      "completed": false,
      "icon": Icons.restaurant,
      "color": Colors.deepOrange,
      "streak": 2,
    },
    {
      "id": 7,
      "name": "Budget Review",
      "duration": "30 min",
      "completed": false,
      "icon": Icons.attach_money,
      "color": Colors.yellow,
      "streak": 1,
    },
  ];

  String _selectedCategory = "Daily";
  final List<String> _categories = ["Daily", "Weekly", "All"];

  int get totalHabits => _getCurrentHabits().length;
  int get completedToday =>
      _getCurrentHabits().where((h) => h['completed'] == true).length;
  double get completionRate =>
      totalHabits == 0 ? 0 : (completedToday / totalHabits) * 100;
  int get totalStreak =>
      _getCurrentHabits().fold(0, (sum, h) => sum + (h['streak'] as int));

  List<Map<String, dynamic>> _getCurrentHabits() {
    switch (_selectedCategory) {
      case "Daily":
        return dailyHabits;
      case "Weekly":
        return weeklyHabits;
      case "All":
        return [...dailyHabits, ...weeklyHabits];
      default:
        return dailyHabits;
    }
  }

  void _toggleHabit(int id) {
    setState(() {
      var habitList = _getCurrentHabits();
      var index = habitList.indexWhere((h) => h['id'] == id);
      if (index != -1) {
        bool newStatus = !habitList[index]['completed'];
        habitList[index]['completed'] = newStatus;

        if (newStatus) {
          habitList[index]['streak'] = (habitList[index]['streak'] as int) + 1;
          Get.snackbar(
            "🎉 Great Job! 🎉",
            "${habitList[index]['name']} completed!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
          );
        } else {
          habitList[index]['streak'] = 0;
          Get.snackbar(
            "⚠️ Habit Reset",
            "${habitList[index]['name']} marked incomplete",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
          );
        }
        _syncHabitLists();
      }
    });
  }

  void _syncHabitLists() {
    for (var habit in dailyHabits) {
      var updated = _getCurrentHabits().firstWhere(
        (h) => h['id'] == habit['id'],
        orElse: () => habit,
      );
      habit['completed'] = updated['completed'];
      habit['streak'] = updated['streak'];
    }
    for (var habit in weeklyHabits) {
      var updated = _getCurrentHabits().firstWhere(
        (h) => h['id'] == habit['id'],
        orElse: () => habit,
      );
      habit['completed'] = updated['completed'];
      habit['streak'] = updated['streak'];
    }
  }

  void _addHabit() {
    TextEditingController nameController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    String selectedCategory = "Daily";

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Container(
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
                    "Create New Habit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Habit Name",
                      labelStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.fitness_center,
                        color: Color(0xFF00D4A0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: durationController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Duration",
                      labelStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer, color: Color(0xFF00D4A0)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField(
                    value: selectedCategory,
                    dropdownColor: const Color(0xFF16213E),
                    style: const TextStyle(color: Colors.white),
                    items: ["Daily", "Weekly"].map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedCategory = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Category",
                      labelStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.category,
                        color: Color(0xFF00D4A0),
                      ),
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
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              durationController.text.isNotEmpty) {
                            int newId = DateTime.now().millisecondsSinceEpoch;
                            Map<String, dynamic> newHabit = {
                              "id": newId,
                              "name": nameController.text,
                              "duration": durationController.text,
                              "completed": false,
                              "icon": Icons.fitness_center,
                              "color": Colors.green,
                              "streak": 0,
                            };
                            setState(() {
                              if (selectedCategory == "Daily") {
                                dailyHabits.add(newHabit);
                              } else {
                                weeklyHabits.add(newHabit);
                              }
                            });
                            Get.back();
                            Get.snackbar(
                              "Success",
                              "New habit created!",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please fill all fields",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D4A0),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("CREATE"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showHabitDetails(Map<String, dynamic> habit) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (habit['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        habit['duration'],
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white24),
            const SizedBox(height: 10),
            _buildDetailRow(
              Icons.local_fire_department,
              "Current Streak",
              "${habit['streak']} days",
              Colors.orange,
            ),
            _buildDetailRow(
              Icons.emoji_events,
              "Best Streak",
              "${habit['streak']} days",
              Colors.amber,
            ),
            _buildDetailRow(
              Icons.check_circle,
              "Status",
              habit['completed'] ? "Completed" : "Pending",
              habit['completed'] ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _toggleHabit(habit['id']);
                    },
                    icon: Icon(
                      habit['completed'] ? Icons.refresh : Icons.check,
                    ),
                    label: Text(habit['completed'] ? "UNDO" : "MARK COMPLETE"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: habit['completed']
                          ? Colors.orange
                          : const Color(0xFF00D4A0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentHabits = _getCurrentHabits();

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
            "MY HABITS",
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
              icon: const Icon(Icons.add_rounded),
              onPressed: _addHabit,
              color: const Color(0xFF00D4A0),
            ),
          ],
        ),
        body: Column(
          children: [
            // Category Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _categories.map((category) {
                  bool isSelected = _selectedCategory == category;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00D4A0).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: isSelected
                              ? Border.all(color: const Color(0xFF00D4A0))
                              : null,
                        ),
                        child: Text(
                          category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF00D4A0)
                                : Colors.white54,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Stats Summary
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      "${totalHabits}",
                      "HABITS",
                      Icons.checklist_rounded,
                    ),
                    _buildStatItem(
                      "$completedToday",
                      "DONE",
                      Icons.check_circle_rounded,
                    ),
                    _buildStatItem(
                      "${completionRate.toInt()}%",
                      "RATE",
                      Icons.trending_up_rounded,
                    ),
                    _buildStatItem(
                      "$totalStreak",
                      "STREAK",
                      Icons.local_fire_department,
                    ),
                  ],
                ),
              ),
            ),

            // Habits List
            Expanded(
              child: currentHabits.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.checklist_rounded,
                            size: 60,
                            color: Colors.white24,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No habits in this category",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Tap the + button to add a habit",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: currentHabits.length,
                      itemBuilder: (context, index) {
                        var habit = currentHabits[index];
                        return GestureDetector(
                          onTap: () => _showHabitDetails(habit),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: habit['completed']
                                    ? [
                                        (habit['color'] as Color).withOpacity(
                                          0.15,
                                        ),
                                        (habit['color'] as Color).withOpacity(
                                          0.05,
                                        ),
                                      ]
                                    : [
                                        Colors.white.withOpacity(0.05),
                                        Colors.white.withOpacity(0.02),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: habit['completed']
                                    ? habit['color']
                                    : Colors.white.withOpacity(0.1),
                                width: habit['completed'] ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Checkbox
                                GestureDetector(
                                  onTap: () => _toggleHabit(habit['id']),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: habit['completed']
                                          ? habit['color']
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: habit['completed']
                                            ? habit['color']
                                            : Colors.white54,
                                        width: 2,
                                      ),
                                    ),
                                    child: habit['completed']
                                        ? Icon(
                                            Icons.check_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Habit Icon
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (habit['color'] as Color)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    habit['icon'],
                                    color: habit['color'],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Habit Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        habit['name'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: habit['completed']
                                              ? Colors.white54
                                              : Colors.white,
                                          decoration: habit['completed']
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 12,
                                            color: Colors.white54,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            habit['duration'],
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white54,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.local_fire_department,
                                            size: 12,
                                            color: Colors.orange,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${habit['streak']} days",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Arrow
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: habit['completed']
                                      ? Colors.white54
                                      : const Color(0xFF00D4A0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00D4A0), size: 22),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white54)),
      ],
    );
  }
}
