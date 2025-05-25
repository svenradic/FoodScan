import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream za slušanje prijavljenog korisnika
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Dohvati trenutnog korisnika
  User? get currentUser => _auth.currentUser;

  // Prijava
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Registracija
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Odjava
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
