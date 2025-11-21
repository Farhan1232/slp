import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slp/Model/auth_model.dart';
import 'package:slp/constant/App_constant.dart';
import 'package:slp/controller/auth_controller.dart'; 
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  
  final AuthController _authController = Get.find<AuthController>();

  final Rx<String?> profileImageUrl = Rx<String?>(null);
  final RxBool isLoading = false.obs;
  final Rx<AppInfoModel?> appInfo = Rx<AppInfoModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfileImageUrl();
    fetchAppInfo();
  }
  
  String? get currentUserId => _authController.currentUser.value?.id;
  
  Future<void> fetchProfileImageUrl() async {
    final userId = currentUserId;
    if (userId == null) {
      print('User ID is null. Cannot fetch profile image URL.');
      return;
    }
    
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data()!.containsKey('photoUrl')) {
        profileImageUrl.value = userDoc.data()!['photoUrl'] as String?;
      }
    } catch (e) {
      print('Error fetching profile image URL: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final userId = currentUserId;
    if (userId == null) {
      Get.snackbar('Error', 'User not logged in.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        isLoading.value = true;
        File imageFile = File(image.path);
        
        final storageRef = _storage.ref().child('profile_images/$userId.jpg');
        await storageRef.putFile(imageFile);
        
        final downloadUrl = await storageRef.getDownloadURL();
        
        await _firestore.collection('users').doc(userId).update({
          'photoUrl': downloadUrl,
        });
        
        profileImageUrl.value = downloadUrl;
        
        Get.snackbar(
          'Success',
          'Profile image updated',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error picking/uploading image: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile image. Try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

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

  // Share app with platform-specific links
  void shareApp() {
    try {
      Share.share(
        AppConstants.shareMessage,
        subject: 'App Recommendation',
      );
    } catch (e) {
      print('Error sharing app: $e');
      Get.snackbar(
        'Error',
        'Unable to share app. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
            
            // Star Rating Row
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
            
            // Comment Box
            TextField(
              controller: feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your feedback (optional)...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Submit Button
            GestureDetector(
              onTap: () async {
                if (selectedStars.value == 0) {
                  Get.snackbar(
                    'Rating Required', 
                    'Please select at least one star',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                try {
                  // Save feedback to Firestore
                  await _firestore.collection('app_feedback').add({
                    'userId': currentUserId,
                    'stars': selectedStars.value,
                    'comment': feedbackController.text.trim(),
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  Get.back(); // Close bottom sheet

                  Get.snackbar(
                    'Thank You!',
                    'Your feedback has been submitted successfully.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  // Redirect to appropriate store based on platform
                  String storeUrl;
                  if (Platform.isAndroid) {
                    storeUrl = AppConstants.playStoreFeedbackUrl;
                  } else if (Platform.isIOS) {
                    storeUrl = AppConstants.appStoreFeedbackUrl;
                  } else {
                    storeUrl = AppConstants.playStoreFeedbackUrl;
                  }

                  final Uri url = Uri.parse(storeUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                } catch (e) {
                  print('Error submitting feedback: $e');
                  Get.snackbar(
                    'Error',
                    'Failed to submit feedback. Please try again.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D9C99),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5D9C99).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Submit Feedback',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }
}