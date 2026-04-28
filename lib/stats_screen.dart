import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // This would connect to your actual habits data
  // For now, using sample data that you can explain to your lecturer

  // In a real app, this data would come from your habits screen
  List<Map<String, dynamic>> habits = [
    {"name": "Morning Meditation", "completed": true},
    {"name": "Workout", "completed": true},
    {"name": "Read", "completed": false},
    {"name": "Drink Water", "completed": true},
    {"name": "Journal", "completed": false},
  ];

  // Weekly data - in real app, this would track daily completions
  // You can explain that this simulates 7 days of habit tracking
  List<Map<String, dynamic>> weeklyData = [
    {"day": "Mon", "completed": 3, "total": 5},
    {"day": "Tue", "completed": 4, "total": 5},
    {"day": "Wed", "completed": 2, "total": 5},
    {"day": "Thu", "completed": 5, "total": 5},
    {"day": "Fri", "completed": 3, "total": 5},
    {"day": "Sat", "completed": 4, "total": 5},
    {"day": "Sun", "completed": 2, "total": 5},
  ];

  // These are CALCULATED values - they change automatically when habits change
  int get totalHabits => habits.length;
  int get completedToday => habits.where((h) => h['completed'] == true).length;
  double get completionRate =>
      totalHabits == 0 ? 0 : (completedToday / totalHabits) * 100;
  int get currentStreak => _calculateStreak();

  // This function calculates streak based on consecutive completions
  int _calculateStreak() {
    int streak = 0;
    for (var habit in habits) {
      if (habit['completed'] == true) {
        streak++;
      } else {
        break; // Streak breaks when a habit is incomplete
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2A3A), Color(0xFF0D1B2A)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("STATISTICS"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Today's Stats Card - Shows REAL data
              _buildSectionHeader("TODAY'S STATS"),
              const SizedBox(height: 10),
              _buildTodayStatsCard(),

              const SizedBox(height: 20),

              // Streak Cards
              _buildSectionHeader("YOUR STREAK"),
              const SizedBox(height: 10),
              _buildStreakCard(),

              const SizedBox(height: 20),

              // Weekly Progress Chart
              _buildSectionHeader("WEEKLY PROGRESS"),
              const SizedBox(height: 10),
              _buildWeeklyChart(),

              const SizedBox(height: 20),

              // Daily Habit Breakdown
              _buildSectionHeader("TODAY'S HABITS BREAKDOWN"),
              const SizedBox(height: 10),
              _buildHabitBreakdown(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 2,
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTodayStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.greenAccent.withOpacity(0.2),
            Colors.greenAccent.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                "$completedToday/$totalHabits",
                "COMPLETED",
                Colors.greenAccent,
              ),
              _buildStatItem("${completionRate.toInt()}%", "RATE", Colors.blue),
              _buildStatItem("$currentStreak", "STREAK", Colors.orange),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: completionRate / 100,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 10),
          Text(
            "${completionRate.toInt()}% of today's habits completed",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: color.withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CURRENT STREAK",
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
                Text(
                  "$currentStreak day${currentStreak != 1 ? 's' : ''}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentStreak == 0
                      ? "Complete a habit to start your streak!"
                      : "Keep going! Don't break your streak!",
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weeklyData.map((day) {
              return _buildDayBar(
                day['day'] as String,
                day['completed'] as int,
                day['total'] as int,
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.greenAccent, "Completed Habits"),
              const SizedBox(width: 20),
              _buildLegendItem(Colors.white24, "Remaining Habits"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayBar(String day, int completed, int total) {
    double percentage = total == 0 ? 0 : completed / total;
    return Column(
      children: [
        Text(day, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 35,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100 * percentage,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$completed/$total",
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildHabitBreakdown() {
    return Column(
      children: habits.map((habit) {
        bool isCompleted = habit['completed'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: isCompleted
                ? Border.all(color: Colors.greenAccent, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? Colors.greenAccent : Colors.white54,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  habit['name'] as String,
                  style: TextStyle(
                    color: isCompleted ? Colors.white : Colors.white54,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Text(
                isCompleted ? "DONE" : "PENDING",
                style: TextStyle(
                  fontSize: 11,
                  color: isCompleted ? Colors.greenAccent : Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
