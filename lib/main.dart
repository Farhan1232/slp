
// ============================================
// MAIN.DART SETUP (PORTRAIT MODE + SPLASH SCREEN + RESPONSIVENESS)
// ============================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ For orientation control
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ For responsiveness
import 'package:slp/Screens/splash_screen.dart';
import 'package:slp/Screens/Arabic_screens/%D8%A7%D9%84%D9%84%D8%BA%D8%A9%20%D8%A7%D9%84%D8%A7%D8%B3%D8%AA%D9%82%D8%A8%D8%A7%D9%84%D9%8A%D8%A9%20_receptive_language_screen.dart';
import 'package:slp/Screens/Arabic_screens/%D8%A7%D9%84%D9%84%D8%BA%D8%A9%20%D8%A7%D9%84%D8%AA%D8%B9%D8%A8%D9%8A%D8%B1%D9%8A_expressive_language_screen.dart';
import 'package:slp/Screens/Arabic_screens/%D8%AA%D9%85%D8%A7%D8%B1%D9%8A%D9%86_exercises.dart';
import 'package:slp/Screens/Arabic_screens/%D8%B3%D8%A6%D9%84%D8%A9%20%D9%88%D8%A3%D8%AC%D9%88%D8%A8%D8%A9_questions.dart';
import 'package:slp/Screens/Arabic_screens/%D8%B5%D8%A7%D8%A6%D8%AD%20%D9%84%D9%84%D8%A3%D9%87%D9%84_tips_for_parents_screen.dart';
import 'package:slp/Screens/Arabic_screens/%D8%B9%D8%B1%D9%8A%D9%81%D8%A7%D8%AA_defination_screen.dart';
import 'package:slp/Screens/Arabic_screens/%D9%84%D9%88%D8%AC%D9%87%20%D9%88%D8%A7%D9%84%D9%81%D9%83%D9%8A%D9%86_Face%20and%20Jaw%20Exercises.dart';
import 'package:slp/Screens/Arabic_screens/%D9%85%D9%88%D8%A7%D8%AF%20%D9%85%D8%AC%D8%A7%D9%86%D9%8A_free_material_screen.dart';
import 'package:slp/Screens/FAQs.dart';
import 'package:slp/Screens/about.dart';
import 'package:slp/Screens/forgetpassword.dart';
import 'package:slp/Screens/home.dart';
import 'package:slp/Screens/login.dart';
import 'package:slp/Screens/main_nav.dart';
import 'package:slp/Screens/privacy.dart';
import 'package:slp/Screens/quiz/quiz_result_screen.dart';
import 'package:slp/Screens/quiz/quiz_screen.dart';
import 'package:slp/Screens/signup.dart';
import 'package:slp/Screens/term.dart';
import 'package:slp/controller/auth_controller.dart';
import 'package:slp/controller/quiz_controller.dart';
import 'package:slp/firebase_options.dart';

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
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          initialRoute: '/splash',
          getPages: [
            GetPage(name: '/splash', page: () => const SplashScreen()),
            GetPage(name: '/login', page: () => LoginScreen()),
            GetPage(name: '/signup', page: () => SignupScreen()),
            GetPage(name: '/forgot-password', page: () => ForgetPasswordScreen()),
            GetPage(name: '/home', page: () => HomeScreen()),
            GetPage(name: '/main', page: () => MainScreen()),
            GetPage(name: '/terms', page: () => TermsScreen()),
            GetPage(name: '/privacy', page: () => PrivacyScreen()),
            GetPage(name: '/about', page: () => AboutAppScreen()),
            GetPage(name: '/exercises', page: () => HomeExercisesScreen()),
            GetPage(name: '/tips', page: () => TipsForParentsScreen()),
            GetPage(name: '/receptive-language', page: () => ReceptiveLanguageScreen()),
            GetPage(name: '/expressive-language', page: () => ExpressiveLanguageScreen()),
            GetPage(name: '/face-and-jaw', page: () => FaceAndJawScreen()),
            GetPage(name: '/definitions', page: () => DefinitionsScreen()),
            GetPage(name: '/questions', page: () => questionscreen()),
            GetPage(name: '/quiz', page: () => QuizScreen()),
            GetPage(name: '/quiz-result', page: () => ResultScreen()),
            GetPage(name: '/free_materials', page: () => FreeMaterialsScreen()),
            GetPage(name: '/faq', page: () => FaqScreen()),
          ],
        );
      },
    );
  }
}
