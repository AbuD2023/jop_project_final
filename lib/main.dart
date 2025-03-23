import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Controller/Firebase_Services/fcm_service.dart';
import 'package:jop_project/Controller/Firebase_Services/notifications_service.dart';
import 'package:jop_project/Providers/Caht-firebase_database/chat_provider_firebase_database.dart';
import 'package:jop_project/Providers/Desires/desires_provider.dart';
import 'package:jop_project/Providers/Experience/experience_provider.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Providers/locale_provider.dart';
import 'package:jop_project/Providers/skills/skills_provider.dart';
import 'package:jop_project/Screens/CompanyScreen/company_dashboard_screen.dart';
import 'package:jop_project/Screens/JopScreen/Home/home_screen.dart';
import 'package:jop_project/Screens/Welcome/welcome_screen.dart';
import 'package:jop_project/components/statistics/presentation/provider/statistics_provider.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/l10n/l10n.dart';
import 'package:jop_project/size_config.dart';
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
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CompanySigninLoginProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => JobsProvider()..getJobs()),
        ChangeNotifierProvider(create: (_) => SearcherSigninLoginProvider()),
        ChangeNotifierProvider(
            create: (_) => CompaniesProvider()..getAllCompanies()),
        ChangeNotifierProvider(create: (_) => SkillsProvider()..getSkills()),
        ChangeNotifierProvider(create: (_) => DesiresProvider()..getDesires()),
        ChangeNotifierProvider(
            create: (_) => ExperienceProvider()..getExperiences()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..getOrders()),
        // ChangeNotifierProvider(
        //     create: (_) => OrderProvider()
        //       ..getOrdersByCompanyId(
        //           companyId: _
        //               .read<CompanySigninLoginProvider>()
        //               .currentCompany!
        //               .id!)),
        ChangeNotifierProvider(
            create: (_) => SearchersProvider()..getAllSearchers()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        // ChangeNotifierProvider(
        //     create: (_) => ChatProvider()
        //       ..getChatsByCompanyIdLignth(_
        //           .read<CompanySigninLoginProvider>()
        //           .currentCompany!
        //           .id!
        //           .toString())),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
        // ChangeNotifierProvider(create: (_) => SearcherSigninLoginProvider()..getSearcherById()),
      ],
      child:
          Consumer<LocaleProvider>(builder: (context, localeProvider, child) {
        return GetMaterialApp(
          title: 'Jops',
          locale: localeProvider.locale,
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
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              labelLarge: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Mulish",
              ),
              labelMedium: TextStyle(
                  color: Colors.white,
                  fontFamily: "Mulish",
                  fontSize: (SizeConfig.screenW! <= 750) ? 18 : 22),
              labelSmall: const TextStyle(color: Colors.black54, fontSize: 14),
              titleMedium: const TextStyle(color: Colors.black, fontSize: 16),
              // bodySmall: const TextStyle(color: Colors.white, fontSize: 20),
              // headlineMedium: TextStyle(
              //     color: Colors.white,
              //     fontFamily: "Mulish",
              //     fontSize: (SizeConfig.screenW! <= 750) ? 14 : 20),
              // bodyLarge: const TextStyle(
              //     color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              // displaySmall: const TextStyle(
              //     color: Color.fromARGB(255, 118, 118, 118), fontSize: 16),
              // bodyMedium: const TextStyle(
              //     color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              // displayLarge: const TextStyle(
              //     color: kPrimaryColor,
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(
              color: kBorderColor,
              applyTextScaling: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                foregroundColor: Colors.white,
                backgroundColor: kPrimaryColor,
                shape: const StadiumBorder(),
                // maximumSize: Size(SizeConfig.screenW!, 56),
                // minimumSize: Size(SizeConfig.screenW!, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              fillColor: Colors.white,
              // focusColor: kBorderColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              hintStyle: TextStyle(
                color: kBorderColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          // home: const CustomAnimatedIndicator(),
          home: const InitialScreen(),
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
    notificationsService.requestNotificationPermission();
    notificationsService.getDeviceToken();
    notificationsService.firebaseInit(context);
    notificationsService.setupInteractMessage(context);
    FcmService.firebaseInit();
    super.initState();
    _initializeApp();
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
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
  }

  // Future<void> _initializeApp() async {
  //   final companyProvider =
  //       Provider.of<CompanySigninLoginProvider>(context, listen: false);
  //   final searcherProvider =
  //       Provider.of<SearcherSigninLoginProvider>(context, listen: false);
  //   await companyProvider.initializeApp();
  //   await searcherProvider.initializeApp();
  //   if (!mounted) return;
  //   // التحقق من وجود شركة مسجلة الدخول
  //   if (companyProvider.currentCompany != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CompanyDashboardScreen(
  //           company: companyProvider.currentCompany!,
  //         ),
  //       ),
  //     );
  //     // التحقق من وجود موظف مسجل الدخول
  //   } else if (searcherProvider.currentSearcher != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const HomeScreen(),
  //       ),
  //     );
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const OnboardingScreen(),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return const AnimatedProgressBar();
    // Scaffold(
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       CircularProgressIndicator(),
    //       AnimatedProgressBar(),
    //       // CustomAnimatedIndicator(),
    //     ],
    //   ),
    // );
  }
}
