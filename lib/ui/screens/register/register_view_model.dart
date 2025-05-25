import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodscan_app/ui/screens/nutrition_setup/nutrition_setup_screen.dart';
import '../../../common/services/auth_service.dart';

class RegisterViewModel with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  String _error = '';
  bool _loading = false;

  String get error => _error;
  bool get isLoading => _loading;

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    _setError('');
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _setError("Passwords do not match");
      return;
    }

    try {
      await _auth.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NutritionSetupScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? "Unknown error");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
