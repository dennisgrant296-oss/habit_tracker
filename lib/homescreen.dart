import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'habits_screen.dart';
// import 'workout_log_screen.dart';
import 'profiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Dynamic habits data (changes when user checks/unchecks)
  List<Map<String, dynamic>> habits = [
    {
      "name": "Morning Meditation",
      "duration": "15 min",
      "completed": false,
      "icon": Icons.self_improvement,
      "color": Colors.purple,
    },
    {
      "name": "Workout",
      "duration": "45 min",
      "completed": false,
      "icon": Icons.fitness_center,
      "color": Colors.orange,
    },
    {
      "name": "Read",
      "duration": "30 min",
      "completed": false,
      "icon": Icons.menu_book,
      "color": Colors.blue,
    },
    {
      "name": "Drink Water",
      "duration": "8 glasses",
      "completed": false,
      "icon": Icons.water_drop,
      "color": Colors.cyan,
    },
    {
      "name": "Journal",
      "duration": "10 min",
      "completed": false,
      "icon": Icons.edit_note,
      "color": Colors.green,
    },
  ];

  List<Widget> get _screens => [
    HomeContent(habits: habits, onHabitToggled: (index) {}),
    const HabitsScreen(),
    // const WorkoutLogScreen(),
    const ProfileScreen(),
  ];

  void toggleHabit(int index) {
    setState(() {
      habits[index]['completed'] = !habits[index]['completed'];
      _screens[0] = HomeContent(habits: habits, onHabitToggled: toggleHabit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeContent(habits: habits, onHabitToggled: toggleHabit),
          const HabitsScreen(),
          // const WorkoutLogScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: const Color(0xFF00D4A0),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            label: "HABITS",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "PROFILE",
          ),
        ],
      ),
    );
  }
}

// Home Content Widget
class HomeContent extends StatefulWidget {
  final List<Map<String, dynamic>> habits;
  final Function(int) onHabitToggled;

  const HomeContent({
    super.key,
    required this.habits,
    required this.onHabitToggled,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String userName = "Athlete";

  int get completedCount =>
      widget.habits.where((h) => h['completed'] == true).length;
  double get progress =>
      widget.habits.isEmpty ? 0 : completedCount / widget.habits.length;

  String get greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String get motivationMessage {
    if (progress == 0) return "Start your day strong! 💪";
    if (progress < 0.3) return "Great start! Keep going! 🌟";
    if (progress < 0.7) return "You're making progress! 🎯";
    if (progress < 1) return "Almost there! Finish strong! 🔥";
    return "Perfect day! You crushed it! 🏆";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E), // Dark navy
            Color(0xFF16213E), // Deeper navy
            Color(0xFF0F3460), // Dark blue
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Greeting
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF00D4A0),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4A0).withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00D4A0),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFF00D4A0),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Card
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today's Progress",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "$completedCount/${widget.habits.length} habits",
                            style: const TextStyle(
                              color: Color(0xFF00D4A0),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF00D4A0),
                          ),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProgressStat(
                            "${(progress * 100).toInt()}%",
                            "Complete",
                          ),
                          _buildProgressStat("$completedCount", "Done"),
                          _buildProgressStat(
                            "${widget.habits.length - completedCount}",
                            "Left",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Motivation Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4A0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00D4A0).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_emotions_rounded,
                        color: Color(0xFF00D4A0),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          motivationMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Today's Habits Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TODAY'S HABITS",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to habits screen
                        final homeState = context
                            .findAncestorStateOfType<_HomeScreenState>();
                        homeState?.setState(() {
                          homeState._currentIndex = 1;
                        });
                      },
                      child: const Text(
                        "VIEW ALL",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF00D4A0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Habits List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: widget.habits.asMap().entries.map((entry) {
                    int index = entry.key;
                    var habit = entry.value;
                    return _buildHabitCard(
                      habit['name'],
                      habit['duration'],
                      habit['completed'],
                      habit['color'],
                      habit['icon'],
                      index,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 30),

              // Quote of the Day
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        color: Color(0xFF00D4A0),
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getQuoteOfTheDay(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildHabitCard(
    String title,
    String duration,
    bool completed,
    Color color,
    IconData icon,
    int index,
  ) {
    return GestureDetector(
      onTap: () => widget.onHabitToggled(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: completed
                ? [color.withOpacity(0.15), color.withOpacity(0.05)]
                : [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: completed ? color : Colors.white.withOpacity(0.1),
            width: completed ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: () => widget.onHabitToggled(index),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? color : Colors.transparent,
                  border: Border.all(
                    color: completed ? color : Colors.white54,
                    width: 2,
                  ),
                ),
                child: completed
                    ? Icon(Icons.check_rounded, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            // Habit Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            // Habit Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: completed ? Colors.white54 : Colors.white,
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
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
              color: completed ? Colors.white54 : const Color(0xFF00D4A0),
            ),
          ],
        ),
      ),
    );
  }

  String _getQuoteOfTheDay() {
    List<String> quotes = [
      "The secret of getting ahead is getting started.",
      "Small daily improvements are the key to staggering long-term results.",
      "Don't watch the clock; do what it does. Keep going.",
      "Your future self will thank you for the habits you build today.",
      "Discipline is the bridge between goals and accomplishment.",
    ];
    return quotes[DateTime.now().day % quotes.length];
  }
}
