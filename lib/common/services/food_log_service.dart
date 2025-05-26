import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../data/models/nutrition.dart';
import 'auth_service.dart';
import '../../data/models/daily_intake.dart';

class FoodLogService {
   Future<DailyIntake> getOrCreateTodayIntake() async {
    final user = AuthService().currentUser;
    if (user == null) throw Exception("User not logged in");

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('intake')
        .doc(today);

    final doc = await docRef.get();

    if (!doc.exists) {
      final defaultData = {
        'totalKcal': 0,
        'totalCarbs': 0,
        'totalProtein': 0,
        'totalFat': 0,
      };
      await docRef.set(defaultData);
      return DailyIntake.fromJson(defaultData);
    }

    return DailyIntake.fromJson(doc.data()!);
  }

  Future<void> logFood({
    required String name,
    required Nutrition nutrition,
  }) async {
    final user = AuthService().currentUser;
    if (user == null) throw Exception("User not logged in");

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('intake')
        .doc(today);

    final kcal = int.tryParse(nutrition.energy ?? '0') ?? 0;
    final carbs = int.tryParse(nutrition.carbohydrates ?? '0') ?? 0;
    final protein = int.tryParse(nutrition.protein ?? '0') ?? 0;
    final fat = int.tryParse(nutrition.fat ?? '0') ?? 0;

    final foodData = {
      'name': name,
      'kcal': kcal,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'scannedAt': FieldValue.serverTimestamp(),
    };

    await docRef.collection('foods').add(foodData);

    await docRef.set({
      'totalKcal': FieldValue.increment(kcal),
      'totalCarbs': FieldValue.increment(carbs),
      'totalProtein': FieldValue.increment(protein),
      'totalFat': FieldValue.increment(fat),
    }, SetOptions(merge: true));
  }
}
