import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../common/services/auth_service.dart';
import '../../main.dart';
import 'login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String? _language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language ??= Localizations.localeOf(context).languageCode;
  }

  void _changeLanguage(String code) {
    setState(() => _language = code);
    Locale newLocale = Locale(code);
    MyApp.setLocale(context, newLocale);
  }

  void _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(loc.profile)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.language,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(loc.english),
              trailing: _language == 'en' ? const Icon(Icons.check) : null,
              onTap: () => _changeLanguage("en"),
            ),
            ListTile(
              title: Text(loc.croatian),
              trailing: _language == 'hr' ? const Icon(Icons.check) : null,
              onTap: () => _changeLanguage("hr"),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    user?.email ?? "email@example.com",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      child: Text(loc.logout),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
