// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String welcomeTo(String appName) {
    return '$appName-এ স্বাগতম';
  }

  @override
  String get checkingBackend => 'ব্যাকএন্ড পরীক্ষা করা হচ্ছে…';

  @override
  String get backendConnected => 'ব্যাকএন্ড সংযুক্ত';

  @override
  String get noBackendTapRetry =>
      'ব্যাকএন্ড নেই — পুনরায় চেষ্টা করতে ট্যাপ করুন';

  @override
  String get continueAsStudent => 'ছাত্র হিসাবে চালিয়ে যান';

  @override
  String get continueAsDoctor => 'ডাক্তার হিসাবে চালিয়ে যান';

  @override
  String get username => 'ব্যবহারকারীর নাম';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get loginAsStudent => 'ছাত্র হিসাবে লগইন করুন';

  @override
  String get dontHaveAccount => 'অ্যাকাউন্ট নেই? সাইন আপ করুন';

  @override
  String get quickLogin => 'দ্রুত লগইন (সরাসরি সাইন ইন)';

  @override
  String get invalidCredentials => 'অবৈধ তথ্য';

  @override
  String get directSignInFailed => 'সরাসরি সাইন ইন ব্যর্থ হয়েছে';

  @override
  String get createAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get basicInformation => 'মৌলিক তথ্য';

  @override
  String get fullName => 'পুরো নাম';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get emergencyContactNumber => 'জরুরি যোগাযোগ নম্বর';

  @override
  String get gender => 'লিঙ্গ';

  @override
  String get healthProfileSelect =>
      'স্বাস্থ্য প্রোফাইল  (প্রযোজ্য সব নির্বাচন করুন)';

  @override
  String get menstrualCycleTracking => 'মাসিক চক্র ট্র্যাকিং';

  @override
  String get lastPeriodStartDate => 'শেষ মাসিকের শুরুর তারিখ';

  @override
  String get tapToSelect => 'নির্বাচন করতে ট্যাপ করুন';

  @override
  String get averageCycleLength => 'গড় চক্রের দৈর্ঘ্য';

  @override
  String get averagePeriodDuration => 'গড় মাসিকের সময়কাল';

  @override
  String get days => 'দিন';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে? লগ ইন করুন';

  @override
  String get enterYourName => 'আপনার নাম লিখুন';

  @override
  String get enterUsername => 'একটি ব্যবহারকারীর নাম লিখুন';

  @override
  String get passwordMinLength => 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get enterValidPhone => 'একটি বৈধ ফোন নম্বর লিখুন (যেমন +919876543210)';

  @override
  String get selectLastPeriodDate => 'শেষ মাসিকের শুরুর তারিখ নির্বাচন করুন';

  @override
  String get pleaseSelectLastPeriod =>
      'অনুগ্রহ করে আপনার শেষ মাসিকের শুরুর তারিখ নির্বাচন করুন।';

  @override
  String get accountCreated =>
      'অ্যাকাউন্ট তৈরি হয়েছে! অনুগ্রহ করে লগ ইন করুন।';

  @override
  String get signUpFailed =>
      'সাইন আপ ব্যর্থ। ব্যবহারকারীর নাম ইতিমধ্যে নেওয়া হয়ে থাকতে পারে।';

  @override
  String get emergencyContactHelper =>
      'হৃদস্পন্দন বৃদ্ধির সময় আপনার GPS অবস্থানসহ SMS পাঠায়';

  @override
  String get male => 'পুরুষ';

  @override
  String get female => 'মহিলা';

  @override
  String get other => 'অন্যান্য';

  @override
  String get catGeneral => 'সাধারণ সুস্থতা';

  @override
  String get catPregnancy => 'গর্ভাবস্থা';

  @override
  String get catEpilepsy => 'মৃগী / খিঁচুনি';

  @override
  String get catAutism => 'অটিজম স্পেকট্রাম (ASD)';

  @override
  String get catDiabetes1 => 'টাইপ ১ ডায়াবেটিস';

  @override
  String get catDiabetes2 => 'টাইপ ২ ডায়াবেটিস';

  @override
  String get catHypertension => 'উচ্চ রক্তচাপ (High BP)';

  @override
  String get catHeart => 'হৃদরোগ';

  @override
  String get catAsthma => 'হাঁপানি / শ্বাসকষ্ট';

  @override
  String get catAnxiety => 'উদ্বেগ / মানসিক স্বাস্থ্য';

  @override
  String get catDisability => 'শারীরিক প্রতিবন্ধকতা';

  @override
  String get catSurgery => 'অস্ত্রোপচার-পরবর্তী পুনরুদ্ধার';

  @override
  String get catElderly => 'প্রবীণ / বয়স্ক পরিচর্যা';

  @override
  String get doctorLogin => 'ডাক্তার লগইন';

  @override
  String get mobile => 'মোবাইল';

  @override
  String get pin => 'PIN';

  @override
  String get login => 'লগইন';

  @override
  String get registerAsDoctor => 'ডাক্তার হিসাবে নিবন্ধন করুন';

  @override
  String get doctorRegistration => 'ডাক্তার নিবন্ধন';

  @override
  String get name => 'নাম';

  @override
  String get degree => 'ডিগ্রি';

  @override
  String get register => 'নিবন্ধন';

  @override
  String get registrationFailed => 'নিবন্ধন ব্যর্থ হয়েছে';

  @override
  String get navHome => 'হোম';

  @override
  String get navVitals => 'ভাইটালস';

  @override
  String get navSign => 'সাইন';

  @override
  String get navAiTutor => 'AI শিক্ষক';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get goodMorning => 'সুপ্রভাত';

  @override
  String get goodAfternoon => 'শুভ অপরাহ্ণ';

  @override
  String get goodEvening => 'শুভ সন্ধ্যা';

  @override
  String get healthSnapshot => 'আপনার স্বাস্থ্যের সারসংক্ষেপ';

  @override
  String get testEmergencyAlert => 'জরুরি সতর্কতা পরীক্ষা';

  @override
  String get simulateVitals =>
      'SMS + কম্পন সক্রিয় করতে HR / BP / গ্লুকোজ সিমুলেট করুন';

  @override
  String get heartRate => 'হৃদস্পন্দন';

  @override
  String get bp => 'রক্তচাপ';

  @override
  String get steps => 'পদক্ষেপ';

  @override
  String get calories => 'ক্যালোরি';

  @override
  String get activeMin => 'সক্রিয় মিনিট';

  @override
  String get glucose => 'গ্লুকোজ';

  @override
  String get spo2 => 'SpO2';

  @override
  String get stress => 'চাপ';

  @override
  String get emergencyVitalsSimulator => 'জরুরি ভাইটালস সিমুলেটর';

  @override
  String get slideValuesAbove =>
      'ট্রিগার বোতাম আনলক করতে মান থ্রেশহোল্ডের উপরে স্লাইড করুন।';

  @override
  String get applyMockVitals => 'ড্যাশবোর্ডে মক ভাইটালস প্রয়োগ করুন';

  @override
  String get triggerEmergencyAlert => 'জরুরি সতর্কতা সক্রিয় করুন';

  @override
  String get raiseValueAbove => 'প্রথমে একটি মান থ্রেশহোল্ডের উপরে বাড়ান';

  @override
  String get testEmergencyAlertTitle => '[পরীক্ষা] জরুরি সতর্কতা';

  @override
  String get heartRateSpikeDetected => 'হৃদস্পন্দন বৃদ্ধি শনাক্ত হয়েছে';

  @override
  String get dismiss => 'বাতিল';

  @override
  String get backendDisconnected => 'ব্যাকএন্ড সংযোগ বিচ্ছিন্ন';

  @override
  String get refreshVitals => 'ভাইটালস রিফ্রেশ করুন';

  @override
  String get specialNeedsModeOnTap =>
      'বিশেষ প্রয়োজন মোড: চালু (টগল করতে ট্যাপ করুন)';

  @override
  String get specialNeedsModeOffTap =>
      'বিশেষ প্রয়োজন মোড: বন্ধ (টগল করতে ট্যাপ করুন)';

  @override
  String get notificationsNone => 'বিজ্ঞপ্তি (নেই: কোনো নতুন সতর্কতা নেই)';

  @override
  String get vitals => 'ভাইটালস';

  @override
  String get signLanguage => 'সাংকেতিক ভাষা';

  @override
  String get offlineAi => 'অফলাইন AI';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String mockHeartRateMsg(int hr) {
    return 'মক হৃদস্পন্দন: $hr BPM\n\nএটি একটি পরীক্ষা। প্রকৃত বৃদ্ধিতে, আপনার GPS অবস্থানসহ জরুরি যোগাযোগকারীদের জানানো হবে।';
  }

  @override
  String realSpikeMsg(int hr) {
    return 'হৃদস্পন্দন: $hr BPM\n\nআপনার GPS অবস্থানসহ জরুরি যোগাযোগকারী ও ডাক্তারকে জানানো হয়েছে।';
  }

  @override
  String get systolicBp => 'সিস্টোলিক রক্তচাপ';

  @override
  String get bloodGlucose => 'রক্তের গ্লুকোজ';

  @override
  String get noNumberSet =>
      'সাইনআপে কোনো নম্বর দেওয়া হয়নি — এখানে একটি লিখুন';

  @override
  String get fromProfileEditable =>
      'আপনার প্রোফাইল থেকে (এই পরীক্ষার জন্য সম্পাদনযোগ্য)';

  @override
  String aboveThreshold(String threshold, String unit) {
    return '$threshold $unit-এর উপরে — সতর্কতা সক্রিয় হবে';
  }

  @override
  String normalThreshold(String threshold, String unit) {
    return 'স্বাভাবিক  |  থ্রেশহোল্ড: $threshold $unit';
  }

  @override
  String get specialNeedsOnAlerts =>
      'বিশেষ প্রয়োজন মোড: চালু — বৃদ্ধি সতর্কতা সক্রিয়';

  @override
  String get specialNeedsManual => '(ম্যানুয়াল)';

  @override
  String get specialNeedsFromProfile => '(প্রোফাইল বিভাগ থেকে)';

  @override
  String get specialNeedsModeOff => 'বিশেষ প্রয়োজন মোড: বন্ধ';

  @override
  String get doctorDashboard => 'ডাক্তার ড্যাশবোর্ড';

  @override
  String get appointments => 'অ্যাপয়েন্টমেন্ট';

  @override
  String get patients => 'রোগী';

  @override
  String get failedToLoadProfile => 'প্রোফাইল লোড করতে ব্যর্থ';

  @override
  String get doctorInfoNotFound => 'ডাক্তারের তথ্য পাওয়া যায়নি';

  @override
  String get practiceDetails => 'প্র্যাকটিসের বিবরণ';

  @override
  String get clinicLocation => 'ক্লিনিকের অবস্থান';

  @override
  String get signifyMedicalCenter => 'signify মেডিকেল সেন্টার';

  @override
  String get availableHours => 'উপলব্ধ সময়';

  @override
  String get doctorId => 'ডাক্তার আইডি';

  @override
  String get totalPatients => 'মোট রোগী';

  @override
  String get noAppointments => 'কোনো অ্যাপয়েন্টমেন্ট নেই';

  @override
  String timeLabel(String time) {
    return 'সময়: $time';
  }

  @override
  String get confirmed => 'নিশ্চিত';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get myPatients => 'আমার রোগী';

  @override
  String get prioritySort => 'অগ্রাধিকার অনুসারে সাজান';

  @override
  String get noPatients => 'কোনো রোগী নেই';

  @override
  String priorityLevel(String level) {
    return 'অগ্রাধিকার: $level';
  }

  @override
  String get reloadAppointments => 'অ্যাপয়েন্টমেন্ট পুনরায় লোড করুন';

  @override
  String get reloadPatients => 'রোগী পুনরায় লোড করুন';

  @override
  String get patientVitals => 'রোগীর ভাইটালস';

  @override
  String get noPatientSelected => 'কোনো রোগী নির্বাচিত নয়';

  @override
  String get keyHealthIndicators => 'প্রধান স্বাস্থ্য সূচক';

  @override
  String get bloodPressure => 'রক্তচাপ';

  @override
  String get todaysSteps => 'আজকের পদক্ষেপ';

  @override
  String get activeTime => 'সক্রিয় সময়';

  @override
  String healthStatusLabel(String status) {
    return 'স্বাস্থ্যের অবস্থা: $status';
  }

  @override
  String get normal => 'স্বাভাবিক';

  @override
  String get attentionRequired => 'মনোযোগ প্রয়োজন';

  @override
  String get allVitalsNormal => 'সব ভাইটালস স্বাভাবিক সীমার মধ্যে আছে।';

  @override
  String get heartRateOutsideOptimal => 'হৃদস্পন্দন সর্বোত্তম সীমার বাইরে।';

  @override
  String get failedToLoadVitals => 'ভাইটালস লোড করতে ব্যর্থ';

  @override
  String get reloadVitals => 'ভাইটালস পুনরায় লোড করুন';

  @override
  String get dailyStats => 'দৈনিক পরিসংখ্যান';

  @override
  String get activeMinutes => 'সক্রিয় মিনিট';

  @override
  String get latestReadings => 'সর্বশেষ রিডিং';

  @override
  String get sleep => 'ঘুম';

  @override
  String get noDataFound =>
      'কোনো ডেটা পাওয়া যায়নি। আপনার ঘড়ি সিঙ্ক করুন বা মক ডেটা ঢোকান।';

  @override
  String get refreshData => 'ডেটা রিফ্রেশ করুন';

  @override
  String get insertMockData => 'মক ডেটা ঢোকান (পরীক্ষা)';

  @override
  String get authorizeHealthConnect =>
      'অনুগ্রহ করে Health Connect অনুমোদন করুন এবং ডেটা নিন।';

  @override
  String get writingMockData => 'মক ডেটা লেখা হচ্ছে...';

  @override
  String get mockDataInjected => 'মক ডেটা সফলভাবে ঢোকানো হয়েছে!';

  @override
  String get failedToInjectMock => 'মক ডেটা ঢোকাতে ব্যর্থ।';

  @override
  String studentIdLabel(String id) {
    return 'ছাত্র আইডি: $id';
  }

  @override
  String get personalInformation => 'ব্যক্তিগত তথ্য';

  @override
  String get emergencyContact => 'জরুরি যোগাযোগ';

  @override
  String get contactNumber => 'যোগাযোগ নম্বর';

  @override
  String get notProvided => 'প্রদান করা হয়নি';

  @override
  String get healthProfile => 'স্বাস্থ্য প্রোফাইল';

  @override
  String get noCategoriesSelected => 'কোনো বিভাগ নির্বাচিত নয়';

  @override
  String get menstrualCycle => 'মাসিক চক্র';

  @override
  String get lastPeriod => 'শেষ মাসিক';

  @override
  String get cycleLength => 'চক্রের দৈর্ঘ্য';

  @override
  String get periodDuration => 'মাসিকের সময়কাল';

  @override
  String get notSet => 'নির্ধারিত নয়';

  @override
  String get logout => 'লগআউট';

  @override
  String get language => 'ভাষা';

  @override
  String get student => 'ছাত্র';

  @override
  String get aiTutorWelcome =>
      'নমস্কার! আমি আপনার AI শিক্ষক। আমি আপনাকে নিজের গতিতে শিখতে সাহায্য করতে এখানে আছি।\n\nআপনি আমাকে যেকোনো প্রশ্ন করতে পারেন, সারাংশের জন্য একটি পাঠ্যপুস্তকের অধ্যায় আপলোড করতে পারেন, নিচের দ্রুত বোতামগুলি ব্যবহার করতে পারেন, বা ভয়েস ইনপুটের জন্য মাইক্রোফোন আইকনে ক্লিক করতে পারেন!';

  @override
  String get connectToOllama => 'অনুগ্রহ করে প্রথমে Ollama-র সাথে সংযোগ করুন';

  @override
  String get failedToReadFile => 'ফাইল পড়তে ব্যর্থ';

  @override
  String get summarizingMaterial => 'আপনার উপাদান সারসংক্ষেপ করা হচ্ছে…';

  @override
  String get failedToSummarize => 'সারসংক্ষেপ করতে ব্যর্থ';

  @override
  String summaryTitle(String filename) {
    return 'সারসংক্ষেপ: $filename';
  }

  @override
  String get failedToSummarizeMaterial =>
      'উপাদানের সারসংক্ষেপ করতে ব্যর্থ। অনুগ্রহ করে আবার চেষ্টা করুন বা এটি সম্পর্কে আমাকে সরাসরি প্রশ্ন করুন!';

  @override
  String get errorUploadingFile => 'ফাইল আপলোড করতে ত্রুটি';

  @override
  String get thinking => 'চিন্তা করা হচ্ছে…';

  @override
  String get explainSimply => 'সহজভাবে ব্যাখ্যা করুন';

  @override
  String get quizMe => 'আমাকে প্রশ্ন করুন';

  @override
  String get summarize => 'সারসংক্ষেপ';

  @override
  String get typeOrVoice =>
      'টাইপ করুন বা ভয়েস ইনপুটের জন্য মাইক ব্যবহার করুন…';

  @override
  String get tutorNotAvailable => 'শিক্ষক উপলব্ধ নয়…';

  @override
  String get startVoiceInput =>
      'ভয়েস ইনপুট শুরু করুন (প্রতিবন্ধী ছাত্রদের জন্য)';

  @override
  String get stopRecording => 'রেকর্ডিং বন্ধ করুন';

  @override
  String get ttsOn => 'TTS চালু (উত্তরগুলি জোরে পড়া হবে)';

  @override
  String get ttsOff => 'TTS বন্ধ';

  @override
  String get listeningSpeak => 'শোনা হচ্ছে... এখন বলুন';

  @override
  String get speechNotAvailable => 'বাক সনাক্তকরণ উপলব্ধ নয়';

  @override
  String get checkingTutorConnection => 'শিক্ষকের সংযোগ পরীক্ষা করা হচ্ছে…';

  @override
  String get tutorConnected => 'শিক্ষক সংযুক্ত';

  @override
  String get tutorOffline =>
      'শিক্ষক অফলাইন — স্বয়ংক্রিয়ভাবে পুনরায় চেষ্টা হচ্ছে…';

  @override
  String get upload => 'আপলোড';

  @override
  String get ttsEnabled => 'টেক্সট-টু-স্পিচ সক্রিয়';

  @override
  String get signLanguageIot => 'সাংকেতিক ভাষা IoT';

  @override
  String get pcHubConnected => 'PC Hub: সংযুক্ত';

  @override
  String get receivingTransmissions =>
      'রিয়েল-টাইম গ্লাভ ট্রান্সমিশন গ্রহণ করা হচ্ছে';

  @override
  String get smartGlove => 'স্মার্ট গ্লাভ — ৫ আঙুল ফ্লেক্স';

  @override
  String get thumb => 'বুড়ো আঙুল';

  @override
  String get indexFinger => 'তর্জনী';

  @override
  String get middleFinger => 'মধ্যমা';

  @override
  String get ringFinger => 'অনামিকা';

  @override
  String get pinkyFinger => 'কনিষ্ঠা';

  @override
  String get aiTranslation => 'AI অনুবাদ (Ollama)';

  @override
  String get detectedGesture => 'শনাক্তকৃত অঙ্গভঙ্গি:';

  @override
  String get waiting => 'অপেক্ষা করা হচ্ছে...';

  @override
  String get llmFluentSpeech => 'LLM সাবলীল বাক্য:';

  @override
  String get waitingForOllama => 'Ollama-র জন্য অপেক্ষা করা হচ্ছে...';

  @override
  String get liveModeConnected =>
      'লাইভ মোড — PC Hub-এ সংযুক্ত। স্মার্ট গ্লাভ থেকে রিয়েল-টাইমে ফ্লেক্স মান।';

  @override
  String get remindersComingSoon =>
      'ওষুধ ও অ্যাপয়েন্টমেন্ট রিমাইন্ডার\n(শীঘ্রই আসছে)';

  @override
  String get explainSimplyPrompt => 'অনুগ্রহ করে এটি সহজ ভাষায় ব্যাখ্যা করুন';

  @override
  String get quizMePrompt =>
      'আমরা এইমাত্র যা আলোচনা করেছি তা থেকে আমাকে ৩টি প্রশ্ন জিজ্ঞাসা করুন';

  @override
  String get summarizePrompt =>
      'আমরা এখন পর্যন্ত যা আলোচনা করেছি তার সারসংক্ষেপ করুন';
}
