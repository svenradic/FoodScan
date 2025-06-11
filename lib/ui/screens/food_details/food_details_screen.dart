import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../data/models/nutrition.dart';
import 'food_details_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FoodDetailsScreen extends StatelessWidget {
  final String productName;
  final Nutrition nutrition;

  const FoodDetailsScreen({
    super.key,
    required this.productName,
    required this.nutrition,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => FoodDetailsViewModel(
            productName: productName,
            nutrition: nutrition,
          ),
      child: const _FoodDetailsView(),
    );
  }
}

class _FoodDetailsView extends StatelessWidget {
  const _FoodDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final vm = Provider.of<FoodDetailsViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(vm.productName),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 5,
          right: 5,
          top: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              width: double.infinity,
              color: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 12.0,
                    percent: vm.kcalProgress,
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${vm.kcal}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'kcal',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white30,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Grams input
            TextField(
              keyboardType: TextInputType.number,
              decoration:  InputDecoration(
                labelText: loc.grams,
                border: OutlineInputBorder(),
              ),
              onChanged: vm.updateGrams,
            ),

            const SizedBox(height: 16),

            // Macros
            _macroRow(loc.carbs, vm.carbs, vm.macroProgress(vm.carbs)),
            _macroRow(loc.protein, vm.protein, vm.macroProgress(vm.protein)),
            _macroRow(loc.fats, vm.fat, vm.macroProgress(vm.fat)),

            const SizedBox(height: 24),

            // Add to Log Button
            ElevatedButton.icon(
              onPressed: () => vm.logFood(context, loc.successMessage, loc.errorMessage),
              icon: const Icon(Icons.add),
              label:  Text(loc.addButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Scan another product
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:  Text(loc.scanProduct),
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroRow(String label, int value, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 7,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
              minHeight: 10,
            ),
          ),
          const SizedBox(width: 12),
          Text('$value g', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
