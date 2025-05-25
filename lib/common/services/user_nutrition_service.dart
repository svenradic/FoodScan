import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/user_nutrition_goals.dart';

class UserNutritionService {
  Future<void> saveUserNutritionGoals(int calories) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final carbs = ((calories * 0.4) / 4).round();   // 40% of calories / 4 kcal/g
    final protein = ((calories * 0.3) / 4).round(); // 30% / 4 kcal/g
    final fat = ((calories * 0.3) / 9).round();     // 30% / 9 kcal/g

    // Assuming you have a UserNutritionGoals model with a toJson() method
    final userNutritionGoals = UserGoals(
      dailyCalories: calories,
      carbsGoal: carbs,
      proteinGoal: protein,
      fatGoal: fat,
      setupCompleted: true,
    );

    await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set(userNutritionGoals.toJson(), SetOptions(merge: true));
  }

    Future<bool> isSetupCompleted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.exists && (doc.data()?['setupCompleted'] == true);
  }

  Future<UserGoals> getUserGoals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      throw Exception("User goals not found");
    }

    return UserGoals.fromJson(doc.data()!);
  }
}