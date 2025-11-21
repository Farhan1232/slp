import 'dart:ui';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class LocalizationService extends Translations {
  // Define supported locales
  static const Locale arabicLocale = Locale('ar', 'AR');
  static const Locale englishLocale = Locale('en', 'US');

  // Fallback locale is what is used when a translation is not found in the current locale
  static const Locale fallbackLocale = englishLocale;

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // --- General App Keys (Navigation, Static Content) ---
          'home': 'Home',
          'definitions': 'Definitions',
          'about': 'About',
          'questions_answers': 'Questions & Answers',
          'tips_for_parents': 'Tips for Parents',
          'free_materials': 'Free Materials',
          'App_questions': 'Frequently Asked Questions', 
          // Note: 'terms_and_conditions' and 'privacy_policy' are repeated below, 
          // keeping the version under Profile Screen for consistency.

          // --- Buttons/Actions ---
          'cancel': 'Cancel',
          'delete_account': 'Delete Account',
          'logout': 'Logout',

          // --- General/Common Auth Keys ---
          'hello_exclamation': 'Hello!',
          'enter_your_email': 'Enter your email',
          'email': 'Email',
          'enter_password': 'Enter password',
          'password': 'Password',
          'login': 'Log In',
          'register': 'Register',
          'back_to_login': 'Back to Log In',

          // --- Login Screen Keys ---
          'welcome_back': 'Welcome Back',
          'login_to_continue': 'Log in to continue',
          'forgot_password': 'Forgot Password?',
          'no_account': 'Don\'t have an account? ',
          'create_account': 'Create Account',

          // --- Signup Screen Keys ---
          'join_us': 'Join Us!',
          'create_account_header': 'Create Account',
          'register_to_start': 'Register to get started',
          'enter_your_name': 'Enter your name',
          'full_name': 'Full Name',
          'confirm_password_hint': 'Confirm password',
          'confirm_password': 'Confirm Password',
          'have_account': 'Already have an account? ',

          // --- Forget Password Screen Keys ---
          'need_help': 'Need Help?',
          'forgot_password_header': 'Forgot Password?',
          'reset_password_instruction':
              'Enter your email and we will send you a link to reset your password',
          'send_reset_link': 'Send Reset Link',

          // --- Validation Messages ---
          'email_required': 'Please enter email',
          'valid_email_required': 'Please enter a valid email',
          'password_required': 'Please enter password',
          'password_min_length': 'Password must be at least 6 characters',
          'name_required': 'Please enter your name',
          'confirm_password_required': 'Please confirm password',
          'passwords_do_not_match': 'Passwords do not match',

          // --- Profile Screen Keys ---
          'profile_title': 'Profile',
          'default_user': 'User',
          'terms_and_conditions': 'Terms and Conditions',
          'privacy_policy': 'Privacy Policy',
          'share_app': 'Share App',
          'rating_and_feedback': 'Rating and Feedback',
          'about_app': 'About App',
          'version': 'Version',
          'language_switch': 'Switch Language',
          'confirm_logout': 'Are you sure you want to log out?',
          'confirm_delete':
              'Are you sure you want to permanently delete the account? This action cannot be undone.',
          'delete_success_title': 'Successfully Deleted',
          'delete_success_message': 'The account has been deleted successfully.',
          'delete_failure_title': 'Account Deletion Failed',
          'delete_failure_message':
              'Please log in again and try again.',

          // --- Main Screen Tabs Keys ---
          'home_tab': 'Home',
          'result_tab': 'Result',
          'profile_tab': 'Profile',

          // --- Home Screen Specific Keys ---
          'welcome': 'Welcome',
          'home_exercises': 'Home Exercises',
          'parent_tips': 'Tips for Parents',
          'free_pdf_materials': 'Free PDF Materials',
          'quiz': 'Quiz',
          'app_questions': 'App Questions',
          'language': 'Language',
          'switch_to_arabic': 'العربية',
          'switch_to_english': 'English',
        },
        'ar_AR': {
          // --- General App Keys (Navigation, Static Content) ---
          'home': 'الرئيسية',
          'definitions': 'تعريفات',
          'about': 'عن التطبيق',
          'questions_answers': 'الأسئلة والأجوبة',
          'tips_for_parents': 'نصائح للآهل',
          'free_materials': 'مواد مجانية',
          'App_questions': 'الأسئلة الشائعة',
          // Note: 'terms_and_conditions' and 'privacy_policy' are repeated below, 
          // keeping the version under Profile Screen for consistency.

          // --- Buttons/Actions ---
          'cancel': 'إلغاء',
          'delete_account': 'حذف الحساب',
          'logout': 'تسجيل الخروج',

          // --- General/Common Auth Keys ---
          'hello_exclamation': 'مرحباً!',
          'enter_your_email': 'أدخل بريدك الإلكتروني',
          'email': 'البريد الإلكتروني',
          'enter_password': 'أدخل كلمة المرور',
          'password': 'كلمة المرور',
          'login': 'تسجيل الدخول',
          'register': 'تسجيل',
          'back_to_login': 'العودة لتسجيل الدخول',

          // --- Login Screen Keys ---
          'welcome_back': 'مرحباً بعودتك',
          'login_to_continue': 'سجّل الدخول للمتابعة',
          'forgot_password': 'نسيت كلمة المرور؟',
          'no_account': 'ليس لديك حساب؟ ',
          'create_account': 'إنشاء حساب',

          // --- Signup Screen Keys ---
          'join_us': 'انضم إلينا!',
          'create_account_header': 'إنشاء حساب',
          'register_to_start': 'سجل للبدء',
          'enter_your_name': 'أدخل اسمك',
          'full_name': 'الاسم الكامل',
          'confirm_password_hint': 'أكد كلمة المرور',
          'confirm_password': 'تأكيد كلمة المرور',
          'have_account': 'هل لديك حساب بالفعل؟ ',

          // --- Forget Password Screen Keys ---
          'need_help': 'تحتاج مساعدة؟',
          'forgot_password_header': 'نسيت كلمة المرور؟',
          'reset_password_instruction':
              'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور',
          'send_reset_link': 'إرسال رابط إعادة التعيين',

          // --- Validation Messages ---
          'email_required': 'الرجاء إدخال البريد الإلكتروني',
          'valid_email_required': 'الرجاء إدخال بريد إلكتروني صحيح',
          'password_required': 'الرجاء إدخال كلمة المرور',
          'password_min_length': 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل',
          'name_required': 'الرجاء إدخال الاسم',
          'confirm_password_required': 'الرجاء تأكيد كلمة المرور',
          'passwords_do_not_match': 'كلمات المرور غير متطابقة',

          // --- Profile Screen Keys ---
          'profile_title': 'الملف الشخصي',
          'default_user': 'مستخدم',
          'terms_and_conditions': 'الشروط والأحكام',
          'privacy_policy': 'سياسة الخصوصية',
          'share_app': 'مشاركة التطبيق',
          'rating_and_feedback': 'التقييم والملاحظات',
          'about_app': 'حول التطبيق',
          'version': 'الإصدار',
          'language_switch': 'تبديل اللغة',
          'confirm_logout': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          'confirm_delete':
              'هل أنت متأكد أنك تريد حذف الحساب نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.',
          'delete_success_title': 'تم الحذف بنجاح',
          'delete_success_message': 'تم حذف الحساب بنجاح.',
          'delete_failure_title': 'فشل حذف الحساب',
          'delete_failure_message':
              'يرجى تسجيل الدخول مرة أخرى ثم المحاولة مجددًا.',

          // --- Main Screen Tabs Keys ---
          'home_tab': 'الرئيسية',
          'result_tab': 'النتيجة',
          'profile_tab': 'الملف الشخصي',

          // --- Home Screen Specific Keys ---
          'welcome': 'مرحباً بك',
          'home_exercises': 'تمارين منزلية',
          'parent_tips': 'نصائح للأهل',
          'free_pdf_materials': 'مواد مجانية PDF',
          'quiz': 'اختبار',
          'app_questions': 'أسئلة عن التطبيق',
          'language': 'اللغة',
          'switch_to_arabic': 'العربية',
          'switch_to_english': 'English',
        }
      };

  // Utility method to change locale
  void changeLocale(String languageCode) {
    final newLocale = languageCode == 'ar'
        ? LocalizationService.arabicLocale
        : LocalizationService.englishLocale;
    Get.updateLocale(newLocale);
  }
}