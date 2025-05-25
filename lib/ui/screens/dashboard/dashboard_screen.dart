import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_view_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DashboardViewModel();

    // Load the data once the widget is initialized
    Future.microtask(() => _viewModel.loadUserGoals());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: const Text('Scan a barcode'),
        centerTitle: true,
      ),
      body: vm.isLoading
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

                  _macroRow('Carbs', vm.carbs, vm.carbsGoal),
                  _macroRow('Protein', vm.protein, vm.proteinGoal),
                  _macroRow('Fat', vm.fat, vm.fatGoal),

                  const Spacer(),

                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to scanner
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Scan product"),
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
              ),
            ),
    );
  }

  Widget _macroRow(String label, int value, int goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text('$value g', style: const TextStyle(fontSize: 16)),
          ],
        ),
        LinearProgressIndicator(
          value: goal > 0 ? value / goal : 0.0,
          backgroundColor: Colors.grey[300],
          color: Colors.blueAccent,
          minHeight: 10,
        ),
      ],
    );
  }
}
