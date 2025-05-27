// product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/product.dart';

class ProductService {
  static Future<Product?> fetchProduct(String barcode) async {
    final url = Uri.parse(
      'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
    );
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
