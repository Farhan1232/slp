import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/Screens/quiz/quiz_screen.dart';
import 'package:slp/controller/quiz_controller.dart';

class ResultScreen extends StatelessWidget {
  final QuizController controller = Get.find();

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
        title: Obx(() => Text(
          controller.selectedLanguage.value == 'arabic' ? 'النتيجة' : 'Result',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
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
        actions: [
          // Language Toggle Button
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: _buildLanguageToggle(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Obx(() {
          final score = controller.score.value;
          final totalQuestions = controller.questions.length;
          final percentage = totalQuestions > 0 
              ? (score / totalQuestions * 100).toInt() 
              : 0;
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result Card with decorative elements
              _buildResultCard(score, totalQuestions, percentage),
              SizedBox(height: 30.h),
              
              // Score History Section
              _buildScoreHistory(),
              SizedBox(height: 30.h),
              
              // Retry Button
              _buildRetryButton(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageButton('AR', 'arabic'),
          SizedBox(width: 4.w),
          _buildLanguageButton('EN', 'english'),
        ],
      ),
    ));
  }

  Widget _buildLanguageButton(String label, String language) {
    final isSelected = controller.selectedLanguage.value == language;
    
    return GestureDetector(
      onTap: () {
        controller.changeLanguage(language);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? Color(0xFF5D9C99) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(int score, int totalQuestions, int percentage) {
    return Obx(() => Container(
      padding: EdgeInsets.all(24.w),
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
            color: const Color(0xFF37817D).withOpacity(0.2),
            blurRadius: 15.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // Decorative icon
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: _getScoreColor(percentage),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getScoreColor(percentage).withOpacity(0.3),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Icon(
              _getScoreIcon(percentage),
              color: Colors.white,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 20.h),
          
          // Score Title
          Text(
            controller.selectedLanguage.value == 'arabic' ? 'نتيجتك:' : 'Your Score:',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF082726), // Dark Border
            ),
          ),
          SizedBox(height: 10.h),
          
          // Score Display with Stars
          _buildStarRating(score, totalQuestions),
          SizedBox(height: 8.h),
          
          // Score Numbers (smaller)
          Text(
            '$score / $totalQuestions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5D9C99), // Teal Green
            ),
          ),
          SizedBox(height: 8.h),
          
          // Percentage
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF37817D), // Darker Teal
            ),
          ),
          SizedBox(height: 15.h),
          
          // Performance Message
          Text(
            _getPerformanceMessage(percentage),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF082726), // Dark Border
              height: 1.5,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildScoreHistory() {
    return Expanded(
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.selectedLanguage.value == 'arabic' 
                ? 'سجل الدرجات السابقة:' 
                : 'Previous Scores:',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF082726), // Dark Border
            ),
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: const Color(0xFF5D9C99).withOpacity(0.2),
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
              child: controller.scoreHistory.isEmpty
                  ? Center(
                      child: Text(
                        controller.selectedLanguage.value == 'arabic'
                            ? 'لا توجد محاولات سابقة'
                            : 'No previous attempts',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF082726).withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.scoreHistory.length,
                      itemBuilder: (context, index) {
                        final attemptScore = controller.scoreHistory[index];
                        final totalQuestions = controller.questions.length > 0 
                            ? controller.questions.length 
                            : 1; // Prevent division by zero
                        final attemptPercentage = (attemptScore / totalQuestions * 100).toInt();
                        
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEFEFE), // White background
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFF5D9C99).withOpacity(0.1),
                              width: 1.w,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: _getScoreColor(attemptPercentage).withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getScoreColor(attemptPercentage),
                                  width: 1.5.w,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _getScoreColor(attemptPercentage),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              controller.selectedLanguage.value == 'arabic'
                                  ? 'محاولة ${index + 1}'
                                  : 'Attempt ${index + 1}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF082726), // Dark Border
                              ),
                            ),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Stars for history
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildHistoryStars(attemptScore, totalQuestions),
                                ),
                                SizedBox(height: 4.h),
                                // Score numbers
                                Text(
                                  '$attemptScore / $totalQuestions',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _getScoreColor(attemptPercentage),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildRetryButton() {
    return Obx(() => Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF8B134).withOpacity(0.3), // Mustard Yellow
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          controller.resetQuiz();
          Get.off(() => QuizScreen());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8B134), // Mustard Yellow
          foregroundColor: const Color(0xFF082726), // Dark Border
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
        ),
        child: Text(
          controller.selectedLanguage.value == 'arabic' 
              ? 'إعادة المحاولة' 
              : 'Retry',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }

  Widget _buildStarRating(int score, int totalQuestions) {
    // Calculate number of stars (out of 5)
    int maxStars = 5;
    double starScore = totalQuestions > 0 ? (score / totalQuestions) * maxStars : 0;
    int fullStars = starScore.floor();
    bool hasHalfStar = (starScore - fullStars) >= 0.5;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxStars, (index) {
        if (index < fullStars) {
          // Full star
          return Icon(
            Icons.star,
            color: Color(0xFFF8B134), // Mustard Yellow
            size: 36.sp,
          );
        } else if (index == fullStars && hasHalfStar) {
          // Half star
          return Icon(
            Icons.star_half,
            color: Color(0xFFF8B134),
            size: 36.sp,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            color: Color(0xFFF8B134).withOpacity(0.3),
            size: 36.sp,
          );
        }
      }),
    );
  }

  List<Widget> _buildHistoryStars(int score, int totalQuestions) {
    int maxStars = 5;
    double starScore = totalQuestions > 0 ? (score / totalQuestions) * maxStars : 0;
    int fullStars = starScore.floor();
    bool hasHalfStar = (starScore - fullStars) >= 0.5;
    
    List<Widget> stars = [];
    for (int i = 0; i < maxStars; i++) {
      if (i < fullStars) {
        stars.add(Icon(
          Icons.star,
          color: Color(0xFFF8B134),
          size: 16.sp,
        ));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(Icon(
          Icons.star_half,
          color: Color(0xFFF8B134),
          size: 16.sp,
        ));
      } else {
        stars.add(Icon(
          Icons.star_border,
          color: Color(0xFFF8B134).withOpacity(0.3),
          size: 16.sp,
        ));
      }
    }
    return stars;
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return const Color(0xFF5D9C99); // Teal Green
    if (percentage >= 40) return const Color(0xFFF8B134); // Mustard Yellow
    return Colors.red;
  }

  IconData _getScoreIcon(int percentage) {
    if (percentage >= 80) return Icons.emoji_events;
    if (percentage >= 60) return Icons.thumb_up;
    if (percentage >= 40) return Icons.sentiment_satisfied;
    return Icons.sentiment_dissatisfied;
  }

  String _getPerformanceMessage(int percentage) {
    if (controller.selectedLanguage.value == 'arabic') {
      if (percentage >= 80) return 'أداء ممتاز! أحسنت العمل 🌟';
      if (percentage >= 60) return 'أداء جيد، استمر في التقدم 💪';
      if (percentage >= 40) return 'ليس سيئاً، يمكنك التحسن 📈';
      return 'حاول مرة أخرى، يمكنك فعل أفضل 🔄';
    } else {
      if (percentage >= 80) return 'Excellent performance! Well done 🌟';
      if (percentage >= 60) return 'Good job, keep progressing 💪';
      if (percentage >= 40) return 'Not bad, you can improve 📈';
      return 'Try again, you can do better 🔄';
    }
  }
}