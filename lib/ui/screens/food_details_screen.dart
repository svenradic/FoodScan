// food_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/favourite_icon_button.dart';
import '../../data/models/product.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Product product;

  const FoodDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final nutrition = product.nutrition;

    return Scaffold(
      appBar: AppBar(title: Text(product.name),
      actions: [
          FavoriteIconButton(product: product),
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (product.imageUrl != null)
              Image.network(product.imageUrl!),
            const SizedBox(height: 16),
            Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (product.ingredients != null)
              Text("${loc.ingredients}:\n${product.ingredients}", style: const TextStyle(height: 1.5)),
            const SizedBox(height: 16),
            if (nutrition != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.nutritionPer100g, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (nutrition.energy != null) Text("${loc.kcal}: ${nutrition.energy}"),
                  if (nutrition.carbohydrates != null) Text("${loc.carbs}: ${nutrition.carbohydrates}"),
                  if (nutrition.sugars != null) Text("${loc.sugars}: ${nutrition.sugars}"),
                  if (nutrition.fat != null) Text("${loc.fats}: ${nutrition.fat}"),
                  if (nutrition.saturatedFat != null) Text("${loc.saturatedFats}: ${nutrition.saturatedFat}"),
                  if (nutrition.protein != null) Text("${loc.protein}: ${nutrition.protein}"),
                  if (nutrition.salt != null) Text("${loc.salt}: ${nutrition.salt}"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
