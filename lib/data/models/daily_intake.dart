class DailyIntake {
  final int totalKcal;
  final int totalCarbs;
  final int totalProtein;
  final int totalFat;

  DailyIntake({
    required this.totalKcal,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
  });

  factory DailyIntake.fromJson(Map<String, dynamic> json) => DailyIntake(
        totalKcal: json['totalKcal'] ?? 0,
        totalCarbs: json['totalCarbs'] ?? 0,
        totalProtein: json['totalProtein'] ?? 0,
        totalFat: json['totalFat'] ?? 0,
      );
}