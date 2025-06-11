import 'package:flutter/material.dart';
import 'package:foodscan_app/ui/screens/scan/scan_screen.dart';
import 'package:provider/provider.dart';
import 'home_view_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();

    // Load the data once the widget is initialized
    Future.microtask(() => _viewModel.loadUserGoals());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body:
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Calories Progress
                    SizedBox(
                      height: 240,
                      width: 180,
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 16.0,
                        percent: vm.calorieProgress.clamp(0.0, 1.0),
                        center: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${vm.consumedCalories}',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '/ ${vm.calorieGoal}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        progressColor: Colors.blueAccent,
                        backgroundColor: Colors.grey[300]!,
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                        animationDuration: 600,
                      ),
                    ),

                    const SizedBox(height: 40),

                    _macroRow(loc.carbs, vm.carbs, vm.carbsGoal, loc),
                    _macroRow(loc.protein, vm.protein, vm.proteinGoal, loc),
                    _macroRow(loc.fats, vm.fat, vm.fatGoal, loc),

                    const Spacer(),

                    if (vm.consumedCalories >= vm.calorieGoal) ...[
                       Text(
                        loc.reachedCalorieGoal,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScanScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: Text(loc.scanProduct),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

 Widget _macroRow(String label, int value, int goal, AppLocalizations loc) {
  final bool isOverLimit = value > goal;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text('$value/$goal g', style: const TextStyle(fontSize: 16)),
        ],
      ),
      LinearProgressIndicator(
        value: goal > 0 ? value / goal : 0.0,
        backgroundColor: Colors.grey[300],
        color: isOverLimit ? Colors.redAccent : Colors.blueAccent,
        minHeight: 10,
      ),
      if (isOverLimit)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            loc.goalExceeded(label),
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    ],
  );
}
}
