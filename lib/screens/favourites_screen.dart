// favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:foodscan_app/widgets/favourite_icon_button.dart';
import '../services/favourites_service.dart';
import '../services/product_service.dart';
import '../screens/food_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final favoritesService = FavoritesService();

    return Scaffold(
      appBar: AppBar(title: Text(loc.favorites)),
      body: StreamBuilder<List<Product>>(
        stream: favoritesService.getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(loc.loadError));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(loc.noFavorites));
          }

          final favorites = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final Product product = favorites[index];
              return ListTile(
                leading: product.imageUrl != null
                    ? CircleAvatar(backgroundImage: NetworkImage(product.imageUrl!))
                    : const CircleAvatar(child: Icon(Icons.fastfood)),
                title: Text(product.name),
                trailing: FavoriteIconButton(product: product),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FoodDetailsScreen(product: product),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
