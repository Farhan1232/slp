import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/quiz_controller.dart';

class QuizScreen extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());

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
          'اختبار النطق واللغة',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
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
        child: Obx(() {
          final q = controller.questions[controller.currentIndex.value];
          final progress = (controller.currentIndex.value + 1) / controller.questions.length;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxHeight < 600;
              final isVerySmallScreen = constraints.maxHeight < 500;
              
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress Section
                      _buildProgressSection(progress, isSmallScreen),
                      SizedBox(height: isVerySmallScreen ? 16.h : 24.h),
                      
                      // Question Card
                      _buildQuestionCard(q, isSmallScreen, isVerySmallScreen),
                      SizedBox(height: isVerySmallScreen ? 16.h : 24.h),
                      
                      // Options Buttons
                      _buildOptions(q, isSmallScreen, isVerySmallScreen),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildProgressSection(double progress, bool isSmallScreen) {
    return Column(
      children: [
        // Progress Bar
        Container(
          height: isSmallScreen ? 10.h : 12.h,
          decoration: BoxDecoration(
            color: const Color(0xFF37817D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Stack(
            children: [
              // Progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(Get.context!).size.width * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5D9C99),
                      const Color(0xFF37817D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isSmallScreen ? 8.h : 12.h),
        
        // Question Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Progress Text
            Text(
              '${((progress) * 100).toInt()}%',
              style: TextStyle(
                fontSize: isSmallScreen ? 12.sp : 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF37817D),
              ),
            ),
            
            // Question Number
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12.w : 16.w,
                vertical: isSmallScreen ? 4.h : 6.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8B134).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color(0xFFF8B134).withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              child: Text(
                'السؤال ${controller.currentIndex.value + 1} من ${controller.questions.length}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF082726),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Question q, bool isSmallScreen, bool isVerySmallScreen) {
    return Container(
      height: isVerySmallScreen ? 180.h : (isSmallScreen ? 220.h : 260.h),
      padding: EdgeInsets.all(isSmallScreen ? 16.w : 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5D9C99).withOpacity(0.1),
            const Color(0xFFF8B134).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF37817D).withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question Icon - Conditionally show based on screen size
          if (!isVerySmallScreen) ...[
            Container(
              width: isSmallScreen ? 50.w : 60.w,
              height: isSmallScreen ? 50.h : 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFF5D9C99),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: isSmallScreen ? 1.5.w : 2.w,
                ),
              ),
              child: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: isSmallScreen ? 24.sp : 28.sp,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12.h : 16.h),
          ],
          
          // Question Text
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                q.question,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 14.sp : (isSmallScreen ? 16.sp : 18.sp),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF082726),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Hint Text
          if (!isVerySmallScreen) ...[
            SizedBox(height: 8.h),
            Text(
              'اختر الإجابة الصحيحة',
              style: TextStyle(
                fontSize: isSmallScreen ? 12.sp : 13.sp,
                color: const Color(0xFF37817D),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptions(Question q, bool isSmallScreen, bool isVerySmallScreen) {
    return Column(
      children: [
        for (int index = 0; index < q.options.length; index++)
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF37817D).withOpacity(0.1),
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => controller.checkAnswer(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF082726),
                padding: EdgeInsets.symmetric(
                  vertical: isVerySmallScreen ? 12.h : (isSmallScreen ? 14.h : 16.h),
                  horizontal: 16.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
                side: BorderSide(
                  color: const Color(0xFF5D9C99).withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Option Letter
                  Container(
                    width: isVerySmallScreen ? 26.w : (isSmallScreen ? 28.w : 30.w),
                    height: isVerySmallScreen ? 26.h : (isSmallScreen ? 28.h : 30.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8B134).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8B134),
                        width: 1.2.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index), // A, B, C, D
                        style: TextStyle(
                          fontSize: isVerySmallScreen ? 12.sp : 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082726),
                        ),
                      ),
                    ),
                  ),
                  
                  // Option Text
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        q.options[index],
                        style: TextStyle(
                          fontSize: isVerySmallScreen ? 13.sp : (isSmallScreen ? 14.sp : 15.sp),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF082726),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  
                  // Invisible spacer for balance
                  SizedBox(
                    width: isVerySmallScreen ? 26.w : (isSmallScreen ? 28.w : 30.w),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}