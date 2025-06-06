import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jop_project/Controller/Firebase_Services/fcm_service.dart';
import 'package:jop_project/Controller/Firebase_Services/notifications_service.dart';
import 'package:jop_project/Providers/Caht-firebase_database/chat_provider_firebase_database.dart';
import 'package:jop_project/Providers/interest/interest_provider.dart';
import 'package:jop_project/Providers/Experience/experience_provider.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Providers/locale_provider.dart';
import 'package:jop_project/Providers/settings_provider.dart';
import 'package:jop_project/Providers/skills/skills_provider.dart';
import 'package:jop_project/Screens/CompanyScreen/company_dashboard_screen.dart';
import 'package:jop_project/Screens/JopScreen/Home/home_screen.dart';
import 'package:jop_project/Screens/Onboarding/onboarding_screen.dart';
import 'package:jop_project/Screens/Welcome/welcome_screen.dart';
import 'package:jop_project/components/statistics/presentation/provider/statistics_provider.dart';
import 'package:jop_project/l10n/l10n.dart';
import 'package:jop_project/size_config.dart';
import 'package:jop_project/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:jop_project/Providers/Countries/country_provider.dart';
import 'package:jop_project/Providers/Companies/companies_provider.dart';
import 'package:jop_project/Providers/Searchers/searchers_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'components/custom_animated_indicator.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(remoteMessagemessage) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    // Admob.initialize();
    await MobileAds.instance.initialize();
    // إضافة هذا الكود لتحديد جهازك كجهاز اختبار
    // final RequestConfiguration requestConfiguration = RequestConfiguration(
    //   testDeviceIds: [
    //     '5DB2700EFF0E9D0075D52AB42D2B54ED'
    //   ], // استخدم الجهاز ID الموجود في اللوغ
    // );
    // MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    // طلب الأذونات للأندرويد
    var status3 = await Permission.notification.status;
    if (!status3.isGranted) {
      status3 = await Permission.notification.request();
    } else {
      status3 = await Permission.notification.request();
    }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        log('تم رفض إذن الوصول إلى التخزين storage');
        var status2 = await Permission.manageExternalStorage.status;
        if (!status2.isGranted) {
          status2 = await Permission.manageExternalStorage.request();
          if (!status2.isGranted) {
            log('تم رفض إذن الوصول إلى التخزين manageExternalStorage');
          }
        }
      }
    }
  }

  // runApp(AnchoredAdaptiveExample());
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)..init()),
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CompanySigninLoginProvider()),
        ChangeNotifierProvider(create: (_) => SearcherSigninLoginProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => JobsProvider() /*..getJobs()*/),
        ChangeNotifierProvider(
            create: (_) => CompaniesProvider()..getAllCompanies()),
        ChangeNotifierProvider(create: (_) => SkillsProvider()..getSkills()),
        ChangeNotifierProvider(create: (_) => InterestProvider()..getDesires()),
        ChangeNotifierProvider(
            create: (_) => ExperienceProvider()..getExperiences()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(
            create: (_) => SearchersProvider()..getAllSearchers()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: Consumer2<LocaleProvider, SettingsProvider>(
          builder: (context, localeProvider, settingsProvider, child) {
        return GetMaterialApp(
          title: 'Jops',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsProvider.themeMode,
          locale: localeProvider.locale,
          textDirection: localeProvider.locale?.languageCode == 'ar'
              ? TextDirection.ltr
              : TextDirection.rtl,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (localeProvider.locale != null) return localeProvider.locale;

            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return const Locale('en');
          },
          // home: AnchoredAdaptiveExample()
          home: localeProvider.seenOnboarding == true
              ? const InitialScreen()
              : const OnboardingScreen(),
        );
      }),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  NotificationsService notificationsService = NotificationsService();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationsService.requestNotificationPermission();
      notificationsService.getDeviceToken();
      notificationsService.firebaseInit(context);
      notificationsService.setupInteractMessage(context);
      FcmService.firebaseInit();
      _initializeApp();
    });

    super.initState();
  }

  Future<void> _initializeApp() async {
    final companyProvider =
        Provider.of<CompanySigninLoginProvider>(context, listen: false);
    final searcherProvider =
        Provider.of<SearcherSigninLoginProvider>(context, listen: false);
    await companyProvider.initializeApp();
    await searcherProvider.initializeApp();
    if (!mounted) return;

    // التحقق من وجود شركة مسجلة الدخول
    if (companyProvider.currentCompany != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyDashboardScreen(
            company: companyProvider.currentCompany!,
          ),
        ),
      );
      // التحقق من وجود موظف مسجل الدخول
    } else if (searcherProvider.currentSearcher != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: const AnimatedProgressBar());
  }
}
