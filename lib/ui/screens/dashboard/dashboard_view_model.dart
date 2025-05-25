import 'package:flutter/material.dart';
import 'package:foodscan_app/common/services/user_nutrition_service.dart';

class DashboardViewModel with ChangeNotifier {
  int calorieGoal = 0;
  int consumedCalories = 0;

  int carbs = 0;
  int protein = 0;
  int fat = 0;

  int carbsGoal = 0;
  int proteinGoal = 0;
  int fatGoal = 0;

  bool _loading = false;
  bool get isLoading => _loading;

  /// ✅ Load goals from Firebase using service
  Future<void> loadUserGoals() async {
    _setLoading(true);

    try {
      final goals = await UserNutritionService().getUserGoals();

      calorieGoal = goals.dailyCalories;
      carbsGoal = goals.carbsGoal;
      proteinGoal = goals.proteinGoal;
      fatGoal = goals.fatGoal;

      // Simulate today's consumption (replace with actual tracking later)
      consumedCalories = 1350;
      carbs = 160;
      protein = 50;
      fat = 45;
    } catch (e) {
      // You can log or show an error here if needed
    } finally {
      _setLoading(false);
    }
  }

  double get calorieProgress =>
      calorieGoal > 0 ? consumedCalories / calorieGoal : 0.0;

  double macroProgress(int value, int goal) =>
      goal > 0 ? value / goal : 0.0;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}