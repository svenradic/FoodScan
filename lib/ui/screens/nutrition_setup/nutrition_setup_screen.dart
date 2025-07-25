import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'nutrition_setup_view_model.dart';
import '../dashboard_screen.dart';

class NutritionSetupScreen extends StatelessWidget {
  const NutritionSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NutritionSetupViewModel(),
      child: const _NutritionSetupView(),
    );
  }
}

class _NutritionSetupView extends StatelessWidget {
  const _NutritionSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NutritionSetupViewModel>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:  Text(loc.setGoals),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Text(
              loc.enterCalories,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vm.calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "e.g. 2000",
              ),
            ),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed:
                  vm.isLoading
                      ? null
                      : () async {
                        await vm.saveGoals(loc.enterValidNumber, loc.failedToSaveData);
                        if (vm.error == null && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DashboardScreen(),
                            ),
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child:
                  vm.isLoading
                      ? const CircularProgressIndicator(
                        color: Colors.blueAccent,
                      )
                      :  Text(loc.continueText,
                        style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
