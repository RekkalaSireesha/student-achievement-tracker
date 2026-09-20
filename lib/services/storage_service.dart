import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/achievement.dart';
import '../models/student_profile.dart';

class StorageService {
  static const String achievementsKey = 'achievements';
  static const String profileKey = 'student_profile';

  // ============================================================
  // ACHIEVEMENT STORAGE
  // ============================================================

  static Future<void> saveAchievements(
    List<Achievement> achievements,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> achievementList =
        achievements.map((achievement) {
      return jsonEncode({
        'title': achievement.title,
        'category': achievement.category,
        'level': achievement.level,
        'date': achievement.date.toIso8601String(),
        'description': achievement.description,
      });
    }).toList();

    await prefs.setStringList(
      achievementsKey,
      achievementList,
    );
  }

  static Future<List<Achievement>> loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? savedData =
        prefs.getStringList(achievementsKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    return savedData.map((item) {
      final Map<String, dynamic> data =
          jsonDecode(item);

      return Achievement(
        title: data['title'] as String,
        category: data['category'] as String,
        level: data['level'] as String,
        date: DateTime.parse(
          data['date'] as String,
        ),
        description:
            data['description'] as String,
      );
    }).toList();
  }

  // ============================================================
  // PROFILE STORAGE
  // ============================================================

  static Future<void> saveProfile(
    StudentProfile profile,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final String profileData = jsonEncode({
      'name': profile.name,
      'rollNumber': profile.rollNumber,
      'department': profile.department,
      'year': profile.year,
    });

    await prefs.setString(
      profileKey,
      profileData,
    );
  }

  static Future<StudentProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final String? savedProfile =
        prefs.getString(profileKey);

    if (savedProfile == null) {
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(savedProfile);

    return StudentProfile(
      name: data['name'] as String,
      rollNumber: data['rollNumber'] as String,
      department: data['department'] as String,
      year: data['year'] as String,
    );
  }
}