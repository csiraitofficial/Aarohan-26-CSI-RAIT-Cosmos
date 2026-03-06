import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import '../../services/api_service.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  State<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signup() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final success = await ApiService().registerDoctor(
      pin: _pinController.text.trim(),
      mobile: _mobileController.text.trim(),
      name: _nameController.text.trim(),
      degree: _degreeController.text.trim(),
    );
    setState(() {
      _loading = false;
    });
    if (success) {
      Navigator.pushReplacementNamed(context, '/doctor_dashboard');
    } else {
      setState(() {
        _error = AppLocalizations.of(context)!.registrationFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.doctorRegistration)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l.name),
            ),
            TextField(
              controller: _degreeController,
              decoration: InputDecoration(labelText: l.degree),
            ),
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
              onPressed: _loading ? null : _signup,
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text(l.register),
            ),
          ],
        ),
      ),
    );
  }
}
