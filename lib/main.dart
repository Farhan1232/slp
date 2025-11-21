
// ============================================
// MAIN.DART SETUP (PORTRAIT MODE + SPLASH SCREEN + RESPONSIVENESS)
// ============================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ For orientation control
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ For responsiveness
import 'package:slp/App_route.dart';
import 'package:slp/controller/auth_controller.dart';
import 'package:slp/controller/quiz_controller.dart';
import 'package:slp/firebase_options.dart';
import 'package:slp/langs/app_translations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Force portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(FirebaseAuth.instance, permanent: true);
  Get.put(AuthController());
  Get.put(QuizController(), permanent: true);
  
  Get.put(LanguageController(), permanent: true);
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // ✅ Base screen size (from design)
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'عالم النطق واللغة',
          debugShowCheckedModeBanner: false,
              translations: LocalizationService(),
    locale: const Locale('en', 'US'),
    fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.splash_screen,
          getPages: AppRoutes.routes,
          // getPages: [
          //   // GetPage(name: '/splash', page: () => const SplashScreen()),
          //   // GetPage(name: '/login', page: () => LoginScreen()),
          //   // GetPage(name: '/signup', page: () => SignupScreen()),
          //   // GetPage(name: '/forgot-password', page: () => ForgetPasswordScreen()),
          //   // GetPage(name: '/home', page: () => HomeScreen()),
          //   // GetPage(name: '/main', page: () => MainScreen()),
          //   // GetPage(name: '/terms', page: () => TermsScreen()),
          //   // GetPage(name: '/privacy', page: () => PrivacyScreen()),
          //   // GetPage(name: '/about', page: () => AboutAppScreen()),
          //   // GetPage(name: '/exercises', page: () => HomeExercisesScreen()),
          //   // GetPage(name: '/tips', page: () => TipsForParentsScreen()),
          //   // GetPage(name: '/receptive-language', page: () => ReceptiveLanguageScreen()),
          //   // GetPage(name: '/expressive-language', page: () => ExpressiveLanguageScreen()),
          //   // GetPage(name: '/face-and-jaw', page: () => FaceAndJawScreen()),
          //   // GetPage(name: '/definitions', page: () => DefinitionsScreen()),
          //   // GetPage(name: '/questions', page: () => questionscreen()),
          //   // GetPage(name: '/quiz', page: () => QuizScreen()),
          //   // GetPage(name: '/quiz-result', page: () => ResultScreen()),
          //   // GetPage(name: '/free_materials', page: () => FreeMaterialsScreen()),
          //   // GetPage(name: '/faq', page: () => FaqScreen()),
          // ],
        );
      },
    );
  }
}
