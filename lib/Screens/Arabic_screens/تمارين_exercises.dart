import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeExercisesScreen extends StatelessWidget {
  const HomeExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800), // Standard mobile design size
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE), // White background
      appBar: AppBar(
        title: Text(
          'التدريبات المنزلية',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D9C99), // Teal Green
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header Note Section
              _buildHeaderNote(),
              SizedBox(height: 40.h),

              // Buttons Section
              _buildExerciseButton(
                title: 'تدريبات اللغة الاستقبالية',
                description: 'تحسين فهم اللغة والاستجابة للمؤثرات السمعية',
                icon: Icons.hearing,
                color: const Color(0xFF5D9C99), // Teal Green
                onTap: () => Get.toNamed('/receptive-language'),
              ),
              SizedBox(height: 20.h),
              _buildExerciseButton(
                title: 'تدريبات اللغة التعبيرية',
                description: 'تنمية مهارات التعبير اللغوي والتواصل الشفهي',
                icon: Icons.record_voice_over,
                color: const Color(0xFFF8B134), // Mustard Yellow
                onTap: () => Get.toNamed('/expressive-language'),
              ),
              SizedBox(height: 20.h),
              _buildExerciseButton(
                title: 'تدريبات الوجه والفكين',
                description: 'تقوية عضلات الوجه والفكين للنطق السليم',
                icon: Icons.face,
                color: const Color(0xFF37817D), // Darker Teal
                onTap: () => Get.toNamed('/face-and-jaw'),
              ),
              SizedBox(height: 20.h), // Extra space at bottom for scrolling
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderNote() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5D9C99).withOpacity(0.1), // Teal Green light
            const Color(0xFFF8B134).withOpacity(0.05), // Mustard Yellow light
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
        children: [
          // Decorative Icon
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134), // Mustard Yellow
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: const Color(0xFF082726), // Dark Border
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'ملاحظة هامة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'من الضروري التنويه هنا إلى أن تحديد الأهداف التدريبية يتوقف على المستوى اللغوي للطفل، والذي يحدده اختصاصي النطق واللغة، ولكن هنا قمت بإدراج بعض الأهداف المألوفة لكل شق من اللغة ولتدريبات الوجه والفكين',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF082726), // Dark Border
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
  }) {
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
          foregroundColor: const Color(0xFF082726), // Dark Border
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
          children: [
            // Arrow Icon
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
              child: Icon(
                Icons.arrow_back_ios_new,
                color: color,
                size: 18.sp,
              ),
            ),
            
            // Text Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF082726), // Dark Border
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF37817D), // Darker Teal
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Main Icon
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF082726), // Dark Border
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