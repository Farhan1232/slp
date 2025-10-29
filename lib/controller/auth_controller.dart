// ============================================
// CONTROLLERS
// ============================================

// auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slp/Model/auth_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

_setInitialScreen(User? user) async {
  if (user == null) {
    Get.offAllNamed('/login');
  } else {
    // Wait for Firebase to update user info properly
    await Future.delayed(const Duration(milliseconds: 300));

    currentUser.value = UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
    );

    Get.offAllNamed('/main');
  }
}

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        currentUser.value = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName,
          photoUrl: userCredential.user!.photoURL,
        );

        Get.snackbar(
          'تم بنجاح',
          'تم تسجيل الدخول بنجاح!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
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

  Future<void> signup(String email, String password, String name) async {
  try {
    isLoading.value = true;

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      // ✅ Sign out after registration to prevent automatic login
      await _auth.signOut();

      Get.snackbar(
        'تم بنجاح',
        'تم إنشاء الحساب بنجاح! الرجاء تسجيل الدخول الآن.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      // ✅ Go directly to login screen (no flicker)
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

      await _auth.sendPasswordResetEmail(email: email);

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
      await _auth.signOut();
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
    return _auth.currentUser != null;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
