import 'package:flutter/material.dart';
import '../../../common/services/user_nutrition_service.dart';

class NutritionSetupViewModel with ChangeNotifier {
  final TextEditingController calorieController = TextEditingController();
  final UserNutritionService _onboardingService = UserNutritionService();

  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> saveGoals() async {
    final calorieInput = int.tryParse(calorieController.text.trim());

    if (calorieInput == null || calorieInput <= 0) {
      _error = "Please enter a valid number";
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      await _onboardingService.saveUserNutritionGoals(calorieInput);
      _error = null;
    } catch (e) {
      _error = "Failed to save data";
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
