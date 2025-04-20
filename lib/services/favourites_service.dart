// favorites_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/product_service.dart';

class FavoritesService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> addToFavorites(Product product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _firestore.collection('favorites').doc(user.uid);
    final productData = {
      'name': product.name,
      'imageUrl': product.imageUrl,
      'ingredients': product.ingredients,
      'nutrition': product.nutrition?.toJson(),
    };

    print("Pokušaj dodavanja: ${product.name}");

    await favRef
        .collection('items')
        .doc(product.name)
        .set(productData)
        .then((_) {
          print("Dodano u favorite!");
        })
        .catchError((error) {
          print("Greška pri dodavanju u favorite: $error");
        });
  }

  Future<void> removeFromFavorites(String productName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _firestore.collection('favorites').doc(user.uid);
    await favRef.collection('items').doc(productName).delete();
  }

  Stream<List<Product>> getFavoritesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('favorites')
        .doc(user.uid)
        .collection('items')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return Product(
                  name: data['name'] ?? 'Unknown Product',
                  imageUrl: data['imageUrl'],
                  ingredients: data['ingredients'],
                  nutrition:
                      data['nutrition'] != null
                          ? Nutrition.fromJson(
                            Map<String, dynamic>.from(data['nutrition']),
                          )
                          : null,
                );
              }).toList(),
        );
  }

  Future<bool> isFavorite(String productName) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc =
        await _firestore
            .collection('favorites')
            .doc(user.uid)
            .collection('items')
            .doc(productName)
            .get();

    return doc.exists;
  }
}
