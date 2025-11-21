import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeExercisesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var currentLanguage = 'english'.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  
  var headerData = <String, String>{}.obs;
  var exerciseItems = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void toggleLanguage(String language) {
    currentLanguage.value = language;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final docRef = _firestore
          .collection('screens_title')
          .doc('Home Exercises(تمارين منزلية)')
          .collection(currentLanguage.value)
          .doc('content');

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('البيانات غير متوفرة');
      }

      final data = docSnapshot.data();
      final items = data?['items'] as List<dynamic>? ?? [];

      if (items.isEmpty) {
        throw Exception('لا توجد بيانات');
      }

      // First item (index 0) is header
      if (items.isNotEmpty) {
        final headerItem = items[0] as Map<String, dynamic>;
        headerData.value = {
          'title': headerItem['title']?.toString() ?? '',
          'description': headerItem['description']?.toString() ?? '',
        };
      }

      // Remaining items (index 1, 2, 3...) are exercise buttons
      exerciseItems.value = items
          .skip(1)
          .map((item) => {
                'title': item['title']?.toString() ?? '',
                'description': item['description']?.toString() ?? '',
              })
          .toList();

    } catch (e) {
      errorMessage.value = 'حدث خطأ: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToExercise(int index) {
    // Pass the header data for the corresponding exercise screen
    final headerToPass = exerciseItems[index];
    
    switch (index) {
      case 0:
        Get.toNamed(
          '/receptive-language',
          arguments: {
            'language': currentLanguage.value,
            'headerData': headerToPass,
          },
        );
        break;
      case 1:
        Get.toNamed(
          '/expressive-language',
          arguments: {
            'language': currentLanguage.value,
            'headerData': headerToPass,
          },
        );
        break;
      case 2:
        Get.toNamed(
          '/face-and-jaw',
          arguments: {
            'language': currentLanguage.value,
            'headerData': headerToPass,
          },
        );
        break;
    }
  }
}