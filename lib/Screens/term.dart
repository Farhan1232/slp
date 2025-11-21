// lib/screens/terms_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/term_controller.dart';


class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final TermsController controller = Get.put(TermsController());

    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
    title: Text(
      'terms_and_conditions'.tr, // <-- use GetX localization key
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
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5D9C99),
            ),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  'حدث خطأ في تحميل البيانات',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF082726),
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.fetchAllData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D9C99),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
              // Terms Content
              _buildTermsContent(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLanguageToggle(TermsController controller) {
    return Container(
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
            child: GestureDetector(
              onTap: () => controller.toggleLanguage('arabic'),
              child: Obx(() => Container(
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
                      fontWeight: FontWeight.w600,
                      color: controller.selectedLanguage.value == 'arabic'
                          ? Colors.white
                          : const Color(0xFF082726),
                    ),
                  ),
                ),
              )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.toggleLanguage('english'),
              child: Obx(() => Container(
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
                      fontWeight: FontWeight.w600,
                      color: controller.selectedLanguage.value == 'english'
                          ? Colors.white
                          : const Color(0xFF082726),
                    ),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(TermsController controller) {
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
        textDirection: controller.isRTL ? TextDirection.rtl : TextDirection.ltr,
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
              Icons.description,
              color: const Color(0xFF082726),
              size: 30.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: controller.isRTL
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  controller.screenTitle.value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726),
                  ),
                  textDirection: controller.isRTL
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
                SizedBox(height: 6.h),
                Text(
                  controller.screenDescription.value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF37817D),
                    height: 1.4,
                  ),
                  textDirection: controller.isRTL
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildTermsContent(TermsController controller) {
    return Expanded(
      child: Container(
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
          child: Obx(() => Column(
            children: [
              // Important Note
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
                child: Row(
                  textDirection: controller.isRTL
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: const Color(0xFFF8B134),
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        controller.isRTL
                            ? 'مهم: باستخدامك للتطبيق فإنك توافق على جميع الشروط والأحكام المذكورة أدناه'
                            : 'Important: By using the app, you agree to all the terms and conditions mentioned below',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF082726),
                          height: 1.5,
                        ),
                        textAlign: controller.isRTL
                            ? TextAlign.right
                            : TextAlign.left,
                        textDirection: controller.isRTL
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Terms Text from Firebase
              Text(
                controller.termsContent.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.8,
                  color: const Color(0xFF082726),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: controller.isRTL ? TextAlign.right : TextAlign.left,
                textDirection:
                    controller.isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              SizedBox(height: 20.h),

              // Agreement Section
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
                  crossAxisAlignment: controller.isRTL
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: controller.isRTL
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      textDirection: controller.isRTL
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF5D9C99),
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          controller.isRTL
                              ? 'موافقة المستخدم'
                              : 'User Agreement',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF082726),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      controller.isRTL
                          ? 'باستمرارك في استخدام التطبيق، فإنك توافق على الالتزام بهذه الشروط والأحكام وأي تعديلات لاحقة عليها'
                          : 'By continuing to use the app, you agree to comply with these terms and conditions and any subsequent amendments',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF37817D),
                        height: 1.5,
                      ),
                      textAlign:
                          controller.isRTL ? TextAlign.right : TextAlign.left,
                      textDirection: controller.isRTL
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}