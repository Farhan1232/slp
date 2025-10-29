import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  final String privacyText = """
نحن في تطبيق عالم النطق واللغة نولي أهمية قصوى لخصوصيتك. ُصمم هذا التطبيق بهدف مساعدة الأطفال على تطوير مهارات النطق واللغة دون أي قلق بشأن جمع البيانات الشخصية.

البيانات التي يتم جمعها من المستخدمين:
يؤكد هذا التطبيق التزامنا الكامل بحماية خصوصيتك. ولكن نحتاج إلى جمع معلومات مثل البريد الإلكتروني المسجل حتى تتمكن من تسجيل الدخول إلى التطبيق. بعد تسجيل الدخول يمكن للبرنامج العمل دون الحاجة إلى الاتصال بالانترنت، ولكن قد تحتاج إلى تفعيل هذا الاتصال في حال الانتقال إلى روابط خارجية.

هذه السياسة سارية المفعول من تاريخ إطلاق التطبيق. إذا كان لديك أي أسئلة، فلا تتردد في التواصل معنا عبر البريد:
slpworldapp@gmail.com
""";

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
          "سياسة الخصوصية",
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(),
            SizedBox(height: 20.h),
            
            // Privacy Content
            _buildPrivacyContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
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
        children: [
          // Decorative Icon
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134), // Mustard Yellow
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.privacy_tip,
              color: const Color(0xFF082726), // Dark Border
              size: 30.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سياسة الخصوصية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'حماية بياناتك وخصوصيتك هي أولويتنا الأساسية',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF37817D), // Darker Teal
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

  Widget _buildPrivacyContent() {
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: const Color(0xFF5D9C99),
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'التزامنا بحماية خصوصيتك',
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
                      'نحن ملتزمون بحماية بياناتك الشخصية وضمان خصوصيتك في كل خطوة',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF37817D),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // Privacy Text
              Text(
                privacyText,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.8,
                  color: const Color(0xFF082726),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.right,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.email,
                          color: const Color(0xFFF8B134),
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'بيانات التواصل',
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
                      'slpworldapp@gmail.com',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D9C99),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'للاستفسارات حول الخصوصية وحماية البيانات',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF37817D),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
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
                      'آخر تحديث: ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
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
      ),
    );
  }
}