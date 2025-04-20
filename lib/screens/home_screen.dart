import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:foodscan_app/screens/favourites_screen.dart';
import 'package:foodscan_app/services/scan_history_service.dart';
import 'package:foodscan_app/widgets/favourite_icon_button.dart';
import 'profile_screen.dart';
import 'scan_screen.dart';
import 'package:provider/provider.dart';
import 'food_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final history = context.watch<ScanHistoryService>().history;

    return Scaffold(
      appBar: AppBar(title: Text(loc.home)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanScreen()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner, size: 32),
                    const SizedBox(height: 8),
                    Text(loc.scanProduct),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              loc.scanHistory,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children:
                    history
                        .map(
                          (product) => ListTile(
                            leading:
                                product.imageUrl != null
                                    ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        product.imageUrl!,
                                      ),
                                    )
                                    : const CircleAvatar(
                                      child: Icon(Icons.fastfood),
                                    ),
                            title: Text(product.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    context
                                        .read<ScanHistoryService>()
                                        .removeFromFavorites(product.name);
                                  },
                                ),
                                FavoriteIconButton(product: product),
                              ],
                            ),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            FoodDetailsScreen(product: product),
                                  ),
                                ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
