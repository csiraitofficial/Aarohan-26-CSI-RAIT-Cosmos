import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/services/api_service.dart';

// ─────────────────────────────────────────────
// Health categories available for selection
// ─────────────────────────────────────────────
class _HealthCategory {
  final String id;
  final IconData icon;
  const _HealthCategory(this.id, this.icon);
}

const _kCategories = [
  _HealthCategory('general', Icons.favorite),
  _HealthCategory('pregnancy', Icons.child_care),
  _HealthCategory('epilepsy', Icons.electric_bolt),
  _HealthCategory('autism', Icons.psychology),
  _HealthCategory('diabetes1', Icons.water_drop),
  _HealthCategory('diabetes2', Icons.monitor_heart),
  _HealthCategory('hypertension', Icons.speed),
  _HealthCategory('heart', Icons.favorite_border),
  _HealthCategory('asthma', Icons.air),
  _HealthCategory('anxiety', Icons.self_improvement),
  _HealthCategory('disability', Icons.accessible),
  _HealthCategory('surgery', Icons.healing),
  _HealthCategory('elderly', Icons.elderly),
];

String _categoryLabel(AppLocalizations l, String id) {
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _emergencyCtrl = TextEditingController();
  final _cycleLenCtrl = TextEditingController(text: '28');
  final _periodDurCtrl = TextEditingController(text: '5');

  final _apiService = ApiService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  String _gender = 'Male'; // 'Male' | 'Female' | 'Other'
  final Set<String> _selectedCategories = {'general'};
  DateTime? _lastPeriodDate;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _emergencyCtrl.dispose();
    _cycleLenCtrl.dispose();
    _periodDurCtrl.dispose();
    super.dispose();
  }

  bool get _isFemale => _gender == 'Female';

  Future<void> _pickLastPeriodDate() async {
    final l = AppLocalizations.of(context)!;
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: l.selectLastPeriodDate,
    );
    if (picked != null) setState(() => _lastPeriodDate = picked);
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_isFemale && _lastPeriodDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.pleaseSelectLastPeriod)));
      return;
    }

    setState(() => _isLoading = true);

    final success = await _apiService.signUp(
      _usernameCtrl.text.trim(),
      _passwordCtrl.text,
      _nameCtrl.text.trim(),
    );

    if (success) {
      // Save profile data into ApiService static fields
      ApiService.currentGender = _gender;
      ApiService.healthCategories = _selectedCategories.toList();
      ApiService.emergencyContact = _emergencyCtrl.text.trim();
      ApiService.currentStudentName = _nameCtrl.text.trim();
      if (_isFemale) {
        ApiService.lastPeriodDate = _lastPeriodDate;
        ApiService.menstrualCycleLength =
            int.tryParse(_cycleLenCtrl.text) ?? 28;
        ApiService.menstrualPeriodDuration =
            int.tryParse(_periodDurCtrl.text) ?? 5;
      }

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.accountCreated)));
        Navigator.pop(context); // back to login
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.signUpFailed)));
      }
    }
  }

  // ─── UI helpers ───────────────────────────────────────────────────────────

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.teal,
      ),
    ),
  );

  Widget _genderChip(String value, String label, IconData icon) {
    final selected = _gender == value;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? Colors.white : Colors.teal,
      ),
      label: Text(label),
      selected: selected,
      selectedColor: Colors.teal,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
      onSelected: (_) => setState(() => _gender = value),
    );
  }

  Widget _categoryTile(_HealthCategory cat, AppLocalizations l) {
    final selected = _selectedCategories.contains(cat.id);
    return CheckboxListTile(
      value: selected,
      onChanged: (val) {
        setState(() {
          if (val == true) {
            _selectedCategories.add(cat.id);
          } else {
            _selectedCategories.remove(cat.id);
          }
        });
      },
      secondary: CircleAvatar(
        radius: 18,
        backgroundColor: selected ? Colors.teal : Colors.grey[200],
        child: Icon(
          cat.icon,
          size: 18,
          color: selected ? Colors.white : Colors.teal,
        ),
      ),
      title: Text(
        _categoryLabel(l, cat.id),
        style: const TextStyle(fontSize: 14),
      ),
      controlAffinity: ListTileControlAffinity.trailing,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.createAccount),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Section 1: Basic Info ──────────────────────────────────
                _sectionHeader(l.basicInformation),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: l.fullName,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.enterYourName : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                    labelText: l.username,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.enterUsername : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    labelText: l.password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (v) =>
                      (v == null || v.length < 6) ? l.passwordMinLength : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtrl,
                  decoration: InputDecoration(
                    labelText: l.confirmPassword,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v != _passwordCtrl.text ? l.passwordsDoNotMatch : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emergencyCtrl,
                  decoration: InputDecoration(
                    labelText: l.emergencyContactNumber,
                    hintText: 'e.g. +919876543210',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.emergency, color: Colors.red),
                    helperText: l.emergencyContactHelper,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null; // optional
                    final digits = v.trim().replaceAll(RegExp(r'[\s\-()]'), '');
                    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(digits)) {
                      return l.enterValidPhone;
                    }
                    return null;
                  },
                ),

                // ── Section 2: Gender ──────────────────────────────────────
                _sectionHeader(l.gender),
                Wrap(
                  spacing: 10,
                  children: [
                    _genderChip('Male', l.male, Icons.male),
                    _genderChip('Female', l.female, Icons.female),
                    _genderChip('Other', l.other, Icons.transgender),
                  ],
                ),

                // ── Section 3: Health Categories ───────────────────────────
                _sectionHeader(l.healthProfileSelect),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: _kCategories
                        .map((c) => _categoryTile(c, l))
                        .toList(),
                  ),
                ),

                // ── Section 4: Menstrual Cycle (Female only) ───────────────
                if (_isFemale) ...[
                  _sectionHeader(l.menstrualCycleTracking),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Colors.pinkAccent,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Last period date
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.calendar_today,
                              color: Colors.pinkAccent,
                            ),
                            title: Text(l.lastPeriodStartDate),
                            subtitle: Text(
                              _lastPeriodDate == null
                                  ? l.tapToSelect
                                  : '${_lastPeriodDate!.day}/${_lastPeriodDate!.month}/${_lastPeriodDate!.year}',
                              style: TextStyle(
                                color: _lastPeriodDate == null
                                    ? Colors.grey
                                    : Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: _pickLastPeriodDate,
                          ),
                          const Divider(),
                          // Cycle length
                          Row(
                            children: [
                              const Icon(
                                Icons.loop,
                                color: Colors.pinkAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(l.averageCycleLength)),
                              SizedBox(
                                width: 64,
                                child: TextFormField(
                                  controller: _cycleLenCtrl,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    suffixText: l.days,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Period duration
                          Row(
                            children: [
                              const Icon(
                                Icons.water_drop,
                                color: Colors.pinkAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(l.averagePeriodDuration)),
                              SizedBox(
                                width: 64,
                                child: TextFormField(
                                  controller: _periodDurCtrl,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    suffixText: l.days,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // ── Submit ─────────────────────────────────────────────────
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          l.createAccount,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.alreadyHaveAccount),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
