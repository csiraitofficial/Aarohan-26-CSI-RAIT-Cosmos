import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import '../../services/api_service.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final success = await ApiService().loginDoctor(
      _mobileController.text.trim(),
      _pinController.text.trim(),
    );
    setState(() {
      _loading = false;
    });
    if (success) {
      Navigator.pushReplacementNamed(context, '/doctor_dashboard');
    } else {
      setState(() {
        _error = AppLocalizations.of(context)!.invalidCredentials;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.doctorLogin)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: l.mobile),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: l.pin),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text(l.login),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/doctor_signup');
              },
              child: Text(l.registerAsDoctor),
            ),
          ],
        ),
      ),
    );
  }
}
