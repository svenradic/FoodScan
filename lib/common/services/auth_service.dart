import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userChanges => _auth.authStateChanges();

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
  Future<String?> register(String email, String password, String userName) async {
    try {
       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(userName);
      await userCredential.user?.reload();
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
