// 1. Model Class (about_app_model.dart)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AboutAppModel {
  final String description;
  final String language;
  final DateTime? lastUpdated;

  AboutAppModel({
    required this.description,
    required this.language,
    this.lastUpdated,
  });

  factory AboutAppModel.fromFirestore(Map<String, dynamic> data) {
    return AboutAppModel(
      description: data['description'] ?? '',
      language: data['language'] ?? '',
      lastUpdated: data['lastUpdated'] != null 
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }
  
  // Split description into paragraphs (split by " - ")
  List<String> get paragraphs {
    return description
        .split(' - ')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }
  
  // Extract email from description
  String get contactEmail {
    final emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
    final match = emailRegex.firstMatch(description);
    return match?.group(0) ?? 'slpworldapp@gmail.com';
  }
}

// Screen Title Model
class ScreenTitleModel {
  final String title;
  final String description;

  ScreenTitleModel({
    required this.title,
    required this.description,
  });

  factory ScreenTitleModel.fromFirestore(Map<String, dynamic> data) {
    return ScreenTitleModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

// 2. Controller (about_app_controller.dart)



class AboutAppController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable variables
  var isLoading = true.obs;
  var selectedLanguage = 'english'.obs; // default language
  Rx<ScreenTitleModel?> screenTitleData = Rx<ScreenTitleModel?>(null);
  Rx<AboutAppModel?> aboutData = Rx<AboutAppModel?>(null);
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  // Load data based on selected language
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      
      // Fetch screen title
      await fetchScreenTitle();
      
      // Fetch about content
      await fetchAboutContent();
      
    } catch (e) {
      print('Error loading data: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch screen title from Firestore
  Future<void> fetchScreenTitle() async {
    try {
      final languageCollection = selectedLanguage.value; // arabic or english
      
      final docSnapshot = await _firestore
          .collection('screens_title')
          .doc('About the App(نبذة عن التطبيق)')
          .collection(languageCollection)
          .doc('content')
          .get();
      
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          screenTitleData.value = ScreenTitleModel.fromFirestore(data);
        }
      }
    } catch (e) {
      print('Error fetching screen title: $e');
      // Set default values
      screenTitleData.value = ScreenTitleModel(
        title: selectedLanguage.value == 'arabic' ? 'عن التطبيق' : 'About App',
        description: '',
      );
    }
  }
  
  // Fetch about content from Firestore
  Future<void> fetchAboutContent() async {
    try {
      final languageDoc = selectedLanguage.value == 'arabic' 
          ? 'Arabic (العربية)' 
          : 'english';
      
      final docSnapshot = await _firestore
          .collection('about')
          .doc(languageDoc)
          .collection('content')
          .doc('data')
          .get();
      
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          aboutData.value = AboutAppModel.fromFirestore(data);
        }
      }
    } catch (e) {
      print('Error fetching about content: $e');
    }
  }
  
  // Switch language
  void switchLanguage(String language) {
    if (selectedLanguage.value != language) {
      selectedLanguage.value = language;
      loadData();
    }
    Get.updateLocale(Locale(selectedLanguage.value == 'arabic' ? 'ar_AR' : 'en_US'));
  }
}



// 3. View (about_app_screen.dart)


class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutAppController());
    
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
    title: Text(
      'about'.tr, // <-- use GetX localization key
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    backgroundColor: const Color(0xFF5D9C99),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20.r),
        bottomRight: Radius.circular(20.r),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF5D9C99),
            ),
          );
        }
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Directionality(
            textDirection: controller.selectedLanguage.value == 'arabic' 
                ? TextDirection.rtl 
                : TextDirection.ltr,
            child: Column(
              children: [
                // Language Switcher
                _buildLanguageSwitcher(controller),
                SizedBox(height: 20.h),
                
                // Header Section
                _buildHeaderSection(controller),
                SizedBox(height: 30.h),
                
                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: controller.selectedLanguage.value == 'arabic'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // Display all paragraphs from description
                        if (controller.aboutData.value != null)
                          ...controller.aboutData.value!.paragraphs.asMap().entries.map((entry) {
                            return Column(
                              children: [
                                _buildParagraph(
                                  entry.value,
                                  controller.selectedLanguage.value,
                                ),
                                if (entry.key < controller.aboutData.value!.paragraphs.length - 1)
                                  SizedBox(height: 20.h),
                              ],
                            );
                          }).toList(),
                        
                        SizedBox(height: 40.h),
                        
                        // Contact Section
                        if (controller.aboutData.value != null)
                          _buildContactSection(
                            controller.aboutData.value!,
                            controller.selectedLanguage.value,
                          ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLanguageSwitcher(AboutAppController controller) {
    return Obx(() => Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF5D9C99).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLanguageButton(
              'العربية',
              'arabic',
              controller.selectedLanguage.value == 'arabic',
              () => controller.switchLanguage('arabic'),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildLanguageButton(
              'English',
              'english',
              controller.selectedLanguage.value == 'english',
              () => controller.switchLanguage('english'),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildLanguageButton(
    String label,
    String value,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D9C99) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF37817D),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(AboutAppController controller) {
    return Obx(() {
      final titleData = controller.screenTitleData.value;
      if (titleData == null) return SizedBox.shrink();
      
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF5D9C99).withOpacity(0.1),
              const Color(0xFFF8B134).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF5D9C99).withOpacity(0.3),
            width: 1.5.w,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF37817D).withOpacity(0.1),
              blurRadius: 15.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8B134),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF8B134).withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.info,
                color: const Color(0xFF082726),
                size: 35.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: controller.selectedLanguage.value == 'arabic'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    titleData.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF082726),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    titleData.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF37817D),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildParagraph(String text, String language) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF37817D).withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            margin: EdgeInsets.only(
              left: language == 'arabic' ? 12.w : 0,
              right: language == 'english' ? 12.w : 0,
              top: 2.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF5D9C99),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: language == 'arabic' ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.7,
                color: const Color(0xFF082726),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(AboutAppModel data, String language) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5D9C99).withOpacity(0.1),
            const Color(0xFFF8B134).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF37817D).withOpacity(0.1),
            blurRadius: 15.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: language == 'arabic' 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          Text(
            language == 'arabic' ? 'للتواصل' : 'Contact Us',
            textAlign: language == 'arabic' ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF082726),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFF8B134).withOpacity(0.3),
                width: 1.5.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: language == 'arabic' 
                  ? MainAxisAlignment.end 
                  : MainAxisAlignment.start,
              children: [
                if (language == 'english') ...[
                  Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8B134).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8B134),
                        width: 1.5.w,
                      ),
                    ),
                    child: Icon(
                      Icons.email,
                      color: const Color(0xFFF8B134),
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: language == 'arabic'
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        language == 'arabic' ? 'البريد الإلكتروني' : 'Email',
                        textAlign: language == 'arabic' ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF37817D),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        data.contactEmail,
                        textAlign: language == 'arabic' ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082726),
                        ),
                      ),
                    ],
                  ),
                ),
                if (language == 'arabic') ...[
                  SizedBox(width: 12.w),
                  Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8B134).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8B134),
                        width: 1.5.w,
                      ),
                    ),
                    child: Icon(
                      Icons.email,
                      color: const Color(0xFFF8B134),
                      size: 22.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}