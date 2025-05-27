import 'package:flutter/material.dart';
import 'package:foodscan_app/ui/screens/dashboard_screen.dart';
import '../../../common/services/auth_service.dart';
import '../../../common/services/user_nutrition_service.dart';
import '../nutrition_setup/nutrition_setup_screen.dart';

class LoginViewModel with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool _loading = false;
  String _error = '';

  bool get loading => _loading;
  String get error => _error;

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    _setError('');

    final result = await _authService.signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    _setLoading(false);

    if (result == null) {
      final isCompleted = await UserNutritionService().isSetupCompleted();
      if(context.mounted) {
         Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  isCompleted
                      ? const DashboardScreen()
                      : const NutritionSetupScreen(),
                      
        ),
        (route) => false
      );
      }
     
    } else {
      _setError(result);
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
