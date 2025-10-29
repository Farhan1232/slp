import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800), // Standard mobile design size
    );

    const String paragraph1 =
        "تم بناء وتطوير هذا التطبيق بواسطة اختصاصية نطق ولغة ذات خبرة تزيد عن عشر سنوات في مجال علاج اضطرابات النطق واللغة.";
    const String paragraph2 =
        "يهدف التطبيق إلى زيادة وعي أولياء الأمور والمعلمين وغيرهم ممن يتعاملون مع الأطفال الذين لديهم اضطرابات في النطق واللغة، حول كيفية التعامل معهم وفهم طبيعة مشكلاتهم اللغوية والنطقية.";
    const String contact =
        "slpworldapp@gmail.com";

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE), // White background
      appBar: AppBar(
        title: Text(
          'عن التطبيق',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Directionality(
          textDirection: TextDirection.rtl, // Ensures Arabic alignment
          child: Column(
            children: [
              // Header Section
              _buildHeaderSection(),
              SizedBox(height: 30.h),
              
              // Content Section
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildParagraph(paragraph1),
                      SizedBox(height: 20.h),
                      _buildParagraph(paragraph2),
                      SizedBox(height: 40.h),
                      
                      // Contact Section
                      _buildContactSection(contact),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134), // Mustard Yellow
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
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
              color: const Color(0xFF082726), // Dark Border
              size: 35.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات عن التطبيق',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'تعرف على المزيد حول تطبيق النطق واللغة',
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

  Widget _buildParagraph(String text) {
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
          // Paragraph Icon
          Container(
            width: 30.w,
            height: 30.h,
            margin: EdgeInsets.only(left: 12.w, top: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFF5D9C99), // Teal Green
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
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.7,
                color: const Color(0xFF082726), // Dark Border
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(String contact) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'للتواصل',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF082726), // Dark Border
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFF8B134).withOpacity(0.3), // Mustard Yellow
                width: 1.5.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Email Icon
                Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8B134).withOpacity(0.1), // Mustard Yellow light
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8B134), // Mustard Yellow
                      width: 1.5.w,
                    ),
                  ),
                  child: Icon(
                    Icons.email,
                    color: const Color(0xFFF8B134), // Mustard Yellow
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'البريد الإلكتروني',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF37817D), // Darker Teal
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        contact,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082726), // Dark Border
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'نحن هنا لمساعدتك في أي استفسار',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF37817D), // Darker Teal
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}