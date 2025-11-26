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
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Dialog translations
  Map<String, Map<String, String>> get _dialogTranslations => {
    'en': {
      // Success messages
      'success': 'Success',
      'login_success': 'Login successful!',
      'signup_success': 'Account created successfully! Please login.',
      'reset_link_sent': 'Password reset link sent to',
      'logout_success': 'Logged out successfully',
      
      // Error messages
      'error': 'Error',
      'unexpected_error': 'An unexpected error occurred',
      'login_failed': 'Login failed',
      'signup_failed': 'Account creation failed',
      'reset_failed': 'Failed to send reset link',
      'logout_failed': 'Logout failed',
      
      // Firebase Auth errors
      'user_not_found': 'No user found with this email',
      'wrong_password': 'Incorrect password',
      'invalid_email': 'Invalid email address',
      'user_disabled': 'This account has been disabled',
      'too_many_requests': 'Too many attempts, please try again later',
      'invalid_credential': 'Invalid login credentials',
      'weak_password': 'Password is too weak',
      'email_already_in_use': 'An account already exists with this email',
      'operation_not_allowed': 'Email/password sign-in is disabled',
    },
    'ar': {
      // Success messages
      'success': 'تم بنجاح',
      'login_success': 'تم تسجيل الدخول بنجاح!',
      'signup_success': 'تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول.',
      'reset_link_sent': 'تم إرسال رابط استعادة كلمة المرور إلى',
      'logout_success': 'تم تسجيل الخروج بنجاح',
      
      // Error messages
      'error': 'خطأ',
      'unexpected_error': 'حدث خطأ غير متوقع',
      'login_failed': 'فشل تسجيل الدخول',
      'signup_failed': 'فشل إنشاء الحساب',
      'reset_failed': 'فشل في إرسال الرابط',
      'logout_failed': 'فشل تسجيل الخروج',
      
      // Firebase Auth errors
      'user_not_found': 'لا يوجد مستخدم بهذا البريد الإلكتروني',
      'wrong_password': 'كلمة المرور غير صحيحة',
      'invalid_email': 'البريد الإلكتروني غير صالح',
      'user_disabled': 'تم تعطيل هذا الحساب',
      'too_many_requests': 'عدد محاولات كثيرة، يرجى المحاولة لاحقًا',
      'invalid_credential': 'بيانات الدخول غير صحيحة',
      'weak_password': 'كلمة المرور ضعيفة جدًا',
      'email_already_in_use': 'يوجد حساب مسجل بهذا البريد الإلكتروني',
      'operation_not_allowed': 'تم تعطيل تسجيل الدخول بالبريد الإلكتروني',
    },
  };

  String _getDialogText(String key, String lang) {
    return _dialogTranslations[lang]?[key] ?? _dialogTranslations['en']![key] ?? key;
  }

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  _setInitialScreen(User? user) async {
    if (!Get.isRegistered<AuthController>()) return;

    if (user == null) {
      currentUser.value = null;
      if (Get.currentRoute != '/login') {
         Get.offAllNamed('/login');
      }
    } else {
      UserModel? firestoreUser = await _fetchUserFromFirestore(user.uid);
      
      if (firestoreUser != null) {
        currentUser.value = firestoreUser;
      } else {
        currentUser.value = UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName,
          photoUrl: user.photoURL,
        );
      }
      
      if (Get.currentRoute != '/main' && Get.currentRoute != '/home') {
          Get.offAllNamed('/main'); 
      }
    }
  }

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

  // Updated login method - accepts language parameter
  Future<void> login(String email, String password, {String lang = 'en'}) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
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

        Get.snackbar(
          _getDialogText('success', lang),
          _getDialogText('login_success', lang),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorKey = 'login_failed';
      switch (e.code) {
        case 'user-not-found':
          errorKey = 'user_not_found';
          break;
        case 'wrong-password':
          errorKey = 'wrong_password';
          break;
        case 'invalid-email':
          errorKey = 'invalid_email';
          break;
        case 'user-disabled':
          errorKey = 'user_disabled';
          break;
        case 'too-many-requests':
          errorKey = 'too_many_requests';
          break;
        case 'invalid-credential':
          errorKey = 'invalid_credential';
          break;
      }

      Get.snackbar(
        _getDialogText('error', lang),
        _getDialogText(errorKey, lang),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        _getDialogText('error', lang),
        _getDialogText('unexpected_error', lang),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Updated signup method - accepts language parameter
  Future<void> signup(String email, String password, String name, {File? profileImage, String lang = 'en'}) async {
    try {
      isLoading.value = true;
      String? photoUrl;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? newUser = userCredential.user;

      if (newUser != null) {
        String uid = newUser.uid;
        
        if (profileImage != null) {
          photoUrl = await _uploadProfileImage(uid, profileImage);
        }
        
        await newUser.updateDisplayName(name);
        if (photoUrl != null) {
          await newUser.updatePhotoURL(photoUrl);
        }
        await newUser.reload();

        User? updatedUser = auth.currentUser;

        UserModel newUserModel = UserModel(
          id: updatedUser!.uid,
          email: updatedUser.email ?? '',
          name: updatedUser.displayName,
          photoUrl: updatedUser.photoURL,
        );
        
        await _saveUserToFirestore(newUserModel);
        await auth.signOut();

        Get.snackbar(
          _getDialogText('success', lang),
          _getDialogText('signup_success', lang),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        Get.offAllNamed('/login');
      }
    } on FirebaseAuthException catch (e) {
      String errorKey = 'signup_failed';

      switch (e.code) {
        case 'weak-password':
          errorKey = 'weak_password';
          break;
        case 'email-already-in-use':
          errorKey = 'email_already_in_use';
          break;
        case 'invalid-email':
          errorKey = 'invalid_email';
          break;
        case 'operation-not-allowed':
          errorKey = 'operation_not_allowed';
          break;
      }

      Get.snackbar(
        _getDialogText('error', lang),
        _getDialogText(errorKey, lang),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        _getDialogText('error', lang),
        _getDialogText('unexpected_error', lang),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Updated resetPassword method - accepts language parameter
  Future<void> resetPassword(String email, {String lang = 'en'}) async {
    try {
      isLoading.value = true;

      await auth.sendPasswordResetEmail(email: email);

      Get.snackbar(
        _getDialogText('success', lang),
        '${_getDialogText('reset_link_sent', lang)} $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      Get.back();
    } on FirebaseAuthException catch (e) {
      String errorKey = 'reset_failed';

      switch (e.code) {
        case 'user-not-found':
          errorKey = 'user_not_found';
          break;
        case 'invalid-email':
          errorKey = 'invalid_email';
          break;
      }

      Get.snackbar(
        _getDialogText('error', lang),
        _getDialogText(errorKey, lang),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        _getDialogText('error', lang),
        _getDialogText('unexpected_error', lang),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout({String lang = 'en'}) async {
    try {
      await auth.signOut();
      currentUser.value = null;
      Get.offAllNamed('/login');

      Get.snackbar(
        _getDialogText('success', lang),
        _getDialogText('logout_success', lang),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        _getDialogText('error', lang),
        _getDialogText('logout_failed', lang),
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
  final RxString loginScreenLanguage = 'en'.obs;
  final RxString signupScreenLanguage = 'en'.obs;
  final RxString forgotPasswordScreenLanguage = 'en'.obs;
  final RxString mainAppLanguage = 'en'.obs;

  void changeLoginLanguage(String languageCode) {
    loginScreenLanguage.value = languageCode;
    update(['login_screen']);
  }

  void changeSignupLanguage(String languageCode) {
    signupScreenLanguage.value = languageCode;
    update(['signup_screen']);
  }

  void changeForgotPasswordLanguage(String languageCode) {
    forgotPasswordScreenLanguage.value = languageCode;
    update(['forgot_password_screen']);
  }

  void changeMainAppLanguage(String languageCode) {
    mainAppLanguage.value = languageCode;
    update(['main_app']);
  }

  String getTranslation(String key, String screenLanguage) {
    final translations = _getTranslations();
    return translations[screenLanguage]?[key] ?? key;
  }

  String getMainAppTranslation(String key) {
    return getTranslation(key, mainAppLanguage.value);
  }

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
        'need_help': 'Need Help?',
        'forgot_password_header': 'Forgot Password?',
        'reset_password_instruction': 'Enter your email and we\'ll send you a reset link',
        'send_reset_link': 'Send Reset Link',
        'back_to_login': 'Back to Login',
        'welcome': 'Welcome',
        'language': 'Language',
        'home_exercises': 'Home Exercises',
        'definitions': 'Definitions',
        'parent_tips': 'Parent Tips',
        'questions_answers': 'Questions & Answers',
        'free_pdf_materials': 'Free PDF Materials',
        'quiz': 'Quiz',
        'app_questions': 'App Questions',
        'home_tab': 'Home',
        'result_tab': 'Results',
        'setting': 'Settings',
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
        'need_help': 'تحتاج مساعدة؟',
        'forgot_password_header': 'هل نسيت كلمة المرور؟',
        'reset_password_instruction': 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين',
        'send_reset_link': 'إرسال رابط إعادة التعيين',
        'back_to_login': 'العودة لتسجيل الدخول',
        'welcome': 'مرحبا',
        'language': 'اللغة',
        'home_exercises': 'تمارين منزلية',
        'definitions': 'التعريفات',
        'parent_tips': 'نصائح للآباء',
        'questions_answers': 'أسئلة وأجوبة',
        'free_pdf_materials': 'مواد PDF مجانية',
        'quiz': 'اختبار',
        'app_questions': 'أسئلة التطبيق',
        'home_tab': 'الرئيسية',
        'result_tab': 'النتائج',
        'setting': 'الإعدادات',
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