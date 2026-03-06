// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String welcomeTo(String appName) {
    return '$appName కి స్వాగతం';
  }

  @override
  String get checkingBackend => 'బ్యాకెండ్ తనిఖీ చేస్తోంది…';

  @override
  String get backendConnected => 'బ్యాకెండ్ కనెక్ట్ అయింది';

  @override
  String get noBackendTapRetry =>
      'బ్యాకెండ్ లేదు — మళ్ళీ ప్రయత్నించడానికి నొక్కండి';

  @override
  String get continueAsStudent => 'విద్యార్థిగా కొనసాగించండి';

  @override
  String get continueAsDoctor => 'వైద్యుడిగా కొనసాగించండి';

  @override
  String get username => 'వాడుకరి పేరు';

  @override
  String get password => 'పాస్‌వర్డ్';

  @override
  String get loginAsStudent => 'విద్యార్థిగా లాగిన్';

  @override
  String get dontHaveAccount => 'ఖాతా లేదా? సైన్ అప్ చేయండి';

  @override
  String get quickLogin => 'త్వరిత లాగిన్ (నేరుగా సైన్ ఇన్)';

  @override
  String get invalidCredentials => 'చెల్లని ఆధారాలు';

  @override
  String get directSignInFailed => 'నేరుగా సైన్ ఇన్ విఫలమైంది';

  @override
  String get createAccount => 'ఖాతా సృష్టించండి';

  @override
  String get basicInformation => 'ప్రాథమిక సమాచారం';

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get confirmPassword => 'పాస్‌వర్డ్ నిర్ధారించండి';

  @override
  String get emergencyContactNumber => 'అత్యవసర సంప్రదింపు నంబర్';

  @override
  String get gender => 'లింగం';

  @override
  String get healthProfileSelect =>
      'ఆరోగ్య ప్రొఫైల్ (వర్తించే అన్నింటిని ఎంచుకోండి)';

  @override
  String get menstrualCycleTracking => 'ఋతు చక్రం ట్రాకింగ్';

  @override
  String get lastPeriodStartDate => 'చివరి ఋతుస్రావం ప్రారంభ తేదీ';

  @override
  String get tapToSelect => 'ఎంచుకోవడానికి నొక్కండి';

  @override
  String get averageCycleLength => 'సగటు చక్ర వ్యవధి';

  @override
  String get averagePeriodDuration => 'సగటు ఋతుస్రావ వ్యవధి';

  @override
  String get days => 'రోజులు';

  @override
  String get alreadyHaveAccount => 'ఇప్పటికే ఖాతా ఉందా? లాగిన్ చేయండి';

  @override
  String get enterYourName => 'మీ పేరు నమోదు చేయండి';

  @override
  String get enterUsername => 'వాడుకరి పేరు నమోదు చేయండి';

  @override
  String get passwordMinLength => 'పాస్‌వర్డ్ కనీసం 6 అక్షరాలు ఉండాలి';

  @override
  String get passwordsDoNotMatch => 'పాస్‌వర్డ్‌లు సరిపోలడం లేదు';

  @override
  String get enterValidPhone =>
      'చెల్లుబాటు అయ్యే ఫోన్ నంబర్ నమోదు చేయండి (ఉదా. +919876543210)';

  @override
  String get selectLastPeriodDate => 'చివరి ఋతుస్రావం ప్రారంభ తేదీ ఎంచుకోండి';

  @override
  String get pleaseSelectLastPeriod =>
      'దయచేసి మీ చివరి ఋతుస్రావం ప్రారంభ తేదీని ఎంచుకోండి.';

  @override
  String get accountCreated => 'ఖాతా సృష్టించబడింది! దయచేసి లాగిన్ చేయండి.';

  @override
  String get signUpFailed =>
      'సైన్ అప్ విఫలమైంది. వాడుకరి పేరు ఇప్పటికే తీసుకోబడి ఉండవచ్చు.';

  @override
  String get emergencyContactHelper =>
      'హృదయ స్పందన స్పైక్ సమయంలో మీ GPS స్థానంతో SMS అందుకుంటారు';

  @override
  String get male => 'పురుషుడు';

  @override
  String get female => 'స్త్రీ';

  @override
  String get other => 'ఇతరం';

  @override
  String get catGeneral => 'సాధారణ ఆరోగ్యం';

  @override
  String get catPregnancy => 'గర్భం';

  @override
  String get catEpilepsy => 'మూర్ఛ / అపస్మారం';

  @override
  String get catAutism => 'ఆటిజం స్పెక్ట్రమ్ (ASD)';

  @override
  String get catDiabetes1 => 'టైప్ 1 మధుమేహం';

  @override
  String get catDiabetes2 => 'టైప్ 2 మధుమేహం';

  @override
  String get catHypertension => 'అధిక రక్తపోటు (High BP)';

  @override
  String get catHeart => 'గుండె సమస్య';

  @override
  String get catAsthma => 'ఆస్తమా / శ్వాసకోశ';

  @override
  String get catAnxiety => 'ఆందోళన / మానసిక ఆరోగ్యం';

  @override
  String get catDisability => 'శారీరక వైకల్యం';

  @override
  String get catSurgery => 'శస్త్రచికిత్స అనంతర కోలుకోలు';

  @override
  String get catElderly => 'వృద్ధుల సంరక్షణ';

  @override
  String get doctorLogin => 'వైద్యుడి లాగిన్';

  @override
  String get mobile => 'మొబైల్';

  @override
  String get pin => 'PIN';

  @override
  String get login => 'లాగిన్';

  @override
  String get registerAsDoctor => 'వైద్యుడిగా నమోదు చేసుకోండి';

  @override
  String get doctorRegistration => 'వైద్యుడి నమోదు';

  @override
  String get name => 'పేరు';

  @override
  String get degree => 'డిగ్రీ';

  @override
  String get register => 'నమోదు';

  @override
  String get registrationFailed => 'నమోదు విఫలమైంది';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navVitals => 'ప్రాణాధారాలు';

  @override
  String get navSign => 'సంకేతం';

  @override
  String get navAiTutor => 'AI ట్యూటర్';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get goodMorning => 'శుభోదయం';

  @override
  String get goodAfternoon => 'శుభ మధ్యాహ్నం';

  @override
  String get goodEvening => 'శుభ సాయంత్రం';

  @override
  String get healthSnapshot => 'మీ ఆరోగ్య సారాంశం';

  @override
  String get testEmergencyAlert => 'అత్యవసర హెచ్చరిక పరీక్ష';

  @override
  String get simulateVitals =>
      'SMS + బజ్ ట్రిగ్గర్ చేయడానికి HR / BP / గ్లూకోజ్ అనుకరించండి';

  @override
  String get heartRate => 'హృదయ స్పందన';

  @override
  String get bp => 'BP';

  @override
  String get steps => 'అడుగులు';

  @override
  String get calories => 'కేలరీలు';

  @override
  String get activeMin => 'చురుకు నిమి.';

  @override
  String get glucose => 'గ్లూకోజ్';

  @override
  String get spo2 => 'SpO2';

  @override
  String get stress => 'ఒత్తిడి';

  @override
  String get emergencyVitalsSimulator => 'అత్యవసర ప్రాణాధారాల సిమ్యులేటర్';

  @override
  String get slideValuesAbove =>
      'ట్రిగ్గర్ బటన్ అన్‌లాక్ చేయడానికి విలువలను థ్రెషోల్డ్ పైకి స్లైడ్ చేయండి.';

  @override
  String get applyMockVitals =>
      'డ్యాష్‌బోర్డ్‌కు నకిలీ ప్రాణాధారాలు వర్తింపజేయండి';

  @override
  String get triggerEmergencyAlert => 'అత్యవసర హెచ్చరిక ట్రిగ్గర్ చేయండి';

  @override
  String get raiseValueAbove => 'ముందుగా విలువను థ్రెషోల్డ్ పైకి పెంచండి';

  @override
  String get testEmergencyAlertTitle => '[పరీక్ష] అత్యవసర హెచ్చరిక';

  @override
  String get heartRateSpikeDetected => 'హృదయ స్పందన స్పైక్ గుర్తించబడింది';

  @override
  String get dismiss => 'తొలగించు';

  @override
  String get backendDisconnected => 'బ్యాకెండ్ డిస్‌కనెక్ట్ అయింది';

  @override
  String get refreshVitals => 'ప్రాణాధారాలు రిఫ్రెష్ చేయండి';

  @override
  String get specialNeedsModeOnTap =>
      'ప్రత్యేక అవసరాల మోడ్: ఆన్ (టోగుల్ చేయడానికి నొక్కండి)';

  @override
  String get specialNeedsModeOffTap =>
      'ప్రత్యేక అవసరాల మోడ్: ఆఫ్ (టోగుల్ చేయడానికి నొక్కండి)';

  @override
  String get notificationsNone =>
      'నోటిఫికేషన్లు (నకిలీ: కొత్త హెచ్చరికలు లేవు)';

  @override
  String get vitals => 'ప్రాణాధారాలు';

  @override
  String get signLanguage => 'సంకేత భాష';

  @override
  String get offlineAi => 'ఆఫ్‌లైన్ AI';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String mockHeartRateMsg(int hr) {
    return 'నకిలీ హృదయ స్పందన: $hr BPM\n\nఇది ఒక పరీక్ష. నిజమైన స్పైక్‌లో, అత్యవసర సంప్రదింపులకు మీ GPS స్థానంతో తెలియజేయబడతారు.';
  }

  @override
  String realSpikeMsg(int hr) {
    return 'హృదయ స్పందన: $hr BPM\n\nఅత్యవసర సంప్రదింపులు మరియు వైద్యుడికి మీ GPS స్థానంతో తెలియజేయబడింది.';
  }

  @override
  String get systolicBp => 'సిస్టోలిక్ రక్తపోటు';

  @override
  String get bloodGlucose => 'రక్తంలో గ్లూకోజ్';

  @override
  String get noNumberSet =>
      'సైన్ అప్ సమయంలో నంబర్ సెట్ చేయలేదు — ఇక్కడ నమోదు చేయండి';

  @override
  String get fromProfileEditable =>
      'మీ ప్రొఫైల్ నుండి (ఈ పరీక్ష కోసం సవరించగలరు)';

  @override
  String aboveThreshold(String threshold, String unit) {
    return '$threshold $unit కంటే ఎక్కువ — హెచ్చరిక ట్రిగ్గర్ అవుతుంది';
  }

  @override
  String normalThreshold(String threshold, String unit) {
    return 'సాధారణం  |  థ్రెషోల్డ్: $threshold $unit';
  }

  @override
  String get specialNeedsOnAlerts =>
      'ప్రత్యేక అవసరాల మోడ్: ఆన్ — స్పైక్ హెచ్చరికలు ఎనేబుల్ చేయబడ్డాయి';

  @override
  String get specialNeedsManual => '(మాన్యువల్)';

  @override
  String get specialNeedsFromProfile => '(ప్రొఫైల్ వర్గాల నుండి)';

  @override
  String get specialNeedsModeOff => 'ప్రత్యేక అవసరాల మోడ్: ఆఫ్';

  @override
  String get doctorDashboard => 'వైద్యుడి డ్యాష్‌బోర్డ్';

  @override
  String get appointments => 'అపాయింట్‌మెంట్లు';

  @override
  String get patients => 'రోగులు';

  @override
  String get failedToLoadProfile => 'ప్రొఫైల్ లోడ్ చేయడం విఫలమైంది';

  @override
  String get doctorInfoNotFound => 'వైద్యుడి సమాచారం కనుగొనబడలేదు';

  @override
  String get practiceDetails => 'ప్రాక్టీస్ వివరాలు';

  @override
  String get clinicLocation => 'క్లినిక్ స్థానం';

  @override
  String get signifyMedicalCenter => 'signify వైద్య కేంద్రం';

  @override
  String get availableHours => 'అందుబాటులో ఉన్న గంటలు';

  @override
  String get doctorId => 'వైద్యుడి ID';

  @override
  String get totalPatients => 'మొత్తం రోగులు';

  @override
  String get noAppointments => 'అపాయింట్‌మెంట్లు లేవు';

  @override
  String timeLabel(String time) {
    return 'సమయం: $time';
  }

  @override
  String get confirmed => 'నిర్ధారించబడింది';

  @override
  String get confirm => 'నిర్ధారించండి';

  @override
  String get myPatients => 'నా రోగులు';

  @override
  String get prioritySort => 'ప్రాధాన్యత క్రమం';

  @override
  String get noPatients => 'రోగులు లేరు';

  @override
  String priorityLevel(String level) {
    return 'ప్రాధాన్యత: $level';
  }

  @override
  String get reloadAppointments => 'అపాయింట్‌మెంట్లు రీలోడ్ చేయండి';

  @override
  String get reloadPatients => 'రోగులను రీలోడ్ చేయండి';

  @override
  String get patientVitals => 'రోగి ప్రాణాధారాలు';

  @override
  String get noPatientSelected => 'రోగి ఎంచుకోబడలేదు';

  @override
  String get keyHealthIndicators => 'ప్రధాన ఆరోగ్య సూచికలు';

  @override
  String get bloodPressure => 'రక్తపోటు';

  @override
  String get todaysSteps => 'ఈ రోజు అడుగులు';

  @override
  String get activeTime => 'చురుకు సమయం';

  @override
  String healthStatusLabel(String status) {
    return 'ఆరోగ్య స్థితి: $status';
  }

  @override
  String get normal => 'సాధారణం';

  @override
  String get attentionRequired => 'శ్రద్ధ అవసరం';

  @override
  String get allVitalsNormal => 'అన్ని ప్రాణాధారాలు సాధారణ పరిధిలో ఉన్నాయి.';

  @override
  String get heartRateOutsideOptimal => 'హృదయ స్పందన అనుకూల పరిధి బయట ఉంది.';

  @override
  String get failedToLoadVitals => 'ప్రాణాధారాలు లోడ్ చేయడం విఫలమైంది';

  @override
  String get reloadVitals => 'ప్రాణాధారాలు రీలోడ్ చేయండి';

  @override
  String get dailyStats => 'రోజువారీ గణాంకాలు';

  @override
  String get activeMinutes => 'చురుకు నిమిషాలు';

  @override
  String get latestReadings => 'తాజా రీడింగ్‌లు';

  @override
  String get sleep => 'నిద్ర';

  @override
  String get noDataFound =>
      'డేటా కనుగొనబడలేదు. మీ వాచ్ సింక్ చేయండి లేదా నకిలీ డేటా చేర్చండి.';

  @override
  String get refreshData => 'డేటా రిఫ్రెష్ చేయండి';

  @override
  String get insertMockData => 'నకిలీ డేటా చేర్చండి (పరీక్ష)';

  @override
  String get authorizeHealthConnect =>
      'దయచేసి Health Connect అనుమతించి డేటా పొందండి.';

  @override
  String get writingMockData => 'నకిలీ డేటా వ్రాస్తోంది...';

  @override
  String get mockDataInjected => 'నకిలీ డేటా విజయవంతంగా చేర్చబడింది!';

  @override
  String get failedToInjectMock => 'నకిలీ డేటా చేర్చడం విఫలమైంది.';

  @override
  String studentIdLabel(String id) {
    return 'విద్యార్థి ID: $id';
  }

  @override
  String get personalInformation => 'వ్యక్తిగత సమాచారం';

  @override
  String get emergencyContact => 'అత్యవసర సంప్రదింపు';

  @override
  String get contactNumber => 'సంప్రదింపు నంబర్';

  @override
  String get notProvided => 'అందించబడలేదు';

  @override
  String get healthProfile => 'ఆరోగ్య ప్రొఫైల్';

  @override
  String get noCategoriesSelected => 'వర్గాలు ఎంచుకోబడలేదు';

  @override
  String get menstrualCycle => 'ఋతు చక్రం';

  @override
  String get lastPeriod => 'చివరి ఋతుస్రావం';

  @override
  String get cycleLength => 'చక్ర వ్యవధి';

  @override
  String get periodDuration => 'ఋతుస్రావ వ్యవధి';

  @override
  String get notSet => 'సెట్ చేయలేదు';

  @override
  String get logout => 'లాగౌట్';

  @override
  String get language => 'భాష';

  @override
  String get student => 'విద్యార్థి';

  @override
  String get aiTutorWelcome =>
      'నమస్కారం! నేను మీ AI ట్యూటర్‌ని. మీ సొంత వేగంతో నేర్చుకోవడంలో మీకు సహాయం చేయడానికి ఇక్కడ ఉన్నాను.\n\nమీరు ఏదైనా అడగవచ్చు, సారాంశం కోసం పాఠ్యపుస్తక అధ్యాయం అప్‌లోడ్ చేయవచ్చు, క్రింది త్వరిత బటన్లు ఉపయోగించవచ్చు లేదా వాయిస్ ఇన్‌పుట్ కోసం మైక్రోఫోన్ చిహ్నం నొక్కవచ్చు!';

  @override
  String get connectToOllama => 'దయచేసి ముందుగా Ollama కి కనెక్ట్ అవ్వండి';

  @override
  String get failedToReadFile => 'ఫైల్ చదవడం విఫలమైంది';

  @override
  String get summarizingMaterial => 'మీ మెటీరియల్‌ని సంక్షిప్తీకరిస్తోంది…';

  @override
  String get failedToSummarize => 'సంక్షిప్తీకరించడం విఫలమైంది';

  @override
  String summaryTitle(String filename) {
    return 'సారాంశం: $filename';
  }

  @override
  String get failedToSummarizeMaterial =>
      'మెటీరియల్‌ని సంక్షిప్తీకరించడం విఫలమైంది. దయచేసి మళ్ళీ ప్రయత్నించండి లేదా దాని గురించి నేరుగా ప్రశ్నలు అడగండి!';

  @override
  String get errorUploadingFile => 'ఫైల్ అప్‌లోడ్ చేయడంలో లోపం';

  @override
  String get thinking => 'ఆలోచిస్తోంది…';

  @override
  String get explainSimply => 'సులభంగా వివరించండి';

  @override
  String get quizMe => 'నన్ను పరీక్షించండి';

  @override
  String get summarize => 'సంక్షిప్తీకరించండి';

  @override
  String get typeOrVoice =>
      'టైప్ చేయండి లేదా వాయిస్ ఇన్‌పుట్ కోసం మైక్ ఉపయోగించండి…';

  @override
  String get tutorNotAvailable => 'ట్యూటర్ అందుబాటులో లేదు…';

  @override
  String get startVoiceInput =>
      'వాయిస్ ఇన్‌పుట్ ప్రారంభించండి (వికలాంగ విద్యార్థుల కోసం)';

  @override
  String get stopRecording => 'రికార్డింగ్ ఆపండి';

  @override
  String get ttsOn => 'TTS ఆన్ (సమాధానాలు బిగ్గరగా చదవబడతాయి)';

  @override
  String get ttsOff => 'TTS ఆఫ్';

  @override
  String get listeningSpeak => 'వింటోంది... ఇప్పుడు మాట్లాడండి';

  @override
  String get speechNotAvailable => 'వాక్ గుర్తింపు అందుబాటులో లేదు';

  @override
  String get checkingTutorConnection => 'ట్యూటర్ కనెక్షన్ తనిఖీ చేస్తోంది…';

  @override
  String get tutorConnected => 'ట్యూటర్ కనెక్ట్ అయింది';

  @override
  String get tutorOffline =>
      'ట్యూటర్ ఆఫ్‌లైన్ — స్వయంచాలకంగా మళ్ళీ ప్రయత్నిస్తోంది…';

  @override
  String get upload => 'అప్‌లోడ్';

  @override
  String get ttsEnabled => 'టెక్స్ట్-టు-స్పీచ్ ఎనేబుల్ చేయబడింది';

  @override
  String get signLanguageIot => 'సంకేత భాష IoT';

  @override
  String get pcHubConnected => 'PC Hub: కనెక్ట్ అయింది';

  @override
  String get receivingTransmissions =>
      'రియల్-టైమ్ గ్లోవ్ ట్రాన్స్‌మిషన్లు అందుతున్నాయి';

  @override
  String get smartGlove => 'స్మార్ట్ గ్లోవ్ — 5 వేలు ఫ్లెక్స్';

  @override
  String get thumb => 'బొటనవేలు';

  @override
  String get indexFinger => 'చూపుడు వేలు';

  @override
  String get middleFinger => 'మధ్య వేలు';

  @override
  String get ringFinger => 'ఉంగరపు వేలు';

  @override
  String get pinkyFinger => 'చిటికెన వేలు';

  @override
  String get aiTranslation => 'AI అనువాదం (Ollama)';

  @override
  String get detectedGesture => 'గుర్తించిన సంకేతం:';

  @override
  String get waiting => 'వేచి ఉంది...';

  @override
  String get llmFluentSpeech => 'LLM నిర్మల వాక్యం:';

  @override
  String get waitingForOllama => 'Ollama కోసం వేచి ఉంది...';

  @override
  String get liveModeConnected =>
      'లైవ్ మోడ్ — PC Hub కి కనెక్ట్ అయింది. స్మార్ట్ గ్లోవ్ నుండి రియల్-టైమ్ ఫ్లెక్స్ విలువలు.';

  @override
  String get remindersComingSoon =>
      'మందులు & అపాయింట్‌మెంట్ రిమైండర్లు\n(త్వరలో వస్తోంది)';

  @override
  String get explainSimplyPrompt => 'దయచేసి దీన్ని సరళమైన పదాలలో వివరించండి';

  @override
  String get quizMePrompt =>
      'మనం ఇప్పుడు చర్చించిన దాని గురించి నాకు 3 ప్రశ్నలు అడగండి';

  @override
  String get summarizePrompt =>
      'మనం ఇప్పటివరకు చర్చించిన దాన్ని సంక్షిప్తీకరించండి';
}
