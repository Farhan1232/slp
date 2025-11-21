import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpressiveLanguageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var currentLanguage = 'english'.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  
  // CHANGED: Make headerData observable so UI updates when it changes
  var headerData = <String, String>{}.obs;
  var videos = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments passed from HomeExercisesScreen
    final args = Get.arguments;
    if (args != null) {
      currentLanguage.value = args['language'] ?? 'english';
      // Set initial header data from arguments
      headerData.value = Map<String, String>.from(args['headerData'] ?? {});
    }
    
    fetchVideos();
  }

  void toggleLanguage(String language) {
    currentLanguage.value = language;
    // Fetch both header data and videos when language changes
    fetchHeaderData();
    fetchVideos();
  }

  // NEW: Fetch header data from Firestore (same structure as HomeExercisesController)
  Future<void> fetchHeaderData() async {
    try {
      final docRef = _firestore
          .collection('screens_title')
          .doc('Home Exercises(تمارين منزلية)')
          .collection(currentLanguage.value)
          .doc('content');

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        return; // Keep existing header data if fetch fails
      }

      final data = docSnapshot.data();
      final items = data?['items'] as List<dynamic>? ?? [];

      // Index 2 is Expressive Language (based on HomeExercisesController navigation)
      if (items.length > 2) {
        final expressiveItem = items[2] as Map<String, dynamic>;
        headerData.value = {
          'title': expressiveItem['title']?.toString() ?? '',
          'description': expressiveItem['description']?.toString() ?? '',
        };
      }
    } catch (e) {
      // Keep existing header data if fetch fails
      print('Error fetching header data: $e');
    }
  }

  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final docRef = _firestore
          .collection('videos')
          .doc(currentLanguage.value)
          .collection('expressive_language')
          .doc('data');

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('البيانات غير متوفرة');
      }

      final data = docSnapshot.data();
      final videosList = data?['videos'] as List<dynamic>? ?? [];

      if (videosList.isEmpty) {
        throw Exception('لا توجد فيديوهات');
      }

      videos.value = videosList
          .map((video) => {
                'id': video['id']?.toString() ?? '',
                'title': video['title']?.toString() ?? '',
                'videoUrl': video['videoUrl']?.toString() ?? '',
                'thumbnailUrl': video['thumbnailUrl']?.toString() ?? '',
                'isWatched': video['isWatched'] ?? false,
                'createdAt': video['createdAt']?.toString() ?? '',
              })
          .toList();

    } catch (e) {
      errorMessage.value = 'حدث خطأ: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void playVideo(int index) {
    final video = videos[index];
    Get.toNamed('/video-player', arguments: {
      'videoUrl': video['videoUrl'],
      'title': video['title'],
      'videoId': video['id'],
    });
  }
}