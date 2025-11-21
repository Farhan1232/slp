import 'package:get/get.dart';
import 'package:slp/Screens/Arabic_screens/%D8%A7%D9%84%D9%84%D8%BA%D8%A9%20%D8%A7%D9%84%D8%A7%D8%B3%D8%AA%D9%82%D8%A8%D8%A7%D9%84%D9%8A%D8%A9%20_receptive_language_screen.dart';
import 'package:slp/Screens/Arabic_screens/%D8%A7%D9%84%D9%84%D8%BA%D8%A9%20%D8%A7%D9%84%D8%AA%D8%B9%D8%A8%D9%8A%D8%B1%D9%8A_expressive_language_screen.dart';
import 'package:slp/Screens/Arabic_screens/%D8%AA%D9%85%D8%A7%D8%B1%D9%8A%D9%86_exercises.dart';
import 'package:slp/Screens/Arabic_screens/video_play_screen.dart';



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



class AppRoutes {
  static const String splash_screen = '/splash';
  static const String homeExercises = '/home-exercises';
  static const String receptiveLanguage = '/receptive-language';
  static const String expressiveLanguage = '/expressive-language';
  static const String faceAndJaw = '/face-and-jaw';
  static const String videoPlayer = '/video-player';
  static const String switchLanguage = '/switch-language';
  static const String Language_selection = '/language_selection';

  static List<GetPage> routes = [
    GetPage(
      name: homeExercises,
      page: () => const HomeExercisesScreen(),
    ),
    GetPage(
      name: receptiveLanguage,
      page: () => const ReceptiveLanguageScreen(),
    ),
    GetPage(
      name: expressiveLanguage,
      page: () => const ExpressiveLanguageScreen(),
    ),
    GetPage(
      name: videoPlayer,
      page: () => const VideoPlayerScreen(),
    ),
    // GetPage(
    //   name: switchLanguage,
    //   page: () => const LanguageSwitcher(),
    // ),
    // Add face-and-jaw route when you create that screen

 

//GetPage(name: '/lang_combine', page: () => CombinedLanguageSettingsScreen()),


   // GetPage(name: '/lang', page: () => LanguageSettingsScreen()),
            GetPage(name: splash_screen, page: () => const SplashScreen()),
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
  ];
}