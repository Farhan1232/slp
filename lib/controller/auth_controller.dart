import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:slp/Model/auth_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final RxBool isLoading = false.obs;
  // Rx variables for password visibility
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  // --- Visibility Toggle Methods (FIXED) ---
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  // --- END Visibility Toggle Methods ---


  // --- Core Navigation/State Setting ---
  _setInitialScreen(User? user) async {
    // Only proceed if Get is fully initialized
    if (!Get.isRegistered<AuthController>()) return;

    if (user == null) {
      // User is logged out. Send to Login Screen if not already there.
      currentUser.value = null;
      if (Get.currentRoute != '/login') {
         Get.offAllNamed('/login');
      }
    } else {
      // User is logged in. Fetch data and send to Main Screen.
      UserModel? firestoreUser = await _fetchUserFromFirestore(user.uid);
      
      if (firestoreUser != null) {
        currentUser.value = firestoreUser;
      } else {
        // Fallback
        currentUser.value = UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName,
          photoUrl: user.photoURL,
        );
      }
      
      // Navigate to /main if not already there.
      if (Get.currentRoute != '/main' && Get.currentRoute != '/home') {
          // Use '/home' or '/main' depending on your app's main route
          Get.offAllNamed('/main'); 
      }
    }
  }

  // --- Firebase Storage/Firestore Methods ---

  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error saving user to Firestore: $e');
      rethrow;
    }
  }

  Future<UserModel?> _fetchUserFromFirestore(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching user from Firestore: $e');
      return null;
    }
  }

  Future<String?> _uploadProfileImage(String uid, File imageFile) async {
    try {
      final storageRef = storage.ref().child('user_profiles').child('$uid.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // --- Authentication Methods ---

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        UserModel? firestoreUser = await _fetchUserFromFirestore(userCredential.user!.uid);

        if (firestoreUser != null) {
          currentUser.value = firestoreUser;
        } else {
          currentUser.value = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            name: userCredential.user!.displayName,
            photoUrl: userCredential.user!.photoURL,
          );
        }

        // FIX: Show dialog/snackbar only, then navigate.
        Get.snackbar(
          'تم بنجاح',
          'تم تسجيل الدخول بنجاح!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        
        // Navigation to /main will be handled by _setInitialScreen 
        // which listens to authStateChanges. 
        // We can add a slight delay to ensure the snackbar is shown 
        // before navigation is triggered by the auth change listener.
        // The listener is the most reliable way to handle navigation after login.
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ ما';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'لا يوجد مستخدم بهذا البريد الإلكتروني';
          break;
        case 'wrong-password':
          errorMessage = 'كلمة المرور غير صحيحة';
          break;
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صالح';
          break;
        case 'user-disabled':
          errorMessage = 'تم تعطيل هذا الحساب';
          break;
        case 'too-many-requests':
          errorMessage = 'عدد محاولات كثيرة، يرجى المحاولة لاحقًا';
          break;
        case 'invalid-credential':
          errorMessage = 'بيانات الدخول غير صحيحة';
          break;
        default:
          errorMessage = e.message ?? 'فشل تسجيل الدخول';
      }

      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String email, String password, String name, {File? profileImage}) async {
    try {
      isLoading.value = true;
      String? photoUrl;

      // 1. Create user in Firebase Auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? newUser = userCredential.user;

      if (newUser != null) {
        String uid = newUser.uid;
        
        // 2. Upload image to Firebase Storage if provided
        if (profileImage != null) {
          photoUrl = await _uploadProfileImage(uid, profileImage);
        }
        
        // 3. Update Firebase Auth profile
        await newUser.updateDisplayName(name);
        if (photoUrl != null) {
          await newUser.updatePhotoURL(photoUrl);
        }
        await newUser.reload();

        User? updatedUser = auth.currentUser;

        // 4. Create UserModel and save to Firestore
        UserModel newUserModel = UserModel(
          id: updatedUser!.uid,
          email: updatedUser.email ?? '',
          name: updatedUser.displayName,
          photoUrl: updatedUser.photoURL,
        );
        
        await _saveUserToFirestore(newUserModel);
        
        // FIX: Sign out the user immediately after account creation 
        // to force them to the login screen as requested.
        await auth.signOut();

        Get.snackbar(
          'تم بنجاح',
          'تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        // FIX: Explicitly navigate to Login screen after successful signup and sign out.
        Get.offAllNamed('/login');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ ما';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'كلمة المرور ضعيفة جدًا';
          break;
        case 'email-already-in-use':
          errorMessage = 'يوجد حساب مسجل بهذا البريد الإلكتروني';
          break;
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صالح';
          break;
        case 'operation-not-allowed':
          errorMessage = 'تم تعطيل تسجيل الدخول بالبريد الإلكتروني';
          break;
        default:
          errorMessage = e.message ?? 'فشل إنشاء الحساب';
      }

      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;

      await auth.sendPasswordResetEmail(email: email);

      Get.snackbar(
        'تم بنجاح',
        'تم إرسال رابط استعادة كلمة المرور إلى $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      Get.back();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ ما';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'لا يوجد مستخدم بهذا البريد الإلكتروني';
          break;
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صالح';
          break;
        default:
          errorMessage = e.message ?? 'فشل في إرسال الرابط';
      }

      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      currentUser.value = null;
      Get.offAllNamed('/login');

      Get.snackbar(
        'تم بنجاح',
        'تم تسجيل الخروج بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل تسجيل الخروج',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }
}













class LanguageController extends GetxController {
  // Separate observable for each screen
  final RxString loginScreenLanguage = 'en'.obs;
  final RxString signupScreenLanguage = 'en'.obs;
  final RxString forgotPasswordScreenLanguage = 'en'.obs;
  final RxString mainAppLanguage = 'en'.obs; // For Home, Profile, Bottom Nav

  // Change language for Login screen only
  void changeLoginLanguage(String languageCode) {
    loginScreenLanguage.value = languageCode;
    update(['login_screen']); // Update only login screen
  }

  // Change language for Signup screen only
  void changeSignupLanguage(String languageCode) {
    signupScreenLanguage.value = languageCode;
    update(['signup_screen']); // Update only signup screen
  }

  // Change language for Forgot Password screen only
  void changeForgotPasswordLanguage(String languageCode) {
    forgotPasswordScreenLanguage.value = languageCode;
    update(['forgot_password_screen']); // Update only forgot password screen
  }

  // Change language for main app (Home, Profile, Bottom Nav)
  void changeMainAppLanguage(String languageCode) {
    mainAppLanguage.value = languageCode;
    update(['main_app']); // Update main app screens
  }

  // Get translated text for specific screen
  String getTranslation(String key, String screenLanguage) {
    final translations = _getTranslations();
    return translations[screenLanguage]?[key] ?? key;
  }

  // Get translation for main app (Home, Profile, Bottom Nav)
  String getMainAppTranslation(String key) {
    return getTranslation(key, mainAppLanguage.value);
  }

  // All translations in one place
  Map<String, Map<String, String>> _getTranslations() {
    return {
      'en': {
        'hello_exclamation': 'Hello!',
        'welcome_back': 'Welcome Back',
        'login_to_continue': 'Login to continue your journey',
        'enter_your_email': 'Enter your email',
        'email': 'Email',
        'email_required': 'Email is required',
        'valid_email_required': 'Please enter a valid email',
        'enter_password': 'Enter your password',
        'password': 'Password',
        'password_required': 'Password is required',
        'password_min_length': 'Password must be at least 6 characters',
        'forgot_password': 'Forgot Password?',
        'login': 'Login',
        'no_account': 'Don\'t have an account? ',
        'create_account': 'Create Account',
        
        // Signup
        'join_us': 'Join Us!',
        'create_account_header': 'Create Account',
        'register_to_start': 'Register to start learning',
        'enter_your_name': 'Enter your name',
        'full_name': 'Full Name',
        'name_required': 'Name is required',
        'confirm_password_hint': 'Re-enter your password',
        'confirm_password': 'Confirm Password',
        'confirm_password_required': 'Please confirm your password',
        'passwords_do_not_match': 'Passwords do not match',
        'register': 'Register',
        'have_account': 'Already have an account? ',
        
        // Forgot Password
        'need_help': 'Need Help?',
        'forgot_password_header': 'Forgot Password?',
        'reset_password_instruction': 'Enter your email and we\'ll send you a reset link',
        'send_reset_link': 'Send Reset Link',
        'back_to_login': 'Back to Login',
        
        // Home Screen
        'welcome': 'Welcome',
        'language': 'Language',
        'home_exercises': 'Home Exercises',
        'definitions': 'Definitions',
        'parent_tips': 'Parent Tips',
        'questions_answers': 'Questions & Answers',
        'free_pdf_materials': 'Free PDF Materials',
        'quiz': 'Quiz',
        'app_questions': 'App Questions',
        
        // Bottom Navigation
        'home_tab': 'Home',
        'result_tab': 'Results',
        'profile_tab': 'Profile',
        
        // Profile Screen
        'profile_title': 'Profile',
        'default_user': 'User',
        'terms_and_conditions': 'Terms and Conditions',
        'privacy_policy': 'Privacy Policy',
        'share_app': 'Share App',
        'lang': 'Language',
        'rating_and_feedback': 'Rating & Feedback',
        'about_app': 'About App',
        'version': 'Version',
        'language_switch': 'Language Switch',
        'logout': 'Logout',
        'confirm_logout': 'Are you sure you want to logout?',
        'cancel': 'Cancel',
        'delete_account': 'Delete Account',
        'confirm_delete': 'This action cannot be undone. All your data will be permanently deleted.',
        'delete_success_title': 'Success',
        'delete_success_message': 'Account deleted successfully',
        'delete_failure_title': 'Error',
        'delete_failure_message': 'Failed to delete account. Please try again.',
      },
      'ar': {
        'hello_exclamation': 'مرحبا!',
        'welcome_back': 'مرحبا بعودتك',
        'login_to_continue': 'سجل الدخول لمتابعة رحلتك',
        'enter_your_email': 'أدخل بريدك الإلكتروني',
        'email': 'البريد الإلكتروني',
        'email_required': 'البريد الإلكتروني مطلوب',
        'valid_email_required': 'يرجى إدخال بريد إلكتروني صالح',
        'enter_password': 'أدخل كلمة المرور',
        'password': 'كلمة المرور',
        'password_required': 'كلمة المرور مطلوبة',
        'password_min_length': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
        'forgot_password': 'هل نسيت كلمة المرور؟',
        'login': 'تسجيل الدخول',
        'no_account': 'ليس لديك حساب؟ ',
        'create_account': 'إنشاء حساب',
        
        // Signup
        'join_us': 'انضم إلينا!',
        'create_account_header': 'إنشاء حساب',
        'register_to_start': 'سجل لبدء التعلم',
        'enter_your_name': 'أدخل اسمك',
        'full_name': 'الاسم الكامل',
        'name_required': 'الاسم مطلوب',
        'confirm_password_hint': 'أعد إدخال كلمة المرور',
        'confirm_password': 'تأكيد كلمة المرور',
        'confirm_password_required': 'يرجى تأكيد كلمة المرور',
        'passwords_do_not_match': 'كلمات المرور غير متطابقة',
        'register': 'تسجيل',
        'have_account': 'هل لديك حساب بالفعل؟ ',
        
        // Forgot Password
        'need_help': 'تحتاج مساعدة؟',
        'forgot_password_header': 'هل نسيت كلمة المرور؟',
        'reset_password_instruction': 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين',
        'send_reset_link': 'إرسال رابط إعادة التعيين',
        'back_to_login': 'العودة لتسجيل الدخول',
        
        // Home Screen
        'welcome': 'مرحبا',
        'language': 'اللغة',
        'home_exercises': 'تمارين منزلية',
        'definitions': 'التعريفات',
        'parent_tips': 'نصائح للآباء',
        'questions_answers': 'أسئلة وأجوبة',
        'free_pdf_materials': 'مواد PDF مجانية',
        'quiz': 'اختبار',
        'app_questions': 'أسئلة التطبيق',
        
        // Bottom Navigation
        'home_tab': 'الرئيسية',
        'result_tab': 'النتائج',
        'profile_tab': 'الملف الشخصي',
        
        // Profile Screen
        'profile_title': 'الملف الشخصي',
        'default_user': 'مستخدم',
        'terms_and_conditions': 'الشروط والأحكام',
        'privacy_policy': 'سياسة الخصوصية',
        'share_app': 'مشاركة التطبيق',
        'lang': 'اللغة',
        'rating_and_feedback': 'التقييم والملاحظات',
        'about_app': 'عن التطبيق',
        'version': 'الإصدار',
        'language_switch': 'تبديل اللغة',
        'logout': 'تسجيل الخروج',
        'confirm_logout': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
        'cancel': 'إلغاء',
        'delete_account': 'حذف الحساب',
        'confirm_delete': 'لا يمكن التراجع عن هذا الإجراء. سيتم حذف جميع بياناتك نهائيًا.',
        'delete_success_title': 'نجح',
        'delete_success_message': 'تم حذف الحساب بنجاح',
        'delete_failure_title': 'خطأ',
        'delete_failure_message': 'فشل حذف الحساب. يرجى المحاولة مرة أخرى.',
      },
    };
  }
}