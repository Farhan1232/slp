import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpressiveLanguageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var currentLanguage = 'english'.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  
  var headerData = <String, String>{}.obs;
  var videos = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    final args = Get.arguments;
    if (args != null) {
      currentLanguage.value = args['language'] ?? 'english';
      headerData.value = Map<String, String>.from(args['headerData'] ?? {});
    }
    
    fetchVideos();
  }

  void toggleLanguage(String language) {
    currentLanguage.value = language;
    fetchHeaderData();
    fetchVideos();
  }

  Future<void> fetchHeaderData() async {
    try {
      final docRef = _firestore
          .collection('screens_title')
          .doc('Home Exercises(تمارين منزلية)')
          .collection(currentLanguage.value)
          .doc('content');

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        return;
      }

      final data = docSnapshot.data();
      final items = data?['items'] as List<dynamic>? ?? [];

      if (items.length > 2) {
        final expressiveItem = items[2] as Map<String, dynamic>;
        headerData.value = {
          'title': expressiveItem['title']?.toString() ?? '',
          'description': expressiveItem['description']?.toString() ?? '',
        };
      }
    } catch (e) {
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
      'language': currentLanguage.value, // ADDED: Pass current language
    });
  }
}