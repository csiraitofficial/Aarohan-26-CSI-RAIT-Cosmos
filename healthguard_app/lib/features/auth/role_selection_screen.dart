import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/l10n/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../services/api_service.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool? _backendConnected; // null = checking, true = ok, false = failed

  @override
  void initState() {
    super.initState();
    _checkBackendConnection();
  }

  Future<void> _checkBackendConnection() async {
    setState(() => _backendConnected = null);
    try {
      final uri = Uri.parse('${ApiService.baseUrl}/');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      if (mounted) {
        setState(() => _backendConnected = response.statusCode == 200);
      }
    } catch (_) {
      if (mounted) setState(() => _backendConnected = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l.welcomeTo(AppConstants.appName),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 24 : 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _checkBackendConnection,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _backendConnected == null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l.checkingBackend,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Chip(
                          key: ValueKey(_backendConnected),
                          avatar: Icon(
                            _backendConnected!
                                ? Icons.circle
                                : Icons.circle_outlined,
                            size: 10,
                            color: _backendConnected!
                                ? Colors.green
                                : Colors.red,
                          ),
                          label: Text(
                            _backendConnected!
                                ? l.backendConnected
                                : l.noBackendTapRetry,
                            style: TextStyle(
                              fontSize: 11,
                              color: _backendConnected!
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                          backgroundColor: _backendConnected!
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          side: BorderSide(
                            color: _backendConnected!
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 0,
                          ),
                        ),
                ),
              ),
              SizedBox(height: size.height * 0.08),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppConstants.loginRoute,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8, 56),
                  textStyle: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                ),
                child: Text(l.continueAsStudent),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/doctor_login');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8, 56),
                  textStyle: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                ),
                child: Text(l.continueAsDoctor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
