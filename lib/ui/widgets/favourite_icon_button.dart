// favorite_icon_button.dart
import 'package:flutter/material.dart';
import 'package:foodscan_app/common/services/favourites_service.dart';
import '../../data/models/product.dart';

class FavoriteIconButton extends StatefulWidget {
  final Product product;
  const FavoriteIconButton({super.key, required this.product});

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  bool _isFavorite = false;
  final _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    final isFav = await _favoritesService.isFavorite(widget.product.name);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await _favoritesService.removeFromFavorites(widget.product.name);
    } else {
      await _favoritesService.addToFavorites(widget.product);
    }
    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : null),
      onPressed: _toggleFavorite,
    );
  }
}
