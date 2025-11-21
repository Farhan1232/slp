import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/Home_exercise_controller.dart';


class HomeExercisesScreen extends StatelessWidget {
  const HomeExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    final controller = Get.put(HomeExercisesController());
    
    // Key: Determine text direction based on current locale (set by GetX)
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        // CHANGED: Use localization key for the title
        title: Text(
          'home_exercises'.tr, 
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
          // Use localization for the error and button text
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
                  onPressed: () => controller.fetchData(),
                  child: Text('try_again'.tr),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              // CHANGED: Use crossAxisAlignment.start, as the main layout is generally LTR
              // but we rely on sub-widgets to handle their own direction.
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                _buildLanguageToggle(controller), 
                SizedBox(height: 20.h),
                _buildHeaderNote(controller, isRtl), // Passed isRtl
                SizedBox(height: 40.h),
                ...controller.exerciseItems.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: _buildExerciseButton(
                      title: entry.value['title'] ?? '',
                      description: entry.value['description'] ?? '',
                      icon: _getIconForIndex(entry.key),
                      color: _getColorForIndex(entry.key),
                      onTap: () => controller.navigateToExercise(entry.key),
                      isRtl: isRtl, // Passed isRtl
                    ),
                  );
                }).toList(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- New Language Toggle Widgets (Unchanged) ---

  Widget _buildLanguageToggle(HomeExercisesController controller) {
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
              controller,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildLanguageButton(
              'English',
              'english',
              controller,
            ),
          ),
        ],
      ),
    ));
  }

Widget _buildLanguageButton(String label, String language, HomeExercisesController controller) {
    final isSelected = controller.currentLanguage.value == language;
    
    return GestureDetector(
      onTap: () => controller.toggleLanguage(language), 
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5D9C99)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF5D9C99),
            ),
          ),
        ),
      ),
    );
  }
  // --- Existing Helper Methods (Modified for LTR/RTL) ---
  
  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.hearing,
      Icons.record_voice_over,
      Icons.face,
    ];
    return icons[index % icons.length];
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF5D9C99),
      const Color(0xFFF8B134),
      const Color(0xFF37817D),
    ];
    return colors[index % colors.length];
  }

  Widget _buildHeaderNote(HomeExercisesController controller, bool isRtl) {
    final headerData = controller.headerData.value;
    
    // Determine cross-axis alignment for the Column inside the Row
    final crossAxisAlignment = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        // CHANGED: Set text direction to correctly position the icon and text
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726),
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: const Color(0xFF082726),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              // CHANGED: Align content based on direction
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(
                  headerData['title'] ?? 'ملاحظة هامة',
                  // CHANGED: Use TextAlign.start for bi-directional support
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  headerData['description'] ?? '',
                  // CHANGED: Use TextAlign.start for bi-directional support
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF082726),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseButton({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isRtl, // Pass directionality
  }) {
    // Determine cross-axis alignment for the Column inside the Row
    final crossAxisAlignment = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF082726),
          padding: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
          side: BorderSide(
            color: color.withOpacity(0.3),
            width: 1.5.w,
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // CHANGED: Set text direction to swap icon positions
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Right-side/End-side Indicator Icon (Arrow)
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 1.5.w,
                ),
              ),
              // Use the standard back arrow, which flips automatically with textDirection
              child: Icon(
                Icons.arrow_back_ios_new,
                color: color,
                size: 18.sp,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  // CHANGED: Align content based on direction
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    Text(
                      title,
                      // CHANGED: Use TextAlign.start for bi-directional support
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF082726),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      // CHANGED: Use TextAlign.start for bi-directional support
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
            ),
            // Left-side/Start-side Main Icon
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}