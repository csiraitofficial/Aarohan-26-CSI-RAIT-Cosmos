import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../services/locale_provider.dart';
import '../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static String _categoryLabel(AppLocalizations l, String id) {
    switch (id) {
      case 'general':
        return l.catGeneral;
      case 'pregnancy':
        return l.catPregnancy;
      case 'epilepsy':
        return l.catEpilepsy;
      case 'autism':
        return l.catAutism;
      case 'diabetes1':
        return l.catDiabetes1;
      case 'diabetes2':
        return l.catDiabetes2;
      case 'hypertension':
        return l.catHypertension;
      case 'heart':
        return l.catHeart;
      case 'asthma':
        return l.catAsthma;
      case 'anxiety':
        return l.catAnxiety;
      case 'disability':
        return l.catDisability;
      case 'surgery':
        return l.catSurgery;
      case 'elderly':
        return l.catElderly;
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final l = AppLocalizations.of(context)!;
    final gender = ApiService.currentGender ?? l.notSet;
    final emergency = ApiService.emergencyContact;
    final categories = ApiService.healthCategories;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar & name ────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 52,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(
                  ApiService.currentStudentName ?? l.student,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.studentIdLabel(ApiService.currentUserId ?? '-'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // ── Language selector ──────────────────────────────────────────
          _sectionHeader(context, l.language),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: LocaleProvider.supportedLocales.map((locale) {
                final code = locale.languageCode;
                final name = LocaleProvider.languageNames[code] ?? code;
                final isSelected = localeProvider.locale.languageCode == code;
                return RadioListTile<String>(
                  value: code,
                  groupValue: localeProvider.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      localeProvider.setLocale(Locale(value));
                    }
                  },
                  title: Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  dense: true,
                  activeColor: Theme.of(context).colorScheme.primary,
                );
              }).toList(),
            ),
          ),

          // ── Personal info ─────────────────────────────────────────────
          _sectionHeader(context, l.personalInformation),
          _infoTile(Icons.wc, l.gender, gender),

          // ── Emergency contact ─────────────────────────────────────────
          _sectionHeader(context, l.emergencyContact),
          _infoTile(
            Icons.emergency,
            l.contactNumber,
            emergency.isEmpty ? l.notProvided : emergency,
            valueColor: emergency.isEmpty ? Colors.grey : Colors.red.shade700,
            iconColor: Colors.red,
          ),

          // ── Health profile ────────────────────────────────────────────
          _sectionHeader(context, l.healthProfile),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                l.noCategoriesSelected,
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: categories.map((id) {
                final label = _categoryLabel(l, id);
                return Chip(
                  label: Text(label, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),

          // ── Menstrual cycle (female only) ─────────────────────────────
          if (ApiService.currentGender == 'Female') ...[
            _sectionHeader(context, l.menstrualCycle),
            _infoTile(
              Icons.calendar_today,
              l.lastPeriod,
              ApiService.lastPeriodDate == null
                  ? l.notSet
                  : '${ApiService.lastPeriodDate!.day}/'
                        '${ApiService.lastPeriodDate!.month}/'
                        '${ApiService.lastPeriodDate!.year}',
            ),
            _infoTile(
              Icons.loop,
              l.cycleLength,
              '${ApiService.menstrualCycleLength} ${l.days}',
            ),
            _infoTile(
              Icons.water_drop,
              l.periodDuration,
              '${ApiService.menstrualPeriodDuration} ${l.days}',
            ),
          ],

          const SizedBox(height: 32),

          // ── Logout ────────────────────────────────────────────────────
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(l.logout),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              ApiService.currentUserId = null;
              ApiService.currentStudentName = null;
              ApiService.currentGender = null;
              ApiService.healthCategories = [];
              ApiService.emergencyContact = '';
              ApiService.lastPeriodDate = null;
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppConstants.roleSelectionRoute,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _infoTile(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
    Color? valueColor,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? Colors.teal),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: valueColor ?? Colors.black87),
          ),
        ),
      ],
    ),
  );
}
