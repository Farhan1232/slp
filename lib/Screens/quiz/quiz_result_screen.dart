import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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
        title: Text(
          'النتيجة',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Obx(() {
          final score = controller.score.value;
          final totalQuestions = controller.questions.length;
          final percentage = (score / totalQuestions * 100).toInt();
          
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

  Widget _buildResultCard(int score, int totalQuestions, int percentage) {
    return Container(
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
            'نتيجتك:',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF082726), // Dark Border
            ),
          ),
          SizedBox(height: 10.h),
          
          // Score Display
          Text(
            '$score / $totalQuestions',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildScoreHistory() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'سجل الدرجات السابقة:',
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
              child: Obx(() => ListView.builder(
                itemCount: controller.scoreHistory.length,
                itemBuilder: (context, index) {
                  final attemptScore = controller.scoreHistory[index];
                  final attemptPercentage = (attemptScore / controller.questions.length * 100).toInt();
                  
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
                        'محاولة ${index + 1}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF082726), // Dark Border
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: _getScoreColor(attemptPercentage).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: _getScoreColor(attemptPercentage),
                            width: 1.w,
                          ),
                        ),
                        child: Text(
                          '$attemptScore / ${controller.questions.length}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(attemptPercentage),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton() {
    return Container(
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
          Get.to(() => QuizScreen());
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
          'إعادة المحاولة',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
    if (percentage >= 80) return 'أداء ممتاز! أحسنت العمل 🌟';
    if (percentage >= 60) return 'أداء جيد، استمر في التقدم 💪';
    if (percentage >= 40) return 'ليس سيئاً، يمكنك التحسن 📈';
    return 'حاول مرة أخرى، يمكنك فعل أفضل 🔄';
  }
}