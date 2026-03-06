import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
    Locale('ur'),
  ];

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String welcomeTo(String appName);

  /// No description provided for @checkingBackend.
  ///
  /// In en, this message translates to:
  /// **'Checking backend…'**
  String get checkingBackend;

  /// No description provided for @backendConnected.
  ///
  /// In en, this message translates to:
  /// **'Backend Connected'**
  String get backendConnected;

  /// No description provided for @noBackendTapRetry.
  ///
  /// In en, this message translates to:
  /// **'No Backend — Tap to retry'**
  String get noBackendTapRetry;

  /// No description provided for @continueAsStudent.
  ///
  /// In en, this message translates to:
  /// **'Continue as Student'**
  String get continueAsStudent;

  /// No description provided for @continueAsDoctor.
  ///
  /// In en, this message translates to:
  /// **'Continue as Doctor'**
  String get continueAsDoctor;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginAsStudent.
  ///
  /// In en, this message translates to:
  /// **'Login as Student'**
  String get loginAsStudent;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontHaveAccount;

  /// No description provided for @quickLogin.
  ///
  /// In en, this message translates to:
  /// **'Quick Login (Direct Sign In)'**
  String get quickLogin;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @directSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Direct Sign In Failed'**
  String get directSignInFailed;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @emergencyContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Number'**
  String get emergencyContactNumber;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @healthProfileSelect.
  ///
  /// In en, this message translates to:
  /// **'Health Profile  (select all that apply)'**
  String get healthProfileSelect;

  /// No description provided for @menstrualCycleTracking.
  ///
  /// In en, this message translates to:
  /// **'Menstrual Cycle Tracking'**
  String get menstrualCycleTracking;

  /// No description provided for @lastPeriodStartDate.
  ///
  /// In en, this message translates to:
  /// **'Last Period Start Date'**
  String get lastPeriodStartDate;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @averageCycleLength.
  ///
  /// In en, this message translates to:
  /// **'Average Cycle Length'**
  String get averageCycleLength;

  /// No description provided for @averagePeriodDuration.
  ///
  /// In en, this message translates to:
  /// **'Average Period Duration'**
  String get averagePeriodDuration;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter a username'**
  String get enterUsername;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (e.g. +919876543210)'**
  String get enterValidPhone;

  /// No description provided for @selectLastPeriodDate.
  ///
  /// In en, this message translates to:
  /// **'Select last period start date'**
  String get selectLastPeriodDate;

  /// No description provided for @pleaseSelectLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'Please select your last period start date.'**
  String get pleaseSelectLastPeriod;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please log in.'**
  String get accountCreated;

  /// No description provided for @signUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed. Username may already be taken.'**
  String get signUpFailed;

  /// No description provided for @emergencyContactHelper.
  ///
  /// In en, this message translates to:
  /// **'Receives SMS with your GPS location during a heart rate spike'**
  String get emergencyContactHelper;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @catGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Wellness'**
  String get catGeneral;

  /// No description provided for @catPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get catPregnancy;

  /// No description provided for @catEpilepsy.
  ///
  /// In en, this message translates to:
  /// **'Epilepsy / Seizures'**
  String get catEpilepsy;

  /// No description provided for @catAutism.
  ///
  /// In en, this message translates to:
  /// **'Autism Spectrum (ASD)'**
  String get catAutism;

  /// No description provided for @catDiabetes1.
  ///
  /// In en, this message translates to:
  /// **'Type 1 Diabetes'**
  String get catDiabetes1;

  /// No description provided for @catDiabetes2.
  ///
  /// In en, this message translates to:
  /// **'Type 2 Diabetes'**
  String get catDiabetes2;

  /// No description provided for @catHypertension.
  ///
  /// In en, this message translates to:
  /// **'Hypertension (High BP)'**
  String get catHypertension;

  /// No description provided for @catHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart Condition'**
  String get catHeart;

  /// No description provided for @catAsthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma / Respiratory'**
  String get catAsthma;

  /// No description provided for @catAnxiety.
  ///
  /// In en, this message translates to:
  /// **'Anxiety / Mental Health'**
  String get catAnxiety;

  /// No description provided for @catDisability.
  ///
  /// In en, this message translates to:
  /// **'Physical Disability'**
  String get catDisability;

  /// No description provided for @catSurgery.
  ///
  /// In en, this message translates to:
  /// **'Post-Surgery Recovery'**
  String get catSurgery;

  /// No description provided for @catElderly.
  ///
  /// In en, this message translates to:
  /// **'Elderly / Senior Care'**
  String get catElderly;

  /// No description provided for @doctorLogin.
  ///
  /// In en, this message translates to:
  /// **'Doctor Login'**
  String get doctorLogin;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @registerAsDoctor.
  ///
  /// In en, this message translates to:
  /// **'Register as Doctor'**
  String get registerAsDoctor;

  /// No description provided for @doctorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Doctor Registration'**
  String get doctorRegistration;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degree;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navVitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get navVitals;

  /// No description provided for @navSign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get navSign;

  /// No description provided for @navAiTutor.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get navAiTutor;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @healthSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Your health snapshot'**
  String get healthSnapshot;

  /// No description provided for @testEmergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Test Emergency Alert'**
  String get testEmergencyAlert;

  /// No description provided for @simulateVitals.
  ///
  /// In en, this message translates to:
  /// **'Simulate HR / BP / Glucose to trigger SMS + buzz'**
  String get simulateVitals;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @bp.
  ///
  /// In en, this message translates to:
  /// **'BP'**
  String get bp;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @activeMin.
  ///
  /// In en, this message translates to:
  /// **'Active Min'**
  String get activeMin;

  /// No description provided for @glucose.
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get glucose;

  /// No description provided for @spo2.
  ///
  /// In en, this message translates to:
  /// **'SpO2'**
  String get spo2;

  /// No description provided for @stress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get stress;

  /// No description provided for @emergencyVitalsSimulator.
  ///
  /// In en, this message translates to:
  /// **'Emergency Vitals Simulator'**
  String get emergencyVitalsSimulator;

  /// No description provided for @slideValuesAbove.
  ///
  /// In en, this message translates to:
  /// **'Slide values above threshold to unlock the trigger button.'**
  String get slideValuesAbove;

  /// No description provided for @applyMockVitals.
  ///
  /// In en, this message translates to:
  /// **'Apply Mock Vitals to Dashboard'**
  String get applyMockVitals;

  /// No description provided for @triggerEmergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Trigger Emergency Alert'**
  String get triggerEmergencyAlert;

  /// No description provided for @raiseValueAbove.
  ///
  /// In en, this message translates to:
  /// **'Raise a value above threshold first'**
  String get raiseValueAbove;

  /// No description provided for @testEmergencyAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'[TEST] Emergency Alert'**
  String get testEmergencyAlertTitle;

  /// No description provided for @heartRateSpikeDetected.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate Spike Detected'**
  String get heartRateSpikeDetected;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get dismiss;

  /// No description provided for @backendDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Backend Disconnected'**
  String get backendDisconnected;

  /// No description provided for @refreshVitals.
  ///
  /// In en, this message translates to:
  /// **'Refresh Vitals'**
  String get refreshVitals;

  /// No description provided for @specialNeedsModeOnTap.
  ///
  /// In en, this message translates to:
  /// **'Special Needs Mode: ON (tap to toggle)'**
  String get specialNeedsModeOnTap;

  /// No description provided for @specialNeedsModeOffTap.
  ///
  /// In en, this message translates to:
  /// **'Special Needs Mode: OFF (tap to toggle)'**
  String get specialNeedsModeOffTap;

  /// No description provided for @notificationsNone.
  ///
  /// In en, this message translates to:
  /// **'Notifications (fake: No new alerts)'**
  String get notificationsNone;

  /// No description provided for @vitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get vitals;

  /// No description provided for @signLanguage.
  ///
  /// In en, this message translates to:
  /// **'Sign Language'**
  String get signLanguage;

  /// No description provided for @offlineAi.
  ///
  /// In en, this message translates to:
  /// **'Offline AI'**
  String get offlineAi;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @mockHeartRateMsg.
  ///
  /// In en, this message translates to:
  /// **'Mock heart rate: {hr} BPM\n\nThis is a test. In a real spike, emergency contacts are notified with your GPS location.'**
  String mockHeartRateMsg(int hr);

  /// No description provided for @realSpikeMsg.
  ///
  /// In en, this message translates to:
  /// **'Heart rate: {hr} BPM\n\nEmergency contacts and doctor have been notified with your GPS location.'**
  String realSpikeMsg(int hr);

  /// No description provided for @systolicBp.
  ///
  /// In en, this message translates to:
  /// **'Systolic Blood Pressure'**
  String get systolicBp;

  /// No description provided for @bloodGlucose.
  ///
  /// In en, this message translates to:
  /// **'Blood Glucose'**
  String get bloodGlucose;

  /// No description provided for @noNumberSet.
  ///
  /// In en, this message translates to:
  /// **'No number set at signup — enter one here'**
  String get noNumberSet;

  /// No description provided for @fromProfileEditable.
  ///
  /// In en, this message translates to:
  /// **'From your profile (editable for this test)'**
  String get fromProfileEditable;

  /// No description provided for @aboveThreshold.
  ///
  /// In en, this message translates to:
  /// **'Above {threshold} {unit} — will trigger alert'**
  String aboveThreshold(String threshold, String unit);

  /// No description provided for @normalThreshold.
  ///
  /// In en, this message translates to:
  /// **'Normal  |  Threshold: {threshold} {unit}'**
  String normalThreshold(String threshold, String unit);

  /// No description provided for @specialNeedsOnAlerts.
  ///
  /// In en, this message translates to:
  /// **'Special Needs Mode: ON — spike alerts enabled'**
  String get specialNeedsOnAlerts;

  /// No description provided for @specialNeedsManual.
  ///
  /// In en, this message translates to:
  /// **'(manual)'**
  String get specialNeedsManual;

  /// No description provided for @specialNeedsFromProfile.
  ///
  /// In en, this message translates to:
  /// **'(from profile categories)'**
  String get specialNeedsFromProfile;

  /// No description provided for @specialNeedsModeOff.
  ///
  /// In en, this message translates to:
  /// **'Special Needs Mode: OFF'**
  String get specialNeedsModeOff;

  /// No description provided for @doctorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Doctor Dashboard'**
  String get doctorDashboard;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @doctorInfoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Doctor info not found'**
  String get doctorInfoNotFound;

  /// No description provided for @practiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Practice Details'**
  String get practiceDetails;

  /// No description provided for @clinicLocation.
  ///
  /// In en, this message translates to:
  /// **'Clinic Location'**
  String get clinicLocation;

  /// No description provided for @signifyMedicalCenter.
  ///
  /// In en, this message translates to:
  /// **'signify Medical Center'**
  String get signifyMedicalCenter;

  /// No description provided for @availableHours.
  ///
  /// In en, this message translates to:
  /// **'Available Hours'**
  String get availableHours;

  /// No description provided for @doctorId.
  ///
  /// In en, this message translates to:
  /// **'Doctor ID'**
  String get doctorId;

  /// No description provided for @totalPatients.
  ///
  /// In en, this message translates to:
  /// **'Total Patients'**
  String get totalPatients;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments'**
  String get noAppointments;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String timeLabel(String time);

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @myPatients.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get myPatients;

  /// No description provided for @prioritySort.
  ///
  /// In en, this message translates to:
  /// **'Priority Sort'**
  String get prioritySort;

  /// No description provided for @noPatients.
  ///
  /// In en, this message translates to:
  /// **'No patients'**
  String get noPatients;

  /// No description provided for @priorityLevel.
  ///
  /// In en, this message translates to:
  /// **'Priority: {level}'**
  String priorityLevel(String level);

  /// No description provided for @reloadAppointments.
  ///
  /// In en, this message translates to:
  /// **'Reload Appointments'**
  String get reloadAppointments;

  /// No description provided for @reloadPatients.
  ///
  /// In en, this message translates to:
  /// **'Reload Patients'**
  String get reloadPatients;

  /// No description provided for @patientVitals.
  ///
  /// In en, this message translates to:
  /// **'Patient Vitals'**
  String get patientVitals;

  /// No description provided for @noPatientSelected.
  ///
  /// In en, this message translates to:
  /// **'No patient selected'**
  String get noPatientSelected;

  /// No description provided for @keyHealthIndicators.
  ///
  /// In en, this message translates to:
  /// **'Key Health Indicators'**
  String get keyHealthIndicators;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bloodPressure;

  /// No description provided for @todaysSteps.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Steps'**
  String get todaysSteps;

  /// No description provided for @activeTime.
  ///
  /// In en, this message translates to:
  /// **'Active Time'**
  String get activeTime;

  /// No description provided for @healthStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Health Status: {status}'**
  String healthStatusLabel(String status);

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @attentionRequired.
  ///
  /// In en, this message translates to:
  /// **'Attention Required'**
  String get attentionRequired;

  /// No description provided for @allVitalsNormal.
  ///
  /// In en, this message translates to:
  /// **'All vitals are within normal range.'**
  String get allVitalsNormal;

  /// No description provided for @heartRateOutsideOptimal.
  ///
  /// In en, this message translates to:
  /// **'Heart rate is outside the optimal range.'**
  String get heartRateOutsideOptimal;

  /// No description provided for @failedToLoadVitals.
  ///
  /// In en, this message translates to:
  /// **'Failed to load vitals'**
  String get failedToLoadVitals;

  /// No description provided for @reloadVitals.
  ///
  /// In en, this message translates to:
  /// **'Reload Vitals'**
  String get reloadVitals;

  /// No description provided for @dailyStats.
  ///
  /// In en, this message translates to:
  /// **'Daily Stats'**
  String get dailyStats;

  /// No description provided for @activeMinutes.
  ///
  /// In en, this message translates to:
  /// **'Active Minutes'**
  String get activeMinutes;

  /// No description provided for @latestReadings.
  ///
  /// In en, this message translates to:
  /// **'Latest Readings'**
  String get latestReadings;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found. Sync your watch or insert mock data.'**
  String get noDataFound;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No description provided for @insertMockData.
  ///
  /// In en, this message translates to:
  /// **'Insert Mock Data (Testing)'**
  String get insertMockData;

  /// No description provided for @authorizeHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Please authorize Health Connect and fetch data.'**
  String get authorizeHealthConnect;

  /// No description provided for @writingMockData.
  ///
  /// In en, this message translates to:
  /// **'Writing mock data...'**
  String get writingMockData;

  /// No description provided for @mockDataInjected.
  ///
  /// In en, this message translates to:
  /// **'Mock data injected successfully!'**
  String get mockDataInjected;

  /// No description provided for @failedToInjectMock.
  ///
  /// In en, this message translates to:
  /// **'Failed to inject mock data.'**
  String get failedToInjectMock;

  /// No description provided for @studentIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Student ID: {id}'**
  String studentIdLabel(String id);

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @healthProfile.
  ///
  /// In en, this message translates to:
  /// **'Health Profile'**
  String get healthProfile;

  /// No description provided for @noCategoriesSelected.
  ///
  /// In en, this message translates to:
  /// **'No categories selected'**
  String get noCategoriesSelected;

  /// No description provided for @menstrualCycle.
  ///
  /// In en, this message translates to:
  /// **'Menstrual Cycle'**
  String get menstrualCycle;

  /// No description provided for @lastPeriod.
  ///
  /// In en, this message translates to:
  /// **'Last Period'**
  String get lastPeriod;

  /// No description provided for @cycleLength.
  ///
  /// In en, this message translates to:
  /// **'Cycle Length'**
  String get cycleLength;

  /// No description provided for @periodDuration.
  ///
  /// In en, this message translates to:
  /// **'Period Duration'**
  String get periodDuration;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @aiTutorWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m your AI Tutor. I\'m here to help you learn at your own pace.\n\nYou can ask me anything, upload a textbook chapter for a summary, use the quick buttons below, or click the microphone icon for voice input!'**
  String get aiTutorWelcome;

  /// No description provided for @connectToOllama.
  ///
  /// In en, this message translates to:
  /// **'Please connect to Ollama first'**
  String get connectToOllama;

  /// No description provided for @failedToReadFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to read file'**
  String get failedToReadFile;

  /// No description provided for @summarizingMaterial.
  ///
  /// In en, this message translates to:
  /// **'Summarizing your material…'**
  String get summarizingMaterial;

  /// No description provided for @failedToSummarize.
  ///
  /// In en, this message translates to:
  /// **'Failed to summarize'**
  String get failedToSummarize;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary: {filename}'**
  String summaryTitle(String filename);

  /// No description provided for @failedToSummarizeMaterial.
  ///
  /// In en, this message translates to:
  /// **'Failed to summarize the material. Please try again or ask me questions about it directly!'**
  String get failedToSummarizeMaterial;

  /// No description provided for @errorUploadingFile.
  ///
  /// In en, this message translates to:
  /// **'Error uploading file'**
  String get errorUploadingFile;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get thinking;

  /// No description provided for @explainSimply.
  ///
  /// In en, this message translates to:
  /// **'Explain Simply'**
  String get explainSimply;

  /// No description provided for @quizMe.
  ///
  /// In en, this message translates to:
  /// **'Quiz Me'**
  String get quizMe;

  /// No description provided for @summarize.
  ///
  /// In en, this message translates to:
  /// **'Summarize'**
  String get summarize;

  /// No description provided for @typeOrVoice.
  ///
  /// In en, this message translates to:
  /// **'Type or use mic for voice input…'**
  String get typeOrVoice;

  /// No description provided for @tutorNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Tutor not available…'**
  String get tutorNotAvailable;

  /// No description provided for @startVoiceInput.
  ///
  /// In en, this message translates to:
  /// **'Start voice input (for disabled students)'**
  String get startVoiceInput;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// No description provided for @ttsOn.
  ///
  /// In en, this message translates to:
  /// **'TTS On (replies will be read aloud)'**
  String get ttsOn;

  /// No description provided for @ttsOff.
  ///
  /// In en, this message translates to:
  /// **'TTS Off'**
  String get ttsOff;

  /// No description provided for @listeningSpeak.
  ///
  /// In en, this message translates to:
  /// **'Listening... speak now'**
  String get listeningSpeak;

  /// No description provided for @speechNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition not available'**
  String get speechNotAvailable;

  /// No description provided for @checkingTutorConnection.
  ///
  /// In en, this message translates to:
  /// **'Checking tutor connection…'**
  String get checkingTutorConnection;

  /// No description provided for @tutorConnected.
  ///
  /// In en, this message translates to:
  /// **'Tutor connected'**
  String get tutorConnected;

  /// No description provided for @tutorOffline.
  ///
  /// In en, this message translates to:
  /// **'Tutor offline — retrying automatically…'**
  String get tutorOffline;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @ttsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech enabled'**
  String get ttsEnabled;

  /// No description provided for @signLanguageIot.
  ///
  /// In en, this message translates to:
  /// **'Sign Language IoT'**
  String get signLanguageIot;

  /// No description provided for @pcHubConnected.
  ///
  /// In en, this message translates to:
  /// **'PC Hub: Connected'**
  String get pcHubConnected;

  /// No description provided for @receivingTransmissions.
  ///
  /// In en, this message translates to:
  /// **'Receiving real-time glove transmissions'**
  String get receivingTransmissions;

  /// No description provided for @smartGlove.
  ///
  /// In en, this message translates to:
  /// **'Smart Glove — 5 Finger Flex'**
  String get smartGlove;

  /// No description provided for @thumb.
  ///
  /// In en, this message translates to:
  /// **'Thumb'**
  String get thumb;

  /// No description provided for @indexFinger.
  ///
  /// In en, this message translates to:
  /// **'Index'**
  String get indexFinger;

  /// No description provided for @middleFinger.
  ///
  /// In en, this message translates to:
  /// **'Middle'**
  String get middleFinger;

  /// No description provided for @ringFinger.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get ringFinger;

  /// No description provided for @pinkyFinger.
  ///
  /// In en, this message translates to:
  /// **'Pinky'**
  String get pinkyFinger;

  /// No description provided for @aiTranslation.
  ///
  /// In en, this message translates to:
  /// **'AI Translation (Ollama)'**
  String get aiTranslation;

  /// No description provided for @detectedGesture.
  ///
  /// In en, this message translates to:
  /// **'Detected Gesture:'**
  String get detectedGesture;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'WAITING...'**
  String get waiting;

  /// No description provided for @llmFluentSpeech.
  ///
  /// In en, this message translates to:
  /// **'LLM Fluent Speech:'**
  String get llmFluentSpeech;

  /// No description provided for @waitingForOllama.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Ollama...'**
  String get waitingForOllama;

  /// No description provided for @liveModeConnected.
  ///
  /// In en, this message translates to:
  /// **'Live mode — connected to PC Hub. Flex values from smart glove in real-time.'**
  String get liveModeConnected;

  /// No description provided for @remindersComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Medication & Appointment Reminders\n(Coming soon)'**
  String get remindersComingSoon;

  /// No description provided for @explainSimplyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please explain this in simpler words'**
  String get explainSimplyPrompt;

  /// No description provided for @quizMePrompt.
  ///
  /// In en, this message translates to:
  /// **'Ask me 3 questions about what we just discussed'**
  String get quizMePrompt;

  /// No description provided for @summarizePrompt.
  ///
  /// In en, this message translates to:
  /// **'Summarize what we\'ve covered so far'**
  String get summarizePrompt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'or',
    'pa',
    'ta',
    'te',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
