import 'package:flutter/material.dart';
import '../../../data/models/product.dart';
import 'package:foodscan_app/common/services/product_service.dart';
import '../food_details/food_details_screen.dart';

class ScanViewModel with ChangeNotifier {
  Product? product;
  String? error;
  bool isLoading = false;
  bool isScanning = true;

  Future<void> handleBarcode(String barcode, BuildContext context) async {
    if (!isScanning || isLoading) return;

    isScanning = false;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final fetchedProduct = await ProductService.fetchProduct(barcode);

      if (fetchedProduct == null) {
        _setError("Product not found.");
        return;
      }

      if (fetchedProduct.nutrition == null) {
        _setError("Nutrition information is missing for this product.");
        return;
      }

      if (fetchedProduct != null && fetchedProduct.nutrition != null) {
        isLoading = false;
        notifyListeners();

        // Navigate outside of build()
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => FoodDetailsScreen(
                    productName: fetchedProduct.name,
                    nutrition: fetchedProduct.nutrition!,
                  ),
            ),
          ).then((_) => reset()); // Reset after returning
        }
      } else {
        _setError("No nutrition info found.");
      }
    } catch (e) {
      _setError("Failed to load product");
    }
  }

  void _setError(String msg) {
    error = msg;
    isLoading = false;
    isScanning = true;
    notifyListeners();
  }

  void reset() {
    product = null;
    error = null;
    isScanning = true;
    isLoading = false;
    notifyListeners();
  }
}
