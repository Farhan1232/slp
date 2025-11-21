import 'dart:ui';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinksController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final RxList<Map<String, dynamic>> videos = <Map<String, dynamic>>[].obs;
  final RxString headerTitle = ''.obs;
  final RxString headerDescription = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  // Language selection
  final RxString currentLanguage = 'english'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHeaderData();
    fetchVideosData();
  }

  // Change language
  void changeLanguage(String language) {
    if (currentLanguage.value != language) {
      currentLanguage.value = language;
      fetchHeaderData();
      fetchVideosData();
    }
    Get.updateLocale(Locale(language == 'arabic' ? 'ar_AR' : 'en_US'));
  }

  // Fetch header section data
  Future<void> fetchHeaderData() async {
    try {
      final docSnapshot = await _firestore
          .collection('screens_title')
          .doc('Questions & Answers(أسئلة وأجوبة)')
          .collection(currentLanguage.value)
          .doc('content')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        headerTitle.value = data?['title'] ?? 
            (currentLanguage.value == 'arabic' 
                ? 'فيديوهات الأسئلة الشائعة' 
                : 'Frequently Asked Questions Videos');
        headerDescription.value = data?['description'] ?? 
            (currentLanguage.value == 'arabic'
                ? 'مجموعة من الفيديوهات التعليمية تجيب على أكثر الأسئلة شيوعاً'
                : 'A collection of educational videos answering the most common questions');
      }
    } catch (e) {
      print('Error fetching header data: $e');
      errorMessage.value = 'Failed to load header data';
      // Set default values
      headerTitle.value = currentLanguage.value == 'arabic' 
          ? 'فيديوهات الأسئلة الشائعة' 
          : 'Frequently Asked Questions Videos';
      headerDescription.value = currentLanguage.value == 'arabic'
          ? 'مجموعة من الفيديوهات التعليمية تجيب على أكثر الأسئلة شيوعاً'
          : 'A collection of educational videos answering the most common questions';
    }
  }

  // Fetch videos data
  Future<void> fetchVideosData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final docSnapshot = await _firestore
          .collection('videos')
          .doc(currentLanguage.value)
          .collection('questions')
          .doc('data')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final videosArray = data?['videos'] as List<dynamic>? ?? [];

        // Convert the array to our format
        videos.clear();
        for (var videoData in videosArray) {
          if (videoData is Map<String, dynamic>) {
            videos.add({
              'id': videoData['id'] ?? '',
              'title': videoData['title'] ?? '',
              'videoUrl': videoData['videoUrl'] ?? '',
              'thumbnailUrl': videoData['thumbnailUrl'] ?? '',
              'isWatched': videoData['isWatched'] ?? false,
              'createdAt': videoData['createdAt'] ?? '',
            });
          }
        }
      } else {
        errorMessage.value = currentLanguage.value == 'arabic' 
            ? 'لا توجد فيديوهات' 
            : 'No videos found';
      }
    } catch (e) {
      print('Error fetching videos data: $e');
      errorMessage.value = currentLanguage.value == 'arabic'
          ? 'فشل تحميل الفيديوهات: $e'
          : 'Failed to load videos: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await Future.wait([
      fetchHeaderData(),
      fetchVideosData(),
    ]);
  }

  // Mark video as watched
  Future<void> markVideoAsWatched(int index) async {
    try {
      if (index < 0 || index >= videos.length) return;

      // Update local state
      videos[index]['isWatched'] = true;

      // Update in Firestore
      final docRef = _firestore
          .collection('videos')
          .doc(currentLanguage.value)
          .collection('questions')
          .doc('data');

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final videosArray = List<Map<String, dynamic>>.from(data?['videos'] ?? []);
        
        if (index < videosArray.length) {
          videosArray[index]['isWatched'] = true;
          await docRef.update({'videos': videosArray});
        }
      }
    } catch (e) {
      print('Error marking video as watched: $e');
    }
  }
}