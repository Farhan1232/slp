// lib/controllers/terms_controller.dart

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:slp/Model/term_model.dart';


class TermsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  var isLoading = true.obs;
  var selectedLanguage = 'english'.obs;
  
  // Screen title data
  var screenTitle = ''.obs;
  var screenDescription = ''.obs;
  
  // Terms content data
  var termsContent = ''.obs;
  
  // Error handling
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  // Fetch all data
  Future<void> fetchAllData() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      await Future.wait([
        fetchScreenTitle(),
        fetchTermsContent(),
      ]);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch screen title from Firestore
  // Path: screens_title/Terms & Conditions(الشروط والأحكام)/{language}/content
  Future<void> fetchScreenTitle() async {
    try {
      final docSnapshot = await _firestore
          .collection('screens_title')
          .doc('Terms & Conditions(الشروط والأحكام)')
          .collection(selectedLanguage.value)
          .doc('content')
          .get();

      if (docSnapshot.exists) {
        final data = ScreenTitleModel.fromMap(docSnapshot.data()!);
        screenTitle.value = data.title;
        screenDescription.value = data.description;
      }
    } catch (e) {
      print('Error fetching screen title: $e');
      // Set default values if fetch fails
      if (selectedLanguage.value == 'arabic') {
        screenTitle.value = 'الشروط والأحكام';
        screenDescription.value = 'يرجى قراءة الشروط والأحكام بعناية قبل استخدام التطبيق';
      } else {
        screenTitle.value = 'Terms and Conditions';
        screenDescription.value = 'Please read the terms and conditions carefully before using the app.';
      }
    }
  }

  // Fetch terms content from Firestore
  // Path: terms_conditions/{language}/content/data
  Future<void> fetchTermsContent() async {
    try {
      final docSnapshot = await _firestore
          .collection('terms_conditions')
          .doc(selectedLanguage.value)
          .collection('content')
          .doc('data')
          .get();

      if (docSnapshot.exists) {
        final data = TermsContentModel.fromMap(docSnapshot.data()!);
        termsContent.value = data.description;
      }
    } catch (e) {
      print('Error fetching terms content: $e');
      termsContent.value = '';
    }
  }

  // Toggle language
  void toggleLanguage(String language) {
    if (selectedLanguage.value != language) {
      selectedLanguage.value = language;
      fetchAllData();
    }
    Get.updateLocale(Locale(language == 'arabic' ? 'ar' : 'en'));
  }

  // Check if current language is RTL
  bool get isRTL => selectedLanguage.value == 'arabic';
}