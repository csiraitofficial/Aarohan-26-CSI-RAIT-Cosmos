// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String welcomeTo(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get checkingBackend => 'Checking backend…';

  @override
  String get backendConnected => 'Backend Connected';

  @override
  String get noBackendTapRetry => 'No Backend — Tap to retry';

  @override
  String get continueAsStudent => 'Continue as Student';

  @override
  String get continueAsDoctor => 'Continue as Doctor';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get loginAsStudent => 'Login as Student';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get quickLogin => 'Quick Login (Direct Sign In)';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get directSignInFailed => 'Direct Sign In Failed';

  @override
  String get createAccount => 'Create Account';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get emergencyContactNumber => 'Emergency Contact Number';

  @override
  String get gender => 'Gender';

  @override
  String get healthProfileSelect => 'Health Profile  (select all that apply)';

  @override
  String get menstrualCycleTracking => 'Menstrual Cycle Tracking';

  @override
  String get lastPeriodStartDate => 'Last Period Start Date';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get averageCycleLength => 'Average Cycle Length';

  @override
  String get averagePeriodDuration => 'Average Period Duration';

  @override
  String get days => 'days';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterUsername => 'Enter a username';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get enterValidPhone =>
      'Enter a valid phone number (e.g. +919876543210)';

  @override
  String get selectLastPeriodDate => 'Select last period start date';

  @override
  String get pleaseSelectLastPeriod =>
      'Please select your last period start date.';

  @override
  String get accountCreated => 'Account created! Please log in.';

  @override
  String get signUpFailed => 'Sign up failed. Username may already be taken.';

  @override
  String get emergencyContactHelper =>
      'Receives SMS with your GPS location during a heart rate spike';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get catGeneral => 'General Wellness';

  @override
  String get catPregnancy => 'Pregnancy';

  @override
  String get catEpilepsy => 'Epilepsy / Seizures';

  @override
  String get catAutism => 'Autism Spectrum (ASD)';

  @override
  String get catDiabetes1 => 'Type 1 Diabetes';

  @override
  String get catDiabetes2 => 'Type 2 Diabetes';

  @override
  String get catHypertension => 'Hypertension (High BP)';

  @override
  String get catHeart => 'Heart Condition';

  @override
  String get catAsthma => 'Asthma / Respiratory';

  @override
  String get catAnxiety => 'Anxiety / Mental Health';

  @override
  String get catDisability => 'Physical Disability';

  @override
  String get catSurgery => 'Post-Surgery Recovery';

  @override
  String get catElderly => 'Elderly / Senior Care';

  @override
  String get doctorLogin => 'Doctor Login';

  @override
  String get mobile => 'Mobile';

  @override
  String get pin => 'PIN';

  @override
  String get login => 'Login';

  @override
  String get registerAsDoctor => 'Register as Doctor';

  @override
  String get doctorRegistration => 'Doctor Registration';

  @override
  String get name => 'Name';

  @override
  String get degree => 'Degree';

  @override
  String get register => 'Register';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get navHome => 'Home';

  @override
  String get navVitals => 'Vitals';

  @override
  String get navSign => 'Sign';

  @override
  String get navAiTutor => 'AI Tutor';

  @override
  String get navProfile => 'Profile';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get healthSnapshot => 'Your health snapshot';

  @override
  String get testEmergencyAlert => 'Test Emergency Alert';

  @override
  String get simulateVitals =>
      'Simulate HR / BP / Glucose to trigger SMS + buzz';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get bp => 'BP';

  @override
  String get steps => 'Steps';

  @override
  String get calories => 'Calories';

  @override
  String get activeMin => 'Active Min';

  @override
  String get glucose => 'Glucose';

  @override
  String get spo2 => 'SpO2';

  @override
  String get stress => 'Stress';

  @override
  String get emergencyVitalsSimulator => 'Emergency Vitals Simulator';

  @override
  String get slideValuesAbove =>
      'Slide values above threshold to unlock the trigger button.';

  @override
  String get applyMockVitals => 'Apply Mock Vitals to Dashboard';

  @override
  String get triggerEmergencyAlert => 'Trigger Emergency Alert';

  @override
  String get raiseValueAbove => 'Raise a value above threshold first';

  @override
  String get testEmergencyAlertTitle => '[TEST] Emergency Alert';

  @override
  String get heartRateSpikeDetected => 'Heart Rate Spike Detected';

  @override
  String get dismiss => 'DISMISS';

  @override
  String get backendDisconnected => 'Backend Disconnected';

  @override
  String get refreshVitals => 'Refresh Vitals';

  @override
  String get specialNeedsModeOnTap => 'Special Needs Mode: ON (tap to toggle)';

  @override
  String get specialNeedsModeOffTap =>
      'Special Needs Mode: OFF (tap to toggle)';

  @override
  String get notificationsNone => 'Notifications (fake: No new alerts)';

  @override
  String get vitals => 'Vitals';

  @override
  String get signLanguage => 'Sign Language';

  @override
  String get offlineAi => 'Offline AI';

  @override
  String get profile => 'Profile';

  @override
  String mockHeartRateMsg(int hr) {
    return 'Mock heart rate: $hr BPM\n\nThis is a test. In a real spike, emergency contacts are notified with your GPS location.';
  }

  @override
  String realSpikeMsg(int hr) {
    return 'Heart rate: $hr BPM\n\nEmergency contacts and doctor have been notified with your GPS location.';
  }

  @override
  String get systolicBp => 'Systolic Blood Pressure';

  @override
  String get bloodGlucose => 'Blood Glucose';

  @override
  String get noNumberSet => 'No number set at signup — enter one here';

  @override
  String get fromProfileEditable =>
      'From your profile (editable for this test)';

  @override
  String aboveThreshold(String threshold, String unit) {
    return 'Above $threshold $unit — will trigger alert';
  }

  @override
  String normalThreshold(String threshold, String unit) {
    return 'Normal  |  Threshold: $threshold $unit';
  }

  @override
  String get specialNeedsOnAlerts =>
      'Special Needs Mode: ON — spike alerts enabled';

  @override
  String get specialNeedsManual => '(manual)';

  @override
  String get specialNeedsFromProfile => '(from profile categories)';

  @override
  String get specialNeedsModeOff => 'Special Needs Mode: OFF';

  @override
  String get doctorDashboard => 'Doctor Dashboard';

  @override
  String get appointments => 'Appointments';

  @override
  String get patients => 'Patients';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get doctorInfoNotFound => 'Doctor info not found';

  @override
  String get practiceDetails => 'Practice Details';

  @override
  String get clinicLocation => 'Clinic Location';

  @override
  String get signifyMedicalCenter => 'signify Medical Center';

  @override
  String get availableHours => 'Available Hours';

  @override
  String get doctorId => 'Doctor ID';

  @override
  String get totalPatients => 'Total Patients';

  @override
  String get noAppointments => 'No appointments';

  @override
  String timeLabel(String time) {
    return 'Time: $time';
  }

  @override
  String get confirmed => 'Confirmed';

  @override
  String get confirm => 'Confirm';

  @override
  String get myPatients => 'My Patients';

  @override
  String get prioritySort => 'Priority Sort';

  @override
  String get noPatients => 'No patients';

  @override
  String priorityLevel(String level) {
    return 'Priority: $level';
  }

  @override
  String get reloadAppointments => 'Reload Appointments';

  @override
  String get reloadPatients => 'Reload Patients';

  @override
  String get patientVitals => 'Patient Vitals';

  @override
  String get noPatientSelected => 'No patient selected';

  @override
  String get keyHealthIndicators => 'Key Health Indicators';

  @override
  String get bloodPressure => 'Blood Pressure';

  @override
  String get todaysSteps => 'Today\'s Steps';

  @override
  String get activeTime => 'Active Time';

  @override
  String healthStatusLabel(String status) {
    return 'Health Status: $status';
  }

  @override
  String get normal => 'Normal';

  @override
  String get attentionRequired => 'Attention Required';

  @override
  String get allVitalsNormal => 'All vitals are within normal range.';

  @override
  String get heartRateOutsideOptimal =>
      'Heart rate is outside the optimal range.';

  @override
  String get failedToLoadVitals => 'Failed to load vitals';

  @override
  String get reloadVitals => 'Reload Vitals';

  @override
  String get dailyStats => 'Daily Stats';

  @override
  String get activeMinutes => 'Active Minutes';

  @override
  String get latestReadings => 'Latest Readings';

  @override
  String get sleep => 'Sleep';

  @override
  String get noDataFound =>
      'No data found. Sync your watch or insert mock data.';

  @override
  String get refreshData => 'Refresh Data';

  @override
  String get insertMockData => 'Insert Mock Data (Testing)';

  @override
  String get authorizeHealthConnect =>
      'Please authorize Health Connect and fetch data.';

  @override
  String get writingMockData => 'Writing mock data...';

  @override
  String get mockDataInjected => 'Mock data injected successfully!';

  @override
  String get failedToInjectMock => 'Failed to inject mock data.';

  @override
  String studentIdLabel(String id) {
    return 'Student ID: $id';
  }

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get notProvided => 'Not provided';

  @override
  String get healthProfile => 'Health Profile';

  @override
  String get noCategoriesSelected => 'No categories selected';

  @override
  String get menstrualCycle => 'Menstrual Cycle';

  @override
  String get lastPeriod => 'Last Period';

  @override
  String get cycleLength => 'Cycle Length';

  @override
  String get periodDuration => 'Period Duration';

  @override
  String get notSet => 'Not set';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get student => 'Student';

  @override
  String get aiTutorWelcome =>
      'Hi! I\'m your AI Tutor. I\'m here to help you learn at your own pace.\n\nYou can ask me anything, upload a textbook chapter for a summary, use the quick buttons below, or click the microphone icon for voice input!';

  @override
  String get connectToOllama => 'Please connect to Ollama first';

  @override
  String get failedToReadFile => 'Failed to read file';

  @override
  String get summarizingMaterial => 'Summarizing your material…';

  @override
  String get failedToSummarize => 'Failed to summarize';

  @override
  String summaryTitle(String filename) {
    return 'Summary: $filename';
  }

  @override
  String get failedToSummarizeMaterial =>
      'Failed to summarize the material. Please try again or ask me questions about it directly!';

  @override
  String get errorUploadingFile => 'Error uploading file';

  @override
  String get thinking => 'Thinking…';

  @override
  String get explainSimply => 'Explain Simply';

  @override
  String get quizMe => 'Quiz Me';

  @override
  String get summarize => 'Summarize';

  @override
  String get typeOrVoice => 'Type or use mic for voice input…';

  @override
  String get tutorNotAvailable => 'Tutor not available…';

  @override
  String get startVoiceInput => 'Start voice input (for disabled students)';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get ttsOn => 'TTS On (replies will be read aloud)';

  @override
  String get ttsOff => 'TTS Off';

  @override
  String get listeningSpeak => 'Listening... speak now';

  @override
  String get speechNotAvailable => 'Speech recognition not available';

  @override
  String get checkingTutorConnection => 'Checking tutor connection…';

  @override
  String get tutorConnected => 'Tutor connected';

  @override
  String get tutorOffline => 'Tutor offline — retrying automatically…';

  @override
  String get upload => 'Upload';

  @override
  String get ttsEnabled => 'Text-to-speech enabled';

  @override
  String get signLanguageIot => 'Sign Language IoT';

  @override
  String get pcHubConnected => 'PC Hub: Connected';

  @override
  String get receivingTransmissions =>
      'Receiving real-time glove transmissions';

  @override
  String get smartGlove => 'Smart Glove — 5 Finger Flex';

  @override
  String get thumb => 'Thumb';

  @override
  String get indexFinger => 'Index';

  @override
  String get middleFinger => 'Middle';

  @override
  String get ringFinger => 'Ring';

  @override
  String get pinkyFinger => 'Pinky';

  @override
  String get aiTranslation => 'AI Translation (Ollama)';

  @override
  String get detectedGesture => 'Detected Gesture:';

  @override
  String get waiting => 'WAITING...';

  @override
  String get llmFluentSpeech => 'LLM Fluent Speech:';

  @override
  String get waitingForOllama => 'Waiting for Ollama...';

  @override
  String get liveModeConnected =>
      'Live mode — connected to PC Hub. Flex values from smart glove in real-time.';

  @override
  String get remindersComingSoon =>
      'Medication & Appointment Reminders\n(Coming soon)';

  @override
  String get explainSimplyPrompt => 'Please explain this in simpler words';

  @override
  String get quizMePrompt => 'Ask me 3 questions about what we just discussed';

  @override
  String get summarizePrompt => 'Summarize what we\'ve covered so far';
}
