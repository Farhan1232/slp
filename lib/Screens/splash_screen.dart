import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  void _navigateUser() async {
    // Wait 3 seconds for splash animation
    await Future.delayed(const Duration(seconds: 3));

    // Use AuthController to check login status
    if (authController.isLoggedIn()) {
      Get.offAllNamed('/main'); // Navigate to MainScreen
    } else {
      Get.offAllNamed('/login'); // Navigate to LoginScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              _buildTopDecorations(),
              SizedBox(height: 40.h),
              Expanded(child: _buildMainContent()),
              _buildLoadingSection(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopDecorations() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _decorativeFace(70, 70, const Color(0xFFF8B134), Icons.face),
          _decorativeFace(60, 60, const Color(0xFF5D9C99), Icons.face, isWhite: true),
        ],
      ),
    );
  }

  Widget _decorativeFace(double width, double height, Color color, IconData icon, {bool isWhite = false}) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width / 2),
        border: Border.all(color: const Color(0xFF082726), width: 2.w),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10.r, offset: Offset(0, 4.h)),
        ],
      ),
      child: Icon(icon, color: isWhite ? Colors.white : const Color(0xFF082726), size: (width / 2).sp),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App logo
        Container(
          width: 200.w,
          height: 200.h,
          decoration: BoxDecoration(
            color: const Color(0xFF5D9C99).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF5D9C99).withOpacity(0.3), width: 2.w),
            boxShadow: [BoxShadow(color: const Color(0xFF37817D).withOpacity(0.2), blurRadius: 20.r, offset: Offset(0, 8.h))],
          ),
          child: Center(
            child: Icon(Icons.hearing, color: const Color(0xFF5D9C99), size: 80.sp),
          ),
        ),
        SizedBox(height: 30.h),
        Text('تطبيق النطق واللغة', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: const Color(0xFF082726))),
        SizedBox(height: 8.h),
        Text('دعم وتطوير مهارات التواصل', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color(0xFF37817D))),
        SizedBox(height: 20.h),
        _speechBubble('مرحباً بك!'),
      ],
    );
  }

  Widget _speechBubble(String text) {
    return Container(
      width: 150.w,
      height: 45.h,
      decoration: BoxDecoration(
        color: const Color(0xFF5D9C99),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r), bottomLeft: Radius.circular(20.r)),
        border: Border.all(color: const Color(0xFF082726), width: 2.w),
        boxShadow: [BoxShadow(color: const Color(0xFF37817D).withOpacity(0.3), blurRadius: 8.r, offset: Offset(0, 4.h))],
      ),
      child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF8B134).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF8B134), width: 2.w),
          ),
          child: Center(
            child: SizedBox(
              width: 25.w,
              height: 25.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation(const Color(0xFFF8B134)),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text('جاري التحميل...', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF37817D), fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        Text('نعدّل الإعدادات من أجلك', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF5D9C99), fontStyle: FontStyle.italic)),
      ],
    );
  }
}


