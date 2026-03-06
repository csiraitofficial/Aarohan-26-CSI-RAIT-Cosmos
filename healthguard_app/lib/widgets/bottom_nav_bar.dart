import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      selectedFontSize: size.width < 360 ? 12 : 14,
      unselectedFontSize: size.width < 360 ? 10 : 12,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: l.navHome),
        BottomNavigationBarItem(icon: const Icon(Icons.show_chart), label: l.navVitals),
        BottomNavigationBarItem(icon: const Icon(Icons.sign_language), label: l.navSign),
        BottomNavigationBarItem(
          icon: const Icon(Icons.psychology),
          label: l.navAiTutor,
        ),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: l.navProfile),
      ],
    );
  }
}
