import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Controller
class PrivacyPolicyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable variables
  var isLoading = true.obs;
  var selectedLanguage = 'english'.obs;
  
  // Screen title data
  var screenTitle = ''.obs;
  var screenDescription = ''.obs;
  
  // Privacy policy data
  var privacyDescription = ''.obs;
  var privacyLanguage = ''.obs;
  var lastUpdated = Rx<Timestamp?>(null);
  
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
  
  // Fetch all data
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchScreenTitle(),
        fetchPrivacyPolicy(),
      ]);
    } catch (e) {
      print('Error fetching data: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ في تحميل البيانات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch screen title
  Future<void> fetchScreenTitle() async {
    try {
      final doc = await _firestore
          .collection('screens_title')
          .doc('Privacy Policy(سياسة الخصوصية)')
          .collection(selectedLanguage.value)
          .doc('content')
          .get();
      
      if (doc.exists) {
        final data = doc.data();
        screenTitle.value = data?['title'] ?? '';
        screenDescription.value = data?['description'] ?? '';
      }
    } catch (e) {
      print('Error fetching screen title: $e');
    }
  }
  
  // Fetch privacy policy
  Future<void> fetchPrivacyPolicy() async {
    try {
      final querySnapshot = await _firestore
          .collection('privacy_policy')
          .doc(selectedLanguage.value)
          .collection('content')
          .doc('data')
          .get();
      
      if (querySnapshot.exists) {
        final data = querySnapshot.data();
        privacyDescription.value = data?['description'] ?? '';
        privacyLanguage.value = data?['language'] ?? '';
        lastUpdated.value = data?['lastUpdated'] as Timestamp?;
      }
    } catch (e) {
      print('Error fetching privacy policy: $e');
    }
  }
  
  // Change language
  void changeLanguage(String language) {
    selectedLanguage.value = language;
    fetchData();
    Get.updateLocale(Locale(language == 'arabic' ? 'ar' : 'en'));
  }
  
  // Format date
  String getFormattedDate() {
    if (lastUpdated.value != null) {
      final date = lastUpdated.value!.toDate();
      return '${date.year}/${date.month}/${date.day}';
    }
    return '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';
  }
}

// Privacy Screen
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(PrivacyPolicyController());
    
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
    title: Text(
      'privacy_policy'.tr, // <-- use GetX localization key
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              // Language Toggle Button
              _buildLanguageToggle(controller),
              SizedBox(height: 16.h),
              
              // Header Section
              _buildHeaderSection(controller),
              SizedBox(height: 20.h),
              
              // Privacy Content
              _buildPrivacyContent(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLanguageToggle(PrivacyPolicyController controller) {
    return Obx(() => Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.3),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF37817D).withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeLanguage('english'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: controller.selectedLanguage.value == 'english'
                      ? const Color(0xFF5D9C99)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    'English',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: controller.selectedLanguage.value == 'english'
                          ? Colors.white
                          : const Color(0xFF37817D),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeLanguage('arabic'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: controller.selectedLanguage.value == 'arabic'
                      ? const Color(0xFF5D9C99)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    'العربية',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: controller.selectedLanguage.value == 'arabic'
                          ? Colors.white
                          : const Color(0xFF37817D),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildHeaderSection(PrivacyPolicyController controller) {
    return Obx(() => Container(
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
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726),
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.privacy_tip,
              color: const Color(0xFF082726),
              size: 30.sp,
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
                  controller.screenTitle.value.isNotEmpty
                      ? controller.screenTitle.value
                      : 'سياسة الخصوصية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726),
                  ),
                  textAlign: controller.selectedLanguage.value == 'arabic'
                      ? TextAlign.right
                      : TextAlign.left,
                ),
                SizedBox(height: 6.h),
                Text(
                  controller.screenDescription.value.isNotEmpty
                      ? controller.screenDescription.value
                      : 'حماية بياناتك وخصوصيتك هي أولويتنا الأساسية',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF37817D),
                    height: 1.4,
                  ),
                  textAlign: controller.selectedLanguage.value == 'arabic'
                      ? TextAlign.right
                      : TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildPrivacyContent(PrivacyPolicyController controller) {
    return Expanded(
      child: Obx(() => Container(
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
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Security Badge
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF5D9C99).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF5D9C99),
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.security,
                  color: const Color(0xFF5D9C99),
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 20.h),
              
              // Privacy Commitment
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D9C99).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF5D9C99).withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: controller.selectedLanguage.value == 'arabic'
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: controller.selectedLanguage.value == 'arabic'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (controller.selectedLanguage.value == 'arabic') ...[
                          Icon(
                            Icons.verified_user,
                            color: const Color(0xFF5D9C99),
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Expanded(
                          child: Text(
                            controller.selectedLanguage.value == 'arabic'
                                ? 'التزامنا بحماية خصوصيتك'
                                : 'Our Commitment to Your Privacy',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF082726),
                            ),
                            textAlign: controller.selectedLanguage.value == 'arabic'
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                        if (controller.selectedLanguage.value == 'english') ...[
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.verified_user,
                            color: const Color(0xFF5D9C99),
                            size: 18.sp,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      controller.selectedLanguage.value == 'arabic'
                          ? 'نحن ملتزمون بحماية بياناتك الشخصية وضمان خصوصيتك في كل خطوة'
                          : 'We are committed to protecting your personal data and ensuring your privacy at every step',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF37817D),
                        height: 1.5,
                      ),
                      textAlign: controller.selectedLanguage.value == 'arabic'
                          ? TextAlign.right
                          : TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // Privacy Text from Firebase
              Text(
                controller.privacyDescription.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.8,
                  color: const Color(0xFF082726),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: controller.selectedLanguage.value == 'arabic'
                    ? TextAlign.right
                    : TextAlign.left,
              ),
              SizedBox(height: 20.h),
              
              // Data Collection Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8B134).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFF8B134).withOpacity(0.3),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: controller.selectedLanguage.value == 'arabic'
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: controller.selectedLanguage.value == 'arabic'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (controller.selectedLanguage.value == 'arabic') ...[
                          Icon(
                            Icons.email,
                            color: const Color(0xFFF8B134),
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Expanded(
                          child: Text(
                            controller.selectedLanguage.value == 'arabic'
                                ? 'بيانات التواصل'
                                : 'Contact Information',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF082726),
                            ),
                            textAlign: controller.selectedLanguage.value == 'arabic'
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                        if (controller.selectedLanguage.value == 'english') ...[
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.email,
                            color: const Color(0xFFF8B134),
                            size: 18.sp,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'slpworldapp@gmail.com',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D9C99),
                        height: 1.5,
                      ),
                      textAlign: controller.selectedLanguage.value == 'arabic'
                          ? TextAlign.right
                          : TextAlign.left,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      controller.selectedLanguage.value == 'arabic'
                          ? 'للاستفسارات حول الخصوصية وحماية البيانات'
                          : 'For inquiries about privacy and data protection',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF37817D),
                        height: 1.5,
                      ),
                      textAlign: controller.selectedLanguage.value == 'arabic'
                          ? TextAlign.right
                          : TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // Last Updated
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF37817D).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFF37817D).withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.update,
                      color: const Color(0xFF37817D),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      controller.selectedLanguage.value == 'arabic'
                          ? 'آخر تحديث: ${controller.getFormattedDate()}'
                          : 'Last Updated: ${controller.getFormattedDate()}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF37817D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}