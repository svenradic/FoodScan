import 'package:flutter/material.dart';
import 'package:foodscan_app/services/scan_history_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/product_service.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanning = true;
  Product? _product;
  String? _error;

  void _onDetect(BarcodeCapture barcode) async {
    if (!_isScanning) return;
    _isScanning = false;

    final code = barcode.barcodes.first.rawValue;
    if (code != null) {
      try {
        final product = await ProductService.fetchProduct(code);
        if (product != null) {
          setState(() {
            _product = product;
            Provider.of<ScanHistoryService>(
              context,
              listen: false,
            ).add(product);
          });
        } else {
          setState(
            () => _error = AppLocalizations.of(context)!.productNotFound,
          );
        }
      } catch (e) {
        setState(() => _error = AppLocalizations.of(context)!.loadError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final nutrition = _product?.nutrition;
    return Scaffold(
      appBar: AppBar(title: Text(loc.scanProduct)),
      body:
          _product != null
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    if (_product?.imageUrl != null)
                      Image.network(_product!.imageUrl!),
                    const SizedBox(height: 16),
                    Text(
                      _product!.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_product?.ingredients != null)
                      Text(
                        "${loc.ingredients}:\n${_product?.ingredients}",
                        style: const TextStyle(height: 1.5),
                      ),
                    const SizedBox(height: 16),
                    if (nutrition != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.nutritionPer100g,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          if (nutrition.energy != null)
                            Text("${loc.kcal}: ${nutrition.energy}"),
                          if (nutrition.carbohydrates != null)
                            Text("${loc.carbs}: ${nutrition.carbohydrates}"),
                          if (nutrition.sugars != null)
                            Text("${loc.sugars}: ${nutrition.sugars}"),
                          if (nutrition.fat != null)
                            Text("${loc.fats}: ${nutrition.fat}"),
                          if (nutrition.saturatedFat != null)
                            Text(
                              "${loc.saturatedFats}: ${nutrition.saturatedFat}",
                            ),
                          if (nutrition.protein != null)
                            Text("${loc.protein}: ${nutrition.protein}"),
                          if (nutrition.salt != null)
                            Text("${loc.salt}: ${nutrition.salt}"),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _product = null;
                          _error = null;
                          _isScanning = true;
                        });
                      },
                      child: Text(loc.scanAnother),
                    ),
                  ],
                ),
              )
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          () => setState(() {
                            _error = null;
                            _isScanning = true;
                          }),
                      child: Text(loc.tryAgain),
                    ),
                  ],
                ),
              )
              : MobileScanner(onDetect: _onDetect),
    );
  }
}
