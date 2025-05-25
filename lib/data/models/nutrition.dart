class Nutrition {
  final String? energy;
  final String? carbohydrates;
  final String? sugars;
  final String? fat;
  final String? saturatedFat;
  final String? protein;
  final String? salt;

  Nutrition({
    this.energy,
    this.carbohydrates,
    this.sugars,
    this.fat,
    this.saturatedFat,
    this.protein,
    this.salt,
  });

  // From OpenFoodFacts API
  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
        energy: json['energy-kcal_100g']?.toString(),
        carbohydrates: json['carbohydrates_100g']?.toString(),
        sugars: json['sugars_100g']?.toString(),
        fat: json['fat_100g']?.toString(),
        saturatedFat: json['saturated-fat_100g']?.toString(),
        protein: json['proteins_100g']?.toString(),
        salt: json['salt_100g']?.toString(),
      );

  // For Firebase saving
  Map<String, dynamic> toJson() => {
        'energy': energy,
        'carbohydrates': carbohydrates,
        'sugars': sugars,
        'fat': fat,
        'saturatedFat': saturatedFat,
        'protein': protein,
        'salt': salt,
      };

  factory Nutrition.fromFirebase(Map<String, dynamic> json) => Nutrition(
        energy: json['energy'],
        carbohydrates: json['carbohydrates'],
        sugars: json['sugars'],
        fat: json['fat'],
        saturatedFat: json['saturatedFat'],
        protein: json['protein'],
        salt: json['salt'],
      );
}
