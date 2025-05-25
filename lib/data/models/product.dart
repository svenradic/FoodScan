import 'nutrition.dart';

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