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

  // Share app with platform-specific links (WhatsApp, SMS, etc.)
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

  // Open rating directly in Play Store or App Store
  Future<void> openRating() async {
    try {
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
      } else {
        Get.snackbar(
          'Error',
          'Unable to open store. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error opening store: $e');
      Get.snackbar(
        'Error',
        'Unable to open store. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}