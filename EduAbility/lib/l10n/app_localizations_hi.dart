// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String welcomeTo(String appName) {
    return '$appName में आपका स्वागत है';
  }

  @override
  String get checkingBackend => 'बैकएंड की जाँच हो रही है…';

  @override
  String get backendConnected => 'बैकएंड जुड़ गया';

  @override
  String get noBackendTapRetry => 'बैकएंड नहीं मिला — पुनः प्रयास करें';

  @override
  String get continueAsStudent => 'छात्र के रूप में जारी रखें';

  @override
  String get continueAsDoctor => 'डॉक्टर के रूप में जारी रखें';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get password => 'पासवर्ड';

  @override
  String get loginAsStudent => 'छात्र के रूप में लॉगिन करें';

  @override
  String get dontHaveAccount => 'खाता नहीं है? साइन अप करें';

  @override
  String get quickLogin => 'त्वरित लॉगिन (सीधा साइन इन)';

  @override
  String get invalidCredentials => 'अमान्य प्रमाण-पत्र';

  @override
  String get directSignInFailed => 'सीधा साइन इन विफल रहा';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get basicInformation => 'मूलभूत जानकारी';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get emergencyContactNumber => 'आपातकालीन संपर्क नंबर';

  @override
  String get gender => 'लिंग';

  @override
  String get healthProfileSelect =>
      'स्वास्थ्य प्रोफ़ाइल (सभी लागू विकल्प चुनें)';

  @override
  String get menstrualCycleTracking => 'मासिक धर्म चक्र ट्रैकिंग';

  @override
  String get lastPeriodStartDate => 'अंतिम मासिक धर्म की आरंभ तिथि';

  @override
  String get tapToSelect => 'चुनने के लिए टैप करें';

  @override
  String get averageCycleLength => 'औसत चक्र अवधि';

  @override
  String get averagePeriodDuration => 'औसत मासिक धर्म अवधि';

  @override
  String get days => 'दिन';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? लॉगिन करें';

  @override
  String get enterYourName => 'अपना नाम दर्ज करें';

  @override
  String get enterUsername => 'उपयोगकर्ता नाम दर्ज करें';

  @override
  String get passwordMinLength => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get enterValidPhone =>
      'एक मान्य फ़ोन नंबर दर्ज करें (जैसे +919876543210)';

  @override
  String get selectLastPeriodDate => 'अंतिम मासिक धर्म की तिथि चुनें';

  @override
  String get pleaseSelectLastPeriod =>
      'कृपया अपने अंतिम मासिक धर्म की आरंभ तिथि चुनें।';

  @override
  String get accountCreated => 'खाता बन गया! कृपया लॉगिन करें।';

  @override
  String get signUpFailed =>
      'साइन अप विफल रहा। उपयोगकर्ता नाम पहले से लिया जा चुका हो सकता है।';

  @override
  String get emergencyContactHelper =>
      'हृदय गति बढ़ने पर आपकी GPS स्थिति के साथ SMS प्राप्त करता है';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get other => 'अन्य';

  @override
  String get catGeneral => 'सामान्य स्वास्थ्य';

  @override
  String get catPregnancy => 'गर्भावस्था';

  @override
  String get catEpilepsy => 'मिर्गी / दौरे';

  @override
  String get catAutism => 'ऑटिज़्म स्पेक्ट्रम (ASD)';

  @override
  String get catDiabetes1 => 'टाइप 1 मधुमेह';

  @override
  String get catDiabetes2 => 'टाइप 2 मधुमेह';

  @override
  String get catHypertension => 'उच्च रक्तचाप (हाई BP)';

  @override
  String get catHeart => 'हृदय रोग';

  @override
  String get catAsthma => 'दमा / श्वसन संबंधी';

  @override
  String get catAnxiety => 'चिंता / मानसिक स्वास्थ्य';

  @override
  String get catDisability => 'शारीरिक अक्षमता';

  @override
  String get catSurgery => 'शल्य चिकित्सा के बाद स्वास्थ्य लाभ';

  @override
  String get catElderly => 'वृद्ध / वरिष्ठ देखभाल';

  @override
  String get doctorLogin => 'डॉक्टर लॉगिन';

  @override
  String get mobile => 'मोबाइल';

  @override
  String get pin => 'PIN';

  @override
  String get login => 'लॉगिन';

  @override
  String get registerAsDoctor => 'डॉक्टर के रूप में पंजीकरण करें';

  @override
  String get doctorRegistration => 'डॉक्टर पंजीकरण';

  @override
  String get name => 'नाम';

  @override
  String get degree => 'डिग्री';

  @override
  String get register => 'पंजीकरण करें';

  @override
  String get registrationFailed => 'पंजीकरण विफल रहा';

  @override
  String get navHome => 'होम';

  @override
  String get navVitals => 'वाइटल्स';

  @override
  String get navSign => 'सांकेतिक';

  @override
  String get navAiTutor => 'AI ट्यूटर';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'नमस्कार';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get healthSnapshot => 'आपकी स्वास्थ्य झलक';

  @override
  String get testEmergencyAlert => 'आपातकालीन अलर्ट परीक्षण';

  @override
  String get simulateVitals =>
      'SMS + बज़ ट्रिगर करने के लिए HR / BP / ग्लूकोज़ सिमुलेट करें';

  @override
  String get heartRate => 'हृदय गति';

  @override
  String get bp => 'BP';

  @override
  String get steps => 'कदम';

  @override
  String get calories => 'कैलोरी';

  @override
  String get activeMin => 'सक्रिय मिनट';

  @override
  String get glucose => 'ग्लूकोज़';

  @override
  String get spo2 => 'SpO2';

  @override
  String get stress => 'तनाव';

  @override
  String get emergencyVitalsSimulator => 'आपातकालीन वाइटल्स सिम्युलेटर';

  @override
  String get slideValuesAbove =>
      'ट्रिगर बटन सक्रिय करने के लिए मान सीमा से ऊपर स्लाइड करें।';

  @override
  String get applyMockVitals => 'डैशबोर्ड पर नकली वाइटल्स लागू करें';

  @override
  String get triggerEmergencyAlert => 'आपातकालीन अलर्ट ट्रिगर करें';

  @override
  String get raiseValueAbove => 'पहले किसी मान को सीमा से ऊपर बढ़ाएँ';

  @override
  String get testEmergencyAlertTitle => '[परीक्षण] आपातकालीन अलर्ट';

  @override
  String get heartRateSpikeDetected => 'हृदय गति में अचानक वृद्धि पाई गई';

  @override
  String get dismiss => 'खारिज करें';

  @override
  String get backendDisconnected => 'बैकएंड डिस्कनेक्ट हो गया';

  @override
  String get refreshVitals => 'वाइटल्स ताज़ा करें';

  @override
  String get specialNeedsModeOnTap =>
      'विशेष आवश्यकता मोड: चालू (टॉगल करने के लिए टैप करें)';

  @override
  String get specialNeedsModeOffTap =>
      'विशेष आवश्यकता मोड: बंद (टॉगल करने के लिए टैप करें)';

  @override
  String get notificationsNone => 'सूचनाएँ (नकली: कोई नई सूचना नहीं)';

  @override
  String get vitals => 'वाइटल्स';

  @override
  String get signLanguage => 'सांकेतिक भाषा';

  @override
  String get offlineAi => 'ऑफ़लाइन AI';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String mockHeartRateMsg(int hr) {
    return 'नकली हृदय गति: $hr BPM\n\nयह एक परीक्षण है। वास्तविक स्थिति में, आपातकालीन संपर्कों को आपकी GPS स्थिति के साथ सूचित किया जाएगा।';
  }

  @override
  String realSpikeMsg(int hr) {
    return 'हृदय गति: $hr BPM\n\nआपातकालीन संपर्कों और डॉक्टर को आपकी GPS स्थिति के साथ सूचित किया गया है।';
  }

  @override
  String get systolicBp => 'सिस्टोलिक रक्तचाप';

  @override
  String get bloodGlucose => 'रक्त ग्लूकोज़';

  @override
  String get noNumberSet => 'साइन अप में नंबर नहीं दिया — यहाँ दर्ज करें';

  @override
  String get fromProfileEditable =>
      'आपकी प्रोफ़ाइल से (इस परीक्षण के लिए संपादन योग्य)';

  @override
  String aboveThreshold(String threshold, String unit) {
    return '$threshold $unit से ऊपर — अलर्ट ट्रिगर होगा';
  }

  @override
  String normalThreshold(String threshold, String unit) {
    return 'सामान्य  |  सीमा: $threshold $unit';
  }

  @override
  String get specialNeedsOnAlerts =>
      'विशेष आवश्यकता मोड: चालू — स्पाइक अलर्ट सक्रिय';

  @override
  String get specialNeedsManual => '(मैन्युअल)';

  @override
  String get specialNeedsFromProfile => '(प्रोफ़ाइल श्रेणियों से)';

  @override
  String get specialNeedsModeOff => 'विशेष आवश्यकता मोड: बंद';

  @override
  String get doctorDashboard => 'डॉक्टर डैशबोर्ड';

  @override
  String get appointments => 'अपॉइंटमेंट';

  @override
  String get patients => 'मरीज़';

  @override
  String get failedToLoadProfile => 'प्रोफ़ाइल लोड करने में विफल';

  @override
  String get doctorInfoNotFound => 'डॉक्टर की जानकारी नहीं मिली';

  @override
  String get practiceDetails => 'प्रैक्टिस विवरण';

  @override
  String get clinicLocation => 'क्लिनिक स्थान';

  @override
  String get signifyMedicalCenter => 'signify मेडिकल सेंटर';

  @override
  String get availableHours => 'उपलब्ध समय';

  @override
  String get doctorId => 'डॉक्टर ID';

  @override
  String get totalPatients => 'कुल मरीज़';

  @override
  String get noAppointments => 'कोई अपॉइंटमेंट नहीं';

  @override
  String timeLabel(String time) {
    return 'समय: $time';
  }

  @override
  String get confirmed => 'पुष्टि हो गई';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get myPatients => 'मेरे मरीज़';

  @override
  String get prioritySort => 'प्राथमिकता क्रम';

  @override
  String get noPatients => 'कोई मरीज़ नहीं';

  @override
  String priorityLevel(String level) {
    return 'प्राथमिकता: $level';
  }

  @override
  String get reloadAppointments => 'अपॉइंटमेंट पुनः लोड करें';

  @override
  String get reloadPatients => 'मरीज़ पुनः लोड करें';

  @override
  String get patientVitals => 'मरीज़ के वाइटल्स';

  @override
  String get noPatientSelected => 'कोई मरीज़ चयनित नहीं';

  @override
  String get keyHealthIndicators => 'प्रमुख स्वास्थ्य संकेतक';

  @override
  String get bloodPressure => 'रक्तचाप';

  @override
  String get todaysSteps => 'आज के कदम';

  @override
  String get activeTime => 'सक्रिय समय';

  @override
  String healthStatusLabel(String status) {
    return 'स्वास्थ्य स्थिति: $status';
  }

  @override
  String get normal => 'सामान्य';

  @override
  String get attentionRequired => 'ध्यान आवश्यक';

  @override
  String get allVitalsNormal => 'सभी वाइटल्स सामान्य सीमा में हैं।';

  @override
  String get heartRateOutsideOptimal => 'हृदय गति इष्टतम सीमा से बाहर है।';

  @override
  String get failedToLoadVitals => 'वाइटल्स लोड करने में विफल';

  @override
  String get reloadVitals => 'वाइटल्स पुनः लोड करें';

  @override
  String get dailyStats => 'दैनिक आँकड़े';

  @override
  String get activeMinutes => 'सक्रिय मिनट';

  @override
  String get latestReadings => 'नवीनतम रीडिंग';

  @override
  String get sleep => 'नींद';

  @override
  String get noDataFound =>
      'कोई डेटा नहीं मिला। अपनी वॉच सिंक करें या नकली डेटा डालें।';

  @override
  String get refreshData => 'डेटा ताज़ा करें';

  @override
  String get insertMockData => 'नकली डेटा डालें (परीक्षण)';

  @override
  String get authorizeHealthConnect =>
      'कृपया Health Connect को अधिकृत करें और डेटा प्राप्त करें।';

  @override
  String get writingMockData => 'नकली डेटा लिखा जा रहा है...';

  @override
  String get mockDataInjected => 'नकली डेटा सफलतापूर्वक डाला गया!';

  @override
  String get failedToInjectMock => 'नकली डेटा डालने में विफल।';

  @override
  String studentIdLabel(String id) {
    return 'छात्र ID: $id';
  }

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get emergencyContact => 'आपातकालीन संपर्क';

  @override
  String get contactNumber => 'संपर्क नंबर';

  @override
  String get notProvided => 'उपलब्ध नहीं';

  @override
  String get healthProfile => 'स्वास्थ्य प्रोफ़ाइल';

  @override
  String get noCategoriesSelected => 'कोई श्रेणी चयनित नहीं';

  @override
  String get menstrualCycle => 'मासिक धर्म चक्र';

  @override
  String get lastPeriod => 'अंतिम मासिक धर्म';

  @override
  String get cycleLength => 'चक्र अवधि';

  @override
  String get periodDuration => 'मासिक धर्म अवधि';

  @override
  String get notSet => 'सेट नहीं है';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get language => 'भाषा';

  @override
  String get student => 'छात्र';

  @override
  String get aiTutorWelcome =>
      'नमस्ते! मैं आपका AI ट्यूटर हूँ। मैं आपकी अपनी गति से सीखने में मदद करने के लिए यहाँ हूँ।\n\nआप मुझसे कुछ भी पूछ सकते हैं, सारांश के लिए पाठ्यपुस्तक का अध्याय अपलोड कर सकते हैं, नीचे दिए गए त्वरित बटन का उपयोग कर सकते हैं, या वॉइस इनपुट के लिए माइक्रोफ़ोन आइकन पर क्लिक कर सकते हैं!';

  @override
  String get connectToOllama => 'कृपया पहले Ollama से कनेक्ट करें';

  @override
  String get failedToReadFile => 'फ़ाइल पढ़ने में विफल';

  @override
  String get summarizingMaterial => 'आपकी सामग्री का सारांश बनाया जा रहा है…';

  @override
  String get failedToSummarize => 'सारांश बनाने में विफल';

  @override
  String summaryTitle(String filename) {
    return 'सारांश: $filename';
  }

  @override
  String get failedToSummarizeMaterial =>
      'सामग्री का सारांश बनाने में विफल। कृपया पुनः प्रयास करें या इसके बारे में सीधे मुझसे प्रश्न पूछें!';

  @override
  String get errorUploadingFile => 'फ़ाइल अपलोड करने में त्रुटि';

  @override
  String get thinking => 'सोच रहा हूँ…';

  @override
  String get explainSimply => 'सरल भाषा में समझाएँ';

  @override
  String get quizMe => 'मुझसे प्रश्न पूछें';

  @override
  String get summarize => 'सारांश';

  @override
  String get typeOrVoice =>
      'टाइप करें या वॉइस इनपुट के लिए माइक का उपयोग करें…';

  @override
  String get tutorNotAvailable => 'ट्यूटर उपलब्ध नहीं है…';

  @override
  String get startVoiceInput =>
      'वॉइस इनपुट शुरू करें (दिव्यांग छात्रों के लिए)';

  @override
  String get stopRecording => 'रिकॉर्डिंग बंद करें';

  @override
  String get ttsOn => 'TTS चालू (उत्तर ज़ोर से पढ़े जाएँगे)';

  @override
  String get ttsOff => 'TTS बंद';

  @override
  String get listeningSpeak => 'सुन रहा हूँ... अब बोलें';

  @override
  String get speechNotAvailable => 'वाक् पहचान उपलब्ध नहीं है';

  @override
  String get checkingTutorConnection => 'ट्यूटर कनेक्शन जाँचा जा रहा है…';

  @override
  String get tutorConnected => 'ट्यूटर जुड़ गया';

  @override
  String get tutorOffline => 'ट्यूटर ऑफ़लाइन — स्वचालित पुनः प्रयास हो रहा है…';

  @override
  String get upload => 'अपलोड';

  @override
  String get ttsEnabled => 'टेक्स्ट-टू-स्पीच सक्रिय';

  @override
  String get signLanguageIot => 'सांकेतिक भाषा IoT';

  @override
  String get pcHubConnected => 'PC Hub: जुड़ा हुआ';

  @override
  String get receivingTransmissions =>
      'ग्लव से रीयल-टाइम ट्रांसमिशन प्राप्त हो रहा है';

  @override
  String get smartGlove => 'स्मार्ट ग्लव — 5 अंगुली फ्लेक्स';

  @override
  String get thumb => 'अंगूठा';

  @override
  String get indexFinger => 'तर्जनी';

  @override
  String get middleFinger => 'मध्यमा';

  @override
  String get ringFinger => 'अनामिका';

  @override
  String get pinkyFinger => 'कनिष्ठा';

  @override
  String get aiTranslation => 'AI अनुवाद (Ollama)';

  @override
  String get detectedGesture => 'पहचाना गया संकेत:';

  @override
  String get waiting => 'प्रतीक्षा...';

  @override
  String get llmFluentSpeech => 'LLM धाराप्रवाह वाक्:';

  @override
  String get waitingForOllama => 'Ollama की प्रतीक्षा...';

  @override
  String get liveModeConnected =>
      'लाइव मोड — PC Hub से जुड़ा। स्मार्ट ग्लव से रीयल-टाइम फ्लेक्स मान।';

  @override
  String get remindersComingSoon =>
      'दवा और अपॉइंटमेंट अनुस्मारक\n(जल्द आ रहा है)';

  @override
  String get explainSimplyPrompt => 'कृपया इसे सरल शब्दों में समझाएँ';

  @override
  String get quizMePrompt =>
      'हमने जो अभी चर्चा की, उसके बारे में मुझसे 3 प्रश्न पूछें';

  @override
  String get summarizePrompt => 'अब तक हमने जो कवर किया है उसका सारांश दें';
}
