import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../login/login_screen.dart';
import 'profile_view_model.dart';
import '../welcome_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadGoals(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView({super.key});

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  String? _language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language ??= Localizations.localeOf(context).languageCode;
  }

  void _changeLanguage(String code) {
    setState(() => _language = code);
    MyApp.setLocale(context, Locale(code));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final vm = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body:
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Heading
                     Text(
                      loc.profileSettings,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Email + Display Name
                    Text(
                      vm.user?.displayName ?? loc.noName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vm.user?.email ?? loc.noEmail,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 32),

                    // Input fields
                    _goalField(loc.calories, vm.caloriesController),
                    

                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: vm.updateGoals,
                      icon: const Icon(Icons.save),
                      label: Text(loc.saveChanges),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Language Switch
                     Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        loc.language,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title:  Text(loc.english),
                      trailing:
                          _language == 'en' ? const Icon(Icons.check) : null,
                      onTap: () => _changeLanguage("en"),
                    ),
                    ListTile(
                      title:  Text(loc.croatian),
                      trailing:
                          _language == 'hr' ? const Icon(Icons.check) : null,
                      onTap: () => _changeLanguage("hr"),
                    ),

                    const SizedBox(height: 24),

                    // Logout
                    ElevatedButton(
                      onPressed: () async {
                        await vm.logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WelcomeScreen(),
                            ),
                            (_) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:  Text(loc.logout),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _goalField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
