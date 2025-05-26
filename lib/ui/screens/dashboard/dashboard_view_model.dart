import 'package:flutter/material.dart';
import 'package:foodscan_app/common/services/food_log_service.dart';
import 'package:foodscan_app/common/services/user_nutrition_service.dart';
import '../../../data/models/daily_intake.dart';

class DashboardViewModel with ChangeNotifier {
  final UserNutritionService _userNutritionService = UserNutritionService();
  final FoodLogService _foodLogService = FoodLogService();
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

  Future<void> loadUserGoals() async {
    print('[DashboardViewModel] Loading user goals...');
    _setLoading(true);

    try {
      final goals = await _userNutritionService.getUserGoals();
      final DailyIntake intake = await _foodLogService.getOrCreateTodayIntake();

      print('[DashboardViewModel] Goals and intake loaded');

      calorieGoal = goals.dailyCalories;
      carbsGoal = goals.carbsGoal;
      proteinGoal = goals.proteinGoal;
      fatGoal = goals.fatGoal;

      consumedCalories = intake.totalKcal ?? 0;
      carbs = intake.totalCarbs ?? 0;
      protein = intake.totalProtein ?? 0;
      fat = intake.totalFat ?? 0;
    } catch (e) {
      print('[DashboardViewModel] Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  double get calorieProgress =>
      calorieGoal > 0 ? consumedCalories / calorieGoal : 0.0;

  double macroProgress(int value, int goal) => goal > 0 ? value / goal : 0.0;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
