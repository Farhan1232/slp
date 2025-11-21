import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/auth_controller.dart';
import 'package:slp/controller/home_controller.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());
  final LanguageController languageController = Get.find<LanguageController>();

  String tr(String key) {
    return languageController.getMainAppTranslation(key);
  }

  List<Map<String, dynamic>> get menuItems => [
    {'icon': Icons.fitness_center, 'labelKey': 'home_exercises', 'route': '/exercises'},
    {'icon': Icons.book, 'labelKey': 'definitions', 'route': '/definitions'},
    {'icon': Icons.family_restroom, 'labelKey': 'parent_tips', 'route': '/tips'},
    {'icon': Icons.question_answer, 'labelKey': 'questions_answers', 'route': '/questions'},
    {'icon': Icons.picture_as_pdf, 'labelKey': 'free_pdf_materials', 'route': '/free_materials'},
    {'icon': Icons.quiz, 'labelKey': 'quiz', 'route': '/quiz'},
    {'icon': Icons.info, 'labelKey': 'about_app', 'route': '/about'},
    {'icon': Icons.question_answer, 'labelKey': 'app_questions', 'route': '/faq'},
  ];

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          title: Text(
            'Select Language',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF082726),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, 'English', 'en'),
              SizedBox(height: 10.h),
              _buildLanguageOption(context, 'العربية', 'ar'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String label, String langCode) {
    return Obx(() {
      final isSelected = languageController.mainAppLanguage.value == langCode;
      return GestureDetector(
        onTap: () {
          languageController.changeMainAppLanguage(langCode);
          Navigator.of(context).pop();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5D9C99) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? const Color(0xFF5D9C99) : Colors.grey.shade300,
              width: 1.5.w,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF082726),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        title: Obx(() {
          final _ = languageController.mainAppLanguage.value;
          return Text(
            tr('welcome'),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D9C99),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showLanguageDialog(context),
            icon: Icon(
              Icons.language,
              color: Colors.white,
              size: 26.sp,
            ),
            tooltip: 'Change Language',
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          final _ = languageController.mainAppLanguage.value;
          
          return Column(
            children: [
              SizedBox(height: 20.h),
              _buildImageSlider(),
              SizedBox(height: 30.h),
              _buildGridMenu(),
              SizedBox(height: 20.h),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Stack(
      children: [
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
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
              ),
            )),
        // Positioned(
        //   top: 10.h,
        //   left: 30.w,
        //   child: Container(
        //     width: 50.w,
        //     height: 50.h,
        //     decoration: BoxDecoration(
        //       color: const Color(0xFFF8B134),
        //       borderRadius: BorderRadius.circular(25.r),
        //       border: Border.all(
        //         color: const Color(0xFF082726),
        //         width: 2.w,
        //       ),
        //     ),
        //     child: Icon(
        //       Icons.face,
        //       color: const Color(0xFF082726),
        //       size: 25.sp,
        //     ),
        //   ),
        // ),
        // Positioned(
        //   bottom: 10.h,
        //   right: 30.w,
        //   child: Container(
        //     width: 40.w,
        //     height: 40.h,
        //     decoration: BoxDecoration(
        //       color: const Color(0xFF5D9C99),
        //       borderRadius: BorderRadius.circular(20.r),
        //       border: Border.all(
        //         color: const Color(0xFF082726),
        //         width: 2.w,
        //       ),
        //     ),
        //     child: Icon(
        //       Icons.face,
        //       color: Colors.white,
        //       size: 20.sp,
        //     ),
        //   ),
        // ),
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
          childAspectRatio: 1.1,
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
                    const Color(0xFF5D9C99).withOpacity(0.1),
                    const Color(0xFFF8B134).withOpacity(0.05),
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
                  color: const Color(0xFF5D9C99).withOpacity(0.3),
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
                      color: const Color(0xFF5D9C99),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF082726),
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
                      tr(item['labelKey']),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF082726),
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