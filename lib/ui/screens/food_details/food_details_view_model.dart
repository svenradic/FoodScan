import 'package:flutter/material.dart';
import '../../../data/models/nutrition.dart';
import '../../../common/services/food_log_service.dart';
import '../dashboard_screen.dart';

class FoodDetailsViewModel with ChangeNotifier {
  final String productName;
  final Nutrition nutrition;

  int grams = 100; // default per 100g

  FoodDetailsViewModel({required this.productName, required this.nutrition});

  void updateGrams(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed > 0) {
      grams = parsed;
      notifyListeners();
    } else {
      grams = 100; // reset to default if invalid input
      notifyListeners();
    }
  }

  double _scale(String? value) {
    final raw = double.tryParse(value ?? '0') ?? 0.0;
    return (raw * grams) / 100;
  }

  int get kcal => _scale(nutrition.energy).round();
  int get carbs => _scale(nutrition.carbohydrates).round();
  int get protein => _scale(nutrition.protein).round();
  int get fat => _scale(nutrition.fat).round();

  double get kcalProgress => (kcal / 2000).clamp(0.0, 1.0);
  double macroProgress(int value) => (value / 100).clamp(0.0, 1.0);

  Future<void> logFood(BuildContext context, String successMessage, String failureMessage) async {
    try {
      final scaledNutrition = Nutrition(
        energy: kcal.toString(),
        carbohydrates: carbs.toString(),
        protein: protein.toString(),
        fat: fat.toString(),
        sugars: nutrition.sugars,
        saturatedFat: nutrition.saturatedFat,
        salt: nutrition.salt,
      );

      await FoodLogService().logFood(
        name: productName,
        nutrition: scaledNutrition,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMessage)),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar( SnackBar(content: Text(failureMessage)));
      }
    }
  }
}
