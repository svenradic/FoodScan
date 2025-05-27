import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../common/services/auth_service.dart';
import '../../../common/services/user_nutrition_service.dart';
import '../../../data/models/user_nutrition_goals.dart';

class ProfileViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserNutritionService _nutritionService = UserNutritionService();

  final caloriesController = TextEditingController();
  
  User? get user => _authService.currentUser;

  bool _loading = false;
  bool get isLoading => _loading;

  Future<void> loadGoals() async {
    _loading = true;
    notifyListeners();

    final goals = await _nutritionService.getUserGoals();
    caloriesController.text = goals.dailyCalories.toString();

    _loading = false;
    notifyListeners();
  }

  Future<void> updateGoals() async {
    final calories = int.tryParse(caloriesController.text) ?? 0;
    await _nutritionService.saveUserNutritionGoals(calories);
    await loadGoals();
  }

  Future<void> logout() => _authService.signOut();

  void disposeControllers() {
    caloriesController.dispose();
   
  }
}
