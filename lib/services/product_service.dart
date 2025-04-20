// product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
        energy: json['energy-kcal_100g']?.toString(),
        carbohydrates: json['carbohydrates_100g']?.toString(),
        sugars: json['sugars_100g']?.toString(),
        fat: json['fat_100g']?.toString(),
        saturatedFat: json['saturated-fat_100g']?.toString(),
        protein: json['proteins_100g']?.toString(),
        salt: json['salt_100g']?.toString(),
      );
  
  Map<String, dynamic> toJson() => {
        'energy-kcal_100g': energy,
        'carbohydrates_100g': carbohydrates,
        'sugars_100g': sugars,
        'fat_100g': fat,
        'saturated-fat_100g': saturatedFat,
        'proteins_100g': protein,
        'salt_100g': salt,
      };
}

class Product {
  final String name;
  final String? imageUrl;
  final String? ingredients;
  final Nutrition? nutrition;

  Product({
    required this.name,
    this.imageUrl,
    this.ingredients,
    this.nutrition,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    final nutriments = product['nutriments'] as Map<String, dynamic>?;
    return Product(
      name: product['product_name'] ?? 'Unknown Product',
      imageUrl: product['image_url'],
      ingredients: product['ingredients_text'],
      nutrition: nutriments != null ? Nutrition.fromJson(nutriments) : null,
    );
  }
}

class ProductService {
  static Future<Product?> fetchProduct(String barcode) async {
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 1) {
        return Product.fromJson(jsonData);
      } else {
        return null; // product not found
      }
    } else {
      throw Exception('Failed to load product');
    }
  }
}
