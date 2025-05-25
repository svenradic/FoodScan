class UserGoals {
  final int dailyCalories;
  final int carbsGoal;
  final int proteinGoal;
  final int fatGoal;
  final bool setupCompleted;

  UserGoals({
    required this.dailyCalories,
    required this.carbsGoal,
    required this.proteinGoal,
    required this.fatGoal,
    this.setupCompleted = true,
  });

  factory UserGoals.fromJson(Map<String, dynamic> json) {
    return UserGoals(
      dailyCalories: json['dailyCalories'] ?? 0,
      carbsGoal: json['carbsGoal'] ?? 0,
      proteinGoal: json['proteinGoal'] ?? 0,
      fatGoal: json['fatGoal'] ?? 0,
      setupCompleted: json['setupCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyCalories': dailyCalories,
      'carbsGoal': carbsGoal,
      'proteinGoal': proteinGoal,
      'fatGoal': fatGoal,
      'setupCompleted': setupCompleted,
    };
  }
}
