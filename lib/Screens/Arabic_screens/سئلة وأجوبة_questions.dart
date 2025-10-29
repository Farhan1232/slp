// main.dart
// Flutter app using GetX. Shows 6 Arabic buttons that open Google Drive video links in the default browser.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/Links_Contoller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class questionscreen extends StatelessWidget {
  final LinksController controller = Get.put(LinksController());

  questionscreen({Key? key}) : super(key: key);

  Future<void> _openLink(String url) async {
    try {
      final canOpen = await canLaunchUrlString(url);
      if (canOpen) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('خطأ', 'لا يمكن فتح الرابط');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء محاولة فتح الرابط');
    }
  }

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
          'أسئلة وأجوبة',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              // Header Section
              _buildHeaderSection(),
              SizedBox(height: 16.h),
              
              // Grid View
              Expanded(
                child: _buildGridView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5D9C99).withOpacity(0.1), // Teal Green light
            const Color(0xFFF8B134).withOpacity(0.05), // Mustard Yellow light
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
      child: Row(
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
              Icons.live_help,
              color: const Color(0xFF082726), // Dark Border
              size: 25.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فيديوهات الأسئلة الشائعة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'مجموعة من الفيديوهات التعليمية تجيب على أكثر الأسئلة شيوعاً',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF37817D), // Darker Teal
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Obx(() {
      final items = controller.buttons;
      
      // Calculate responsive cross axis count based on screen width
      final crossAxisCount = MediaQuery.of(Get.context!).size.width > 600 ? 3 : 2;
      
      return GridView.builder(
        padding: EdgeInsets.only(bottom: 16.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: _calculateAspectRatio(), // Dynamic aspect ratio
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildGridItem(item, index);
        },
      );
    });
  }

  double _calculateAspectRatio() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final screenHeight = MediaQuery.of(Get.context!).size.height;
    
    // Adjust aspect ratio based on screen size
    if (screenWidth > 600) {
      return 0.8; // Tablet/landscape
    } else if (screenHeight < 600) {
      return 0.7; // Small phones
    } else {
      return 0.75; // Normal phones
    }
  }

  Widget _buildGridItem(Map<String, String> item, int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => _openLink(item['link']!),
          child: Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF37817D).withOpacity(0.15),
                  blurRadius: 8.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
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
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF5D9C99).withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Number Badge
                    Container(
                      width: 30.w,
                      height: 30.h,
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
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF082726),
                          ),
                        ),
                      ),
                    ),
                    
                    // Play Icon
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D9C99),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF082726),
                          width: 1.5.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5D9C99).withOpacity(0.3),
                            blurRadius: 4.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    
                    // Title - Using Flexible to prevent overflow
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _calculateTitleFontSize(constraints.maxWidth),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF082726),
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    
                    // Hint Text
                    Text(
                      'انقر للمشاهدة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF37817D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateTitleFontSize(double maxWidth) {
    if (maxWidth < 100) {
      return 10.sp;
    } else if (maxWidth < 120) {
      return 11.sp;
    } else {
      return 12.sp;
    }
  }
}