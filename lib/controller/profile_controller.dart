
// profile_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slp/Model/auth_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  
  final Rx<String?> localImagePath = Rx<String?>(null);
  final RxBool isLoading = false.obs;
  final Rx<AppInfoModel?> appInfo = Rx<AppInfoModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadLocalImage();
    fetchAppInfo();
  }

  // Load image from local storage
  Future<void> loadLocalImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('profile_image');
      if (imagePath != null && File(imagePath).existsSync()) {
        localImagePath.value = imagePath;
      }
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        // Save path to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image', image.path);
        localImagePath.value = image.path;

        Get.snackbar(
          'Success',
          'Profile image updated',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fetch app info from Firestore
  Future<void> fetchAppInfo() async {
    try {
      isLoading.value = true;
      
      DocumentSnapshot doc = await _firestore
          .collection('app_info')
          .doc('settings')
          .get();

      if (doc.exists) {
        appInfo.value = AppInfoModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching app info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Share app
  void shareApp() {
    Share.share(
      'Check out this amazing app! Download it now from Play Store',
      subject: 'App Recommendation',
    );
  }

 // Open custom rating & feedback bottom sheet
void openRating() {
  final RxInt selectedStars = 0.obs;
  final TextEditingController feedbackController = TextEditingController();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Rate Our App',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          
          // ⭐ Star Rating Row
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedStars.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => selectedStars.value = index + 1,
                  );
                }),
              )),
              
          const SizedBox(height: 15),
          
          // 💬 Comment Box
          TextField(
            controller: feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your feedback...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 📤 Submit Button
          GestureDetector(
            onTap: () async {
              if (selectedStars.value == 0) {
                Get.snackbar('Rating Required', 'Please select stars first',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }

              // 👇 Save feedback to Firestore
              await _firestore.collection('app_feedback').add({
                'stars': selectedStars.value,
                'comment': feedbackController.text.trim(),
                'timestamp': DateTime.now(),
              });

              Get.back(); // Close bottom sheet

              Get.snackbar(
                'Thank You!',
                'Your feedback has been submitted successfully.',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );

              // 🔗 Redirect to Play Store
              final Uri url = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.yourapp.package');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Post Feedback',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

}
