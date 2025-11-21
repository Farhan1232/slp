import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/expressiveLanguage_controller.dart';

class ExpressiveLanguageScreen extends StatelessWidget {
  const ExpressiveLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    final controller = Get.put(ExpressiveLanguageController());
    
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final crossAxisAlignment = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        title: Text(
          'expressive_language'.tr,
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

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.fetchVideos(),
                  child: Text('try_again'.tr),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
              crossAxisAlignment: crossAxisAlignment, 
              children: [
                _buildLanguageToggle(controller),
                SizedBox(height: 20.h),
                // CHANGED: Wrapped in Obx() to rebuild when headerData changes
                Obx(() => _buildHeaderSection(controller, isRtl)),
                SizedBox(height: 20.h),
                _buildExercisesList(controller, isRtl),
              ],
            ),
        );
      }),
    );
  }

  Widget _buildLanguageToggle(ExpressiveLanguageController controller) {
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
            child: _buildLanguageButton('العربية', 'arabic', controller),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildLanguageButton('English', 'english', controller),
          ),
        ],
      ),
    ));
  }

  Widget _buildLanguageButton(String label, String language, ExpressiveLanguageController controller) {
    final isSelected = controller.currentLanguage.value == language;
    
    return GestureDetector(
      onTap: () => controller.toggleLanguage(language),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D9C99) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF5D9C99),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ExpressiveLanguageController controller, bool isRtl) {
    final crossAxisAlignment = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    final defaultTitle = isRtl ? 'تمارين اللغة التعبيرية' : 'Expressive Language Exercises';
    final defaultDescription = isRtl 
        ? 'تدريبات لتحسين التعبير اللغوي ومهارات التواصل الشفهي' 
        : 'Exercises to improve verbal expression and oral communication skills.';

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
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF082726), width: 2.w),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF8B134).withOpacity(0.3),
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Icon(Icons.record_voice_over, color: const Color(0xFF082726), size: 30.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(
                  // CHANGED: Access via .value since headerData is now observable
                  controller.headerData.value['title'] ?? defaultTitle,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  // CHANGED: Access via .value since headerData is now observable
                  controller.headerData.value['description'] ?? defaultDescription,
                  textAlign: TextAlign.start,
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
  }

  Widget _buildExercisesList(ExpressiveLanguageController controller, bool isRtl) {
    final crossAxisAlignment = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.videos.length,
        itemBuilder: (context, index) {
          final video = controller.videos[index];
          final exerciseNumberText = isRtl ? 'تمرين ${index + 1}' : 'Exercise ${index + 1}';

          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF37817D).withOpacity(0.1),
                  blurRadius: 8.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF082726),
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 0,
                side: BorderSide(color: const Color(0xFF5D9C99).withOpacity(0.2), width: 1.w),
              ),
              onPressed: () => controller.playVideo(index),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D9C99),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF082726), width: 1.5.w),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5D9C99).withOpacity(0.3),
                          blurRadius: 6.r,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 24.sp),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        crossAxisAlignment: crossAxisAlignment,
                        children: [
                          Text(
                            video['title'] ?? '',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: const Color(0xFF082726),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            exerciseNumberText,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: const Color(0xFF37817D),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8B134).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF8B134), width: 1.5.w),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082726),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}