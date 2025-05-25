import 'package:flutter/foundation.dart';
import '../../data/models/product.dart';

class ScanHistoryService extends ChangeNotifier {
  final List<Product> _history = [];

  List<Product> get history => List.unmodifiable(_history);

  void add(Product product) {
    if (!history.any((p) => p.name == product.name)) {
      _history.insert(0, product);
      notifyListeners();
    }
  }

  void clear() {
    _history.clear();
    notifyListeners();
  }

  void removeFromFavorites(String productName) {
    _history.removeWhere((product) => product.name == productName);
    notifyListeners();
  }
}
