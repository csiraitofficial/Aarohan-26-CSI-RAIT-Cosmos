import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/auth/login_screen.dart';
import 'package:mobile/features/auth/role_selection_screen.dart';
import 'package:mobile/features/auth/signup_screen.dart';
import 'package:mobile/features/dashboard/dashboard_screen.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/locale_provider.dart';
import 'features/auth/doctor_login_screen.dart';
import 'features/auth/doctor_signup_screen.dart';
import 'features/dashboard/doctor_dashboard_screen.dart';
import 'features/dashboard/doctor_patient_vitals_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.resolveBackend();

  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(
    ChangeNotifierProvider.value(value: localeProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'signify',
      theme: AppTheme.lightTheme,
      locale: localeProvider.locale,
      supportedLocales: LocaleProvider.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppConstants.dashboardRoute,
      routes: {
        AppConstants.roleSelectionRoute: (context) =>
            const RoleSelectionScreen(),
        AppConstants.loginRoute: (context) => const LoginScreen(),
        AppConstants.signupRoute: (context) => const SignupScreen(),
        '/doctor_login': (context) => const DoctorLoginScreen(),
        '/doctor_signup': (context) => const DoctorSignupScreen(),
        '/doctor_dashboard': (context) => const DoctorDashboardScreen(),
        '/doctor_patient_vitals': (context) =>
            const DoctorPatientVitalsScreen(),
        AppConstants.dashboardRoute: (context) => const DashboardScreen(),
      },
    );
  }
}
