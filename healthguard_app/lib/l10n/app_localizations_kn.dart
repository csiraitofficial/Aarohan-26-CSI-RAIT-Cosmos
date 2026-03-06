// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String welcomeTo(String appName) {
    return '$appName ಗೆ ಸ್ವಾಗತ';
  }

  @override
  String get checkingBackend => 'ಬ್ಯಾಕೆಂಡ್ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get backendConnected => 'ಬ್ಯಾಕೆಂಡ್ ಸಂಪರ್ಕಗೊಂಡಿದೆ';

  @override
  String get noBackendTapRetry => 'ಬ್ಯಾಕೆಂಡ್ ಇಲ್ಲ — ಮರುಪ್ರಯತ್ನಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get continueAsStudent => 'ವಿದ್ಯಾರ್ಥಿಯಾಗಿ ಮುಂದುವರಿಸಿ';

  @override
  String get continueAsDoctor => 'ವೈದ್ಯರಾಗಿ ಮುಂದುವರಿಸಿ';

  @override
  String get username => 'ಬಳಕೆದಾರಹೆಸರು';

  @override
  String get password => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get loginAsStudent => 'ವಿದ್ಯಾರ್ಥಿಯಾಗಿ ಲಾಗಿನ್ ಮಾಡಿ';

  @override
  String get dontHaveAccount => 'ಖಾತೆ ಇಲ್ಲವೇ? ಸೈನ್ ಅಪ್ ಮಾಡಿ';

  @override
  String get quickLogin => 'ತ್ವರಿತ ಲಾಗಿನ್ (ನೇರ ಸೈನ್ ಇನ್)';

  @override
  String get invalidCredentials => 'ಅಮಾನ್ಯ ರುಜುವಾತುಗಳು';

  @override
  String get directSignInFailed => 'ನೇರ ಸೈನ್ ಇನ್ ವಿಫಲವಾಗಿದೆ';

  @override
  String get createAccount => 'ಖಾತೆ ರಚಿಸಿ';

  @override
  String get basicInformation => 'ಮೂಲ ಮಾಹಿತಿ';

  @override
  String get fullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get confirmPassword => 'ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get emergencyContactNumber => 'ತುರ್ತು ಸಂಪರ್ಕ ಸಂಖ್ಯೆ';

  @override
  String get gender => 'ಲಿಂಗ';

  @override
  String get healthProfileSelect =>
      'ಆರೋಗ್ಯ ಪ್ರೊಫೈಲ್  (ಅನ್ವಯವಾಗುವ ಎಲ್ಲವನ್ನೂ ಆಯ್ಕೆಮಾಡಿ)';

  @override
  String get menstrualCycleTracking => 'ಋತುಚಕ್ರ ಟ್ರ್ಯಾಕಿಂಗ್';

  @override
  String get lastPeriodStartDate => 'ಕೊನೆಯ ಋತುಸ್ರಾವ ಪ್ರಾರಂಭ ದಿನಾಂಕ';

  @override
  String get tapToSelect => 'ಆಯ್ಕೆ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get averageCycleLength => 'ಸರಾಸರಿ ಚಕ್ರದ ಅವಧಿ';

  @override
  String get averagePeriodDuration => 'ಸರಾಸರಿ ಋತುಸ್ರಾವ ಅವಧಿ';

  @override
  String get days => 'ದಿನಗಳು';

  @override
  String get alreadyHaveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ? ಲಾಗ್ ಇನ್ ಮಾಡಿ';

  @override
  String get enterYourName => 'ನಿಮ್ಮ ಹೆಸರನ್ನು ನಮೂದಿಸಿ';

  @override
  String get enterUsername => 'ಬಳಕೆದಾರಹೆಸರನ್ನು ನಮೂದಿಸಿ';

  @override
  String get passwordMinLength => 'ಪಾಸ್‌ವರ್ಡ್ ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು';

  @override
  String get passwordsDoNotMatch => 'ಪಾಸ್‌ವರ್ಡ್‌ಗಳು ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ';

  @override
  String get enterValidPhone =>
      'ಮಾನ್ಯ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ (ಉದಾ: +919876543210)';

  @override
  String get selectLastPeriodDate => 'ಕೊನೆಯ ಋತುಸ್ರಾವ ಪ್ರಾರಂಭ ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get pleaseSelectLastPeriod =>
      'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಕೊನೆಯ ಋತುಸ್ರಾವ ಪ್ರಾರಂಭ ದಿನಾಂಕವನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get accountCreated => 'ಖಾತೆ ರಚಿಸಲಾಗಿದೆ! ದಯವಿಟ್ಟು ಲಾಗ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get signUpFailed =>
      'ಸೈನ್ ಅಪ್ ವಿಫಲವಾಗಿದೆ. ಬಳಕೆದಾರಹೆಸರು ಈಗಾಗಲೇ ತೆಗೆದುಕೊಳ್ಳಲಾಗಿರಬಹುದು.';

  @override
  String get emergencyContactHelper =>
      'ಹೃದಯ ಬಡಿತ ಹೆಚ್ಚಳದ ಸಮಯದಲ್ಲಿ ನಿಮ್ಮ GPS ಸ್ಥಳದೊಂದಿಗೆ SMS ಸ್ವೀಕರಿಸುತ್ತಾರೆ';

  @override
  String get male => 'ಪುರುಷ';

  @override
  String get female => 'ಮಹಿಳೆ';

  @override
  String get other => 'ಇತರೆ';

  @override
  String get catGeneral => 'ಸಾಮಾನ್ಯ ಆರೋಗ್ಯ';

  @override
  String get catPregnancy => 'ಗರ್ಭಧಾರಣೆ';

  @override
  String get catEpilepsy => 'ಮೂರ್ಛೆರೋಗ / ಸೆಳೆತ';

  @override
  String get catAutism => 'ಆಟಿಸಂ ಸ್ಪೆಕ್ಟ್ರಮ್ (ASD)';

  @override
  String get catDiabetes1 => 'ಟೈಪ್ 1 ಮಧುಮೇಹ';

  @override
  String get catDiabetes2 => 'ಟೈಪ್ 2 ಮಧುಮೇಹ';

  @override
  String get catHypertension => 'ಅಧಿಕ ರಕ್ತದೊತ್ತಡ (High BP)';

  @override
  String get catHeart => 'ಹೃದಯ ಸಮಸ್ಯೆ';

  @override
  String get catAsthma => 'ಆಸ್ತಮಾ / ಉಸಿರಾಟ';

  @override
  String get catAnxiety => 'ಆತಂಕ / ಮಾನಸಿಕ ಆರೋಗ್ಯ';

  @override
  String get catDisability => 'ದೈಹಿಕ ಅಂಗವಿಕಲತೆ';

  @override
  String get catSurgery => 'ಶಸ್ತ್ರಚಿಕಿತ್ಸೆ ನಂತರದ ಚೇತರಿಕೆ';

  @override
  String get catElderly => 'ಹಿರಿಯರ ಆರೈಕೆ';

  @override
  String get doctorLogin => 'ವೈದ್ಯರ ಲಾಗಿನ್';

  @override
  String get mobile => 'ಮೊಬೈಲ್';

  @override
  String get pin => 'PIN';

  @override
  String get login => 'ಲಾಗಿನ್';

  @override
  String get registerAsDoctor => 'ವೈದ್ಯರಾಗಿ ನೋಂದಣಿ ಮಾಡಿ';

  @override
  String get doctorRegistration => 'ವೈದ್ಯರ ನೋಂದಣಿ';

  @override
  String get name => 'ಹೆಸರು';

  @override
  String get degree => 'ಪದವಿ';

  @override
  String get register => 'ನೋಂದಣಿ';

  @override
  String get registrationFailed => 'ನೋಂದಣಿ ವಿಫಲವಾಗಿದೆ';

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navVitals => 'ಆರೋಗ್ಯ ಸೂಚಕ';

  @override
  String get navSign => 'ಸಂಜ್ಞೆ';

  @override
  String get navAiTutor => 'AI ಶಿಕ್ಷಕ';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get goodMorning => 'ಶುಭೋದಯ';

  @override
  String get goodAfternoon => 'ಶುಭ ಮಧ್ಯಾಹ್ನ';

  @override
  String get goodEvening => 'ಶುಭ ಸಂಜೆ';

  @override
  String get healthSnapshot => 'ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ನ್ಯಾಪ್‌ಶಾಟ್';

  @override
  String get testEmergencyAlert => 'ತುರ್ತು ಎಚ್ಚರಿಕೆ ಪರೀಕ್ಷೆ';

  @override
  String get simulateVitals =>
      'SMS + ಕಂಪನ ಪ್ರಚೋದಿಸಲು HR / BP / ಗ್ಲೂಕೋಸ್ ಅನುಕರಿಸಿ';

  @override
  String get heartRate => 'ಹೃದಯ ಬಡಿತ';

  @override
  String get bp => 'BP';

  @override
  String get steps => 'ಹೆಜ್ಜೆಗಳು';

  @override
  String get calories => 'ಕ್ಯಾಲೊರಿಗಳು';

  @override
  String get activeMin => 'ಸಕ್ರಿಯ ನಿಮಿಷ';

  @override
  String get glucose => 'ಗ್ಲೂಕೋಸ್';

  @override
  String get spo2 => 'SpO2';

  @override
  String get stress => 'ಒತ್ತಡ';

  @override
  String get emergencyVitalsSimulator => 'ತುರ್ತು ಆರೋಗ್ಯ ಸೂಚಕ ಅನುಕರಣೆ';

  @override
  String get slideValuesAbove =>
      'ಟ್ರಿಗರ್ ಬಟನ್ ಅನ್‌ಲಾಕ್ ಮಾಡಲು ಮೌಲ್ಯಗಳನ್ನು ಮಿತಿಗಿಂತ ಮೇಲಕ್ಕೆ ಸ್ಲೈಡ್ ಮಾಡಿ.';

  @override
  String get applyMockVitals => 'ಮಾಕ್ ಸೂಚಕಗಳನ್ನು ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ಗೆ ಅನ್ವಯಿಸಿ';

  @override
  String get triggerEmergencyAlert => 'ತುರ್ತು ಎಚ್ಚರಿಕೆ ಪ್ರಚೋದಿಸಿ';

  @override
  String get raiseValueAbove => 'ಮೊದಲು ಮೌಲ್ಯವನ್ನು ಮಿತಿಗಿಂತ ಮೇಲಕ್ಕೆ ಹೆಚ್ಚಿಸಿ';

  @override
  String get testEmergencyAlertTitle => '[ಪರೀಕ್ಷೆ] ತುರ್ತು ಎಚ್ಚರಿಕೆ';

  @override
  String get heartRateSpikeDetected => 'ಹೃದಯ ಬಡಿತ ಹೆಚ್ಚಳ ಪತ್ತೆಯಾಗಿದೆ';

  @override
  String get dismiss => 'ವಜಾಗೊಳಿಸಿ';

  @override
  String get backendDisconnected => 'ಬ್ಯಾಕೆಂಡ್ ಸಂಪರ್ಕ ಕಡಿತಗೊಂಡಿದೆ';

  @override
  String get refreshVitals => 'ಸೂಚಕಗಳನ್ನು ರಿಫ್ರೆಶ್ ಮಾಡಿ';

  @override
  String get specialNeedsModeOnTap =>
      'ವಿಶೇಷ ಅಗತ್ಯಗಳ ಮೋಡ್: ಆನ್ (ಬದಲಾಯಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ)';

  @override
  String get specialNeedsModeOffTap =>
      'ವಿಶೇಷ ಅಗತ್ಯಗಳ ಮೋಡ್: ಆಫ್ (ಬದಲಾಯಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ)';

  @override
  String get notificationsNone => 'ಅಧಿಸೂಚನೆಗಳು (ನಕಲಿ: ಹೊಸ ಎಚ್ಚರಿಕೆಗಳಿಲ್ಲ)';

  @override
  String get vitals => 'ಆರೋಗ್ಯ ಸೂಚಕಗಳು';

  @override
  String get signLanguage => 'ಸಂಜ್ಞಾ ಭಾಷೆ';

  @override
  String get offlineAi => 'ಆಫ್‌ಲೈನ್ AI';

  @override
  String get profile => 'ಪ್ರೊಫೈಲ್';

  @override
  String mockHeartRateMsg(int hr) {
    return 'ಮಾಕ್ ಹೃದಯ ಬಡಿತ: $hr BPM\n\nಇದು ಪರೀಕ್ಷೆಯಾಗಿದೆ. ನಿಜವಾದ ಹೆಚ್ಚಳದಲ್ಲಿ, ತುರ್ತು ಸಂಪರ್ಕಗಳಿಗೆ ನಿಮ್ಮ GPS ಸ್ಥಳದೊಂದಿಗೆ ತಿಳಿಸಲಾಗುತ್ತದೆ.';
  }

  @override
  String realSpikeMsg(int hr) {
    return 'ಹೃದಯ ಬಡಿತ: $hr BPM\n\nತುರ್ತು ಸಂಪರ್ಕಗಳು ಮತ್ತು ವೈದ್ಯರಿಗೆ ನಿಮ್ಮ GPS ಸ್ಥಳದೊಂದಿಗೆ ತಿಳಿಸಲಾಗಿದೆ.';
  }

  @override
  String get systolicBp => 'ಸಿಸ್ಟೊಲಿಕ್ ರಕ್ತದೊತ್ತಡ';

  @override
  String get bloodGlucose => 'ರಕ್ತದ ಗ್ಲೂಕೋಸ್';

  @override
  String get noNumberSet =>
      'ಸೈನ್ ಅಪ್ ಸಮಯದಲ್ಲಿ ಸಂಖ್ಯೆ ನಮೂದಿಸಿಲ್ಲ — ಇಲ್ಲಿ ನಮೂದಿಸಿ';

  @override
  String get fromProfileEditable =>
      'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್‌ನಿಂದ (ಈ ಪರೀಕ್ಷೆಗೆ ಸಂಪಾದಿಸಬಹುದು)';

  @override
  String aboveThreshold(String threshold, String unit) {
    return '$threshold $unit ಮೇಲೆ — ಎಚ್ಚರಿಕೆ ಪ್ರಚೋದಿಸುತ್ತದೆ';
  }

  @override
  String normalThreshold(String threshold, String unit) {
    return 'ಸಾಮಾನ್ಯ  |  ಮಿತಿ: $threshold $unit';
  }

  @override
  String get specialNeedsOnAlerts =>
      'ವಿಶೇಷ ಅಗತ್ಯಗಳ ಮೋಡ್: ಆನ್ — ಹೆಚ್ಚಳ ಎಚ್ಚರಿಕೆಗಳು ಸಕ್ರಿಯಗೊಂಡಿವೆ';

  @override
  String get specialNeedsManual => '(ಕೈಯಿಂದ)';

  @override
  String get specialNeedsFromProfile => '(ಪ್ರೊಫೈಲ್ ವರ್ಗಗಳಿಂದ)';

  @override
  String get specialNeedsModeOff => 'ವಿಶೇಷ ಅಗತ್ಯಗಳ ಮೋಡ್: ಆಫ್';

  @override
  String get doctorDashboard => 'ವೈದ್ಯರ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್';

  @override
  String get appointments => 'ನೇಮಕಾತಿಗಳು';

  @override
  String get patients => 'ರೋಗಿಗಳು';

  @override
  String get failedToLoadProfile => 'ಪ್ರೊಫೈಲ್ ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';

  @override
  String get doctorInfoNotFound => 'ವೈದ್ಯರ ಮಾಹಿತಿ ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get practiceDetails => 'ಅಭ್ಯಾಸದ ವಿವರಗಳು';

  @override
  String get clinicLocation => 'ಕ್ಲಿನಿಕ್ ಸ್ಥಳ';

  @override
  String get signifyMedicalCenter => 'signify ವೈದ್ಯಕೀಯ ಕೇಂದ್ರ';

  @override
  String get availableHours => 'ಲಭ್ಯವಿರುವ ಸಮಯ';

  @override
  String get doctorId => 'ವೈದ್ಯರ ID';

  @override
  String get totalPatients => 'ಒಟ್ಟು ರೋಗಿಗಳು';

  @override
  String get noAppointments => 'ನೇಮಕಾತಿಗಳಿಲ್ಲ';

  @override
  String timeLabel(String time) {
    return 'ಸಮಯ: $time';
  }

  @override
  String get confirmed => 'ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get confirm => 'ದೃಢೀಕರಿಸಿ';

  @override
  String get myPatients => 'ನನ್ನ ರೋಗಿಗಳು';

  @override
  String get prioritySort => 'ಆದ್ಯತೆಯ ಕ್ರಮ';

  @override
  String get noPatients => 'ರೋಗಿಗಳಿಲ್ಲ';

  @override
  String priorityLevel(String level) {
    return 'ಆದ್ಯತೆ: $level';
  }

  @override
  String get reloadAppointments => 'ನೇಮಕಾತಿಗಳನ್ನು ಮರುಲೋಡ್ ಮಾಡಿ';

  @override
  String get reloadPatients => 'ರೋಗಿಗಳನ್ನು ಮರುಲೋಡ್ ಮಾಡಿ';

  @override
  String get patientVitals => 'ರೋಗಿಯ ಆರೋಗ್ಯ ಸೂಚಕಗಳು';

  @override
  String get noPatientSelected => 'ಯಾವುದೇ ರೋಗಿಯನ್ನು ಆಯ್ಕೆ ಮಾಡಿಲ್ಲ';

  @override
  String get keyHealthIndicators => 'ಪ್ರಮುಖ ಆರೋಗ್ಯ ಸೂಚಕಗಳು';

  @override
  String get bloodPressure => 'ರಕ್ತದೊತ್ತಡ';

  @override
  String get todaysSteps => 'ಇಂದಿನ ಹೆಜ್ಜೆಗಳು';

  @override
  String get activeTime => 'ಸಕ್ರಿಯ ಸಮಯ';

  @override
  String healthStatusLabel(String status) {
    return 'ಆರೋಗ್ಯ ಸ್ಥಿತಿ: $status';
  }

  @override
  String get normal => 'ಸಾಮಾನ್ಯ';

  @override
  String get attentionRequired => 'ಗಮನ ಅಗತ್ಯ';

  @override
  String get allVitalsNormal => 'ಎಲ್ಲಾ ಆರೋಗ್ಯ ಸೂಚಕಗಳು ಸಾಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿವೆ.';

  @override
  String get heartRateOutsideOptimal =>
      'ಹೃದಯ ಬಡಿತ ಅತ್ಯುತ್ತಮ ವ್ಯಾಪ್ತಿಯ ಹೊರಗಿದೆ.';

  @override
  String get failedToLoadVitals => 'ಆರೋಗ್ಯ ಸೂಚಕಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';

  @override
  String get reloadVitals => 'ಆರೋಗ್ಯ ಸೂಚಕಗಳನ್ನು ಮರುಲೋಡ್ ಮಾಡಿ';

  @override
  String get dailyStats => 'ದೈನಂದಿನ ಅಂಕಿಅಂಶಗಳು';

  @override
  String get activeMinutes => 'ಸಕ್ರಿಯ ನಿಮಿಷಗಳು';

  @override
  String get latestReadings => 'ಇತ್ತೀಚಿನ ಓದುವಿಕೆಗಳು';

  @override
  String get sleep => 'ನಿದ್ರೆ';

  @override
  String get noDataFound =>
      'ಡೇಟಾ ಕಂಡುಬಂದಿಲ್ಲ. ನಿಮ್ಮ ವಾಚ್ ಸಿಂಕ್ ಮಾಡಿ ಅಥವಾ ಮಾಕ್ ಡೇಟಾ ಸೇರಿಸಿ.';

  @override
  String get refreshData => 'ಡೇಟಾ ರಿಫ್ರೆಶ್ ಮಾಡಿ';

  @override
  String get insertMockData => 'ಮಾಕ್ ಡೇಟಾ ಸೇರಿಸಿ (ಪರೀಕ್ಷೆ)';

  @override
  String get authorizeHealthConnect =>
      'ದಯವಿಟ್ಟು Health Connect ಅಧಿಕೃತಗೊಳಿಸಿ ಮತ್ತು ಡೇಟಾ ಪಡೆಯಿರಿ.';

  @override
  String get writingMockData => 'ಮಾಕ್ ಡೇಟಾ ಬರೆಯಲಾಗುತ್ತಿದೆ...';

  @override
  String get mockDataInjected => 'ಮಾಕ್ ಡೇಟಾ ಯಶಸ್ವಿಯಾಗಿ ಸೇರಿಸಲಾಗಿದೆ!';

  @override
  String get failedToInjectMock => 'ಮಾಕ್ ಡೇಟಾ ಸೇರಿಸಲು ವಿಫಲವಾಗಿದೆ.';

  @override
  String studentIdLabel(String id) {
    return 'ವಿದ್ಯಾರ್ಥಿ ID: $id';
  }

  @override
  String get personalInformation => 'ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ';

  @override
  String get emergencyContact => 'ತುರ್ತು ಸಂಪರ್ಕ';

  @override
  String get contactNumber => 'ಸಂಪರ್ಕ ಸಂಖ್ಯೆ';

  @override
  String get notProvided => 'ಒದಗಿಸಿಲ್ಲ';

  @override
  String get healthProfile => 'ಆರೋಗ್ಯ ಪ್ರೊಫೈಲ್';

  @override
  String get noCategoriesSelected => 'ಯಾವುದೇ ವರ್ಗಗಳನ್ನು ಆಯ್ಕೆ ಮಾಡಿಲ್ಲ';

  @override
  String get menstrualCycle => 'ಋತುಚಕ್ರ';

  @override
  String get lastPeriod => 'ಕೊನೆಯ ಋತುಸ್ರಾವ';

  @override
  String get cycleLength => 'ಚಕ್ರದ ಅವಧಿ';

  @override
  String get periodDuration => 'ಋತುಸ್ರಾವ ಅವಧಿ';

  @override
  String get notSet => 'ನಿಗದಿಪಡಿಸಿಲ್ಲ';

  @override
  String get logout => 'ಲಾಗ್ ಔಟ್';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get student => 'ವಿದ್ಯಾರ್ಥಿ';

  @override
  String get aiTutorWelcome =>
      'ನಮಸ್ಕಾರ! ನಾನು ನಿಮ್ಮ AI ಶಿಕ್ಷಕ. ನಿಮ್ಮ ವೇಗದಲ್ಲಿ ಕಲಿಯಲು ಸಹಾಯ ಮಾಡಲು ನಾನಿಲ್ಲಿದ್ದೇನೆ.\n\nನೀವು ಏನನ್ನಾದರೂ ಕೇಳಬಹುದು, ಸಾರಾಂಶಕ್ಕಾಗಿ ಪಠ್ಯಪುಸ್ತಕ ಅಧ್ಯಾಯವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಬಹುದು, ಕೆಳಗಿನ ತ್ವರಿತ ಬಟನ್‌ಗಳನ್ನು ಬಳಸಬಹುದು, ಅಥವಾ ಧ್ವನಿ ಇನ್‌ಪುಟ್‌ಗಾಗಿ ಮೈಕ್ರೋಫೋನ್ ಐಕಾನ್ ಕ್ಲಿಕ್ ಮಾಡಬಹುದು!';

  @override
  String get connectToOllama => 'ದಯವಿಟ್ಟು ಮೊದಲು Ollama ಗೆ ಸಂಪರ್ಕಿಸಿ';

  @override
  String get failedToReadFile => 'ಫೈಲ್ ಓದಲು ವಿಫಲವಾಗಿದೆ';

  @override
  String get summarizingMaterial => 'ನಿಮ್ಮ ಸಾಮಗ್ರಿಯನ್ನು ಸಾರಾಂಶಗೊಳಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get failedToSummarize => 'ಸಾರಾಂಶಗೊಳಿಸಲು ವಿಫಲವಾಗಿದೆ';

  @override
  String summaryTitle(String filename) {
    return 'ಸಾರಾಂಶ: $filename';
  }

  @override
  String get failedToSummarizeMaterial =>
      'ಸಾಮಗ್ರಿಯನ್ನು ಸಾರಾಂಶಗೊಳಿಸಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ ಅಥವಾ ನೇರವಾಗಿ ಪ್ರಶ್ನೆಗಳನ್ನು ಕೇಳಿ!';

  @override
  String get errorUploadingFile => 'ಫೈಲ್ ಅಪ್‌ಲೋಡ್ ಮಾಡುವಲ್ಲಿ ದೋಷ';

  @override
  String get thinking => 'ಯೋಚಿಸುತ್ತಿದೆ…';

  @override
  String get explainSimply => 'ಸರಳವಾಗಿ ವಿವರಿಸಿ';

  @override
  String get quizMe => 'ನನಗೆ ಪ್ರಶ್ನೆ ಕೇಳಿ';

  @override
  String get summarize => 'ಸಾರಾಂಶ';

  @override
  String get typeOrVoice => 'ಟೈಪ್ ಮಾಡಿ ಅಥವಾ ಧ್ವನಿ ಇನ್‌ಪುಟ್‌ಗಾಗಿ ಮೈಕ್ ಬಳಸಿ…';

  @override
  String get tutorNotAvailable => 'ಶಿಕ್ಷಕ ಲಭ್ಯವಿಲ್ಲ…';

  @override
  String get startVoiceInput =>
      'ಧ್ವನಿ ಇನ್‌ಪುಟ್ ಪ್ರಾರಂಭಿಸಿ (ಅಂಗವಿಕಲ ವಿದ್ಯಾರ್ಥಿಗಳಿಗಾಗಿ)';

  @override
  String get stopRecording => 'ರೆಕಾರ್ಡಿಂಗ್ ನಿಲ್ಲಿಸಿ';

  @override
  String get ttsOn => 'TTS ಆನ್ (ಉತ್ತರಗಳನ್ನು ಜೋರಾಗಿ ಓದಲಾಗುವುದು)';

  @override
  String get ttsOff => 'TTS ಆಫ್';

  @override
  String get listeningSpeak => 'ಆಲಿಸುತ್ತಿದೆ... ಈಗ ಮಾತನಾಡಿ';

  @override
  String get speechNotAvailable => 'ಧ್ವನಿ ಗುರುತಿಸುವಿಕೆ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get checkingTutorConnection => 'ಶಿಕ್ಷಕ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get tutorConnected => 'ಶಿಕ್ಷಕ ಸಂಪರ್ಕಗೊಂಡಿದೆ';

  @override
  String get tutorOffline =>
      'ಶಿಕ್ಷಕ ಆಫ್‌ಲೈನ್ — ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಮರುಪ್ರಯತ್ನಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get upload => 'ಅಪ್‌ಲೋಡ್';

  @override
  String get ttsEnabled => 'ಪಠ್ಯ-ಧ್ವನಿ ಸಕ್ರಿಯಗೊಂಡಿದೆ';

  @override
  String get signLanguageIot => 'ಸಂಜ್ಞಾ ಭಾಷೆ IoT';

  @override
  String get pcHubConnected => 'PC Hub: ಸಂಪರ್ಕಗೊಂಡಿದೆ';

  @override
  String get receivingTransmissions =>
      'ನೈಜ-ಸಮಯದ ಕೈಗವಸು ಪ್ರಸರಣಗಳನ್ನು ಸ್ವೀಕರಿಸಲಾಗುತ್ತಿದೆ';

  @override
  String get smartGlove => 'ಸ್ಮಾರ್ಟ್ ಕೈಗವಸು — 5 ಬೆರಳು ಬಾಗುವಿಕೆ';

  @override
  String get thumb => 'ಹೆಬ್ಬೆರಳು';

  @override
  String get indexFinger => 'ತೋರುಬೆರಳು';

  @override
  String get middleFinger => 'ಮಧ್ಯದ ಬೆರಳು';

  @override
  String get ringFinger => 'ಉಂಗುರ ಬೆರಳು';

  @override
  String get pinkyFinger => 'ಕಿರುಬೆರಳು';

  @override
  String get aiTranslation => 'AI ಅನುವಾದ (Ollama)';

  @override
  String get detectedGesture => 'ಪತ್ತೆಯಾದ ಸನ್ನೆ:';

  @override
  String get waiting => 'ಕಾಯುತ್ತಿದೆ...';

  @override
  String get llmFluentSpeech => 'LLM ನಿರರ್ಗಳ ಮಾತು:';

  @override
  String get waitingForOllama => 'Ollama ಗಾಗಿ ಕಾಯುತ್ತಿದೆ...';

  @override
  String get liveModeConnected =>
      'ನೇರ ಮೋಡ್ — PC Hub ಗೆ ಸಂಪರ್ಕಗೊಂಡಿದೆ. ನೈಜ-ಸಮಯದಲ್ಲಿ ಸ್ಮಾರ್ಟ್ ಕೈಗವಸಿನಿಂದ ಬಾಗುವಿಕೆ ಮೌಲ್ಯಗಳು.';

  @override
  String get remindersComingSoon =>
      'ಔಷಧಿ ಮತ್ತು ನೇಮಕಾತಿ ಜ್ಞಾಪನೆಗಳು\n(ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ)';

  @override
  String get explainSimplyPrompt => 'ದಯವಿಟ್ಟು ಇದನ್ನು ಸರಳ ಪದಗಳಲ್ಲಿ ವಿವರಿಸಿ';

  @override
  String get quizMePrompt =>
      'ನಾವು ಈಗ ಚರ್ಚಿಸಿದ ವಿಷಯದ ಬಗ್ಗೆ 3 ಪ್ರಶ್ನೆಗಳನ್ನು ಕೇಳಿ';

  @override
  String get summarizePrompt => 'ನಾವು ಇಲ್ಲಿಯವರೆಗೆ ಕಲಿತಿದ್ದನ್ನು ಸಾರಾಂಶಗೊಳಿಸಿ';
}
