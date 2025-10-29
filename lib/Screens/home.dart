import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.fitness_center, 'label': 'تمارين منزلية', 'route': '/exercises'},
    {'icon': Icons.book, 'label': 'تعريفات ', 'route': '/definitions'},
    {'icon': Icons.family_restroom, 'label': 'نصائح للأهل', 'route': '/tips'},
    {'icon': Icons.question_answer, 'label': 'أسئلة وأجوبة ', 'route': '/questions'},
    {'icon': Icons.picture_as_pdf, 'label': 'مواد  مجانية PDF', 'route': '/free_materials'},
    {'icon': Icons.quiz, 'label': 'اختبار ', 'route': '/quiz'},
    {'icon': Icons.info, 'label': 'نبذة عن التطبيق ', 'route': '/about'},
    {'icon': Icons.question_answer, 'label': 'أسئلة عن التطبيق', 'route': '/faq'},
  ];

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
          'مرحباً بك',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // 🖼️ Image Slider with decorative elements
            _buildImageSlider(),
            SizedBox(height: 30.h),

            // 🧱 Grid Menu
            _buildGridMenu(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Stack(
      children: [
        // Main Image Slider
        Obx(() => Container(
              height: 180.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  image: AssetImage(
                      controller.sliderImages[controller.currentIndex.value]),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF37817D).withOpacity(0.3),
                    blurRadius: 15.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF082726), // Dark Border
                  width: 2.w,
                ),
              ),
            )),
        
        // Decorative faces
        Positioned(
          top: 10.h,
          left: 30.w,
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134), // Mustard Yellow
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.face,
              color: const Color(0xFF082726),
              size: 25.sp,
            ),
          ),
        ),
        
        Positioned(
          bottom: 10.h,
          right: 30.w,
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFF5D9C99), // Teal Green
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.face,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridMenu() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15.h,
          crossAxisSpacing: 15.w,
          childAspectRatio: 1.1, // Slightly adjusted for better text display
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () => Get.toNamed(item['route']),
            child: Container(
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
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF37817D).withOpacity(0.1),
                    blurRadius: 8.r,
                    offset: Offset(2.w, 2.h),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF5D9C99).withOpacity(0.3), // Teal Green border
                  width: 1.5.w,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D9C99), // Teal Green
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF082726), // Dark Border
                        width: 2.w,
                      ),
                    ),
                    child: Icon(
                      item['icon'],
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF082726), // Dark Border
                        height: 1.3,
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