import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeMaterialsScreen extends StatelessWidget {
  const FreeMaterialsScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800), // Standard mobile design size
    );

    final materials = [
      {
        'title': 'المشاعر PDF',
        'description': 'يمكن الطفل من التعرف على المشاعر، تقليدها وتسميتها',
        'url': 'https://drive.google.com/uc?export=download&id=1QY6YPzHT47H6VIfQ895WW8OQa5DX7UvC',
        'icon': Icons.emoji_emotions,
        'color': const Color(0xFF5D9C99), // Teal Green
      },
      {
        'title': 'الأفعال PDF',
        'description': 'تحتوي على عدد من الأفعال التي يقوم بها الطفل عادةً في حياته اليومية',
        'url': 'https://drive.google.com/uc?export=download&id=1djq1niV_vBDEJcKd1G4nrPY27oL02Ikq',
        'icon': Icons.directions_run,
        'color': const Color(0xFFF8B134), // Mustard Yellow
      },
      {
        'title': 'أسئلة ماذا',
        'description': 'تحتوي على 9 بطاقات تعليمية تتضمن أسئلة بصيغة "ماذا"، تمكن الطفل من فهم هذه الصيغة، والإجابة عليها',
        'url': 'https://drive.google.com/uc?export=download&id=1g3emqW62isjWTEL_GbZaVqDcJDTwJJPB',
        'icon': Icons.help_outline,
        'color': const Color(0xFF37817D), // Darker Teal
      },
      {
        'title': 'المتضادات',
        'description': 'تحتوي على بطاقات تعليمية تمكن الطفل من فهم المتضادات المختلفة',
        'url': 'https://drive.google.com/uc?export=download&id=1wOKcLORv6cd22h9ww_sjs4jByz5ng39g',
        'icon': Icons.compare_arrows,
        'color': const Color(0xFF5D9C99), // Teal Green
      },
      {
        'title': 'أسماء العناصر',
        'description': 'تتضمن 70 صورة لعناصر فئات مختلفة تتضمن: الخضار والفواكه، الحيوانات، الملابس، المواصلات، الأشكال، الألوان، وغيرها',
        'url': 'https://drive.google.com/uc?export=download&id=1wOKcLORv6cd22h9ww_sjs4jByz5ng39g',
        'icon': Icons.category,
        'color': const Color(0xFFF8B134), // Mustard Yellow
      },
      {
        'title': 'أين الخطأ في الصورة',
        'description': 'تتضمن بطاقات تساعد الطفل في تحديد الخطأ غير المنطقي في صورة معينة',
        'url': 'https://drive.google.com/uc?export=download&id=1wOKcLORv6cd22h9ww_sjs4jByz5ng39g',
        'icon': Icons.warning_amber,
        'color': const Color(0xFF37817D), // Darker Teal
      },
      {
        'title': 'تسلسل الأحداث',
        'description': 'تحتوي على 10 بطاقات تعليمية تتكون كل بطاقة من حدث مكون من 4 خطوات، تحفز الطفل على التعرف على تسلسل الأحداث وكذلك استخدام الجمل للوصف، والتمهيد لسرد الأحداث اليومية',
        'url': 'https://drive.google.com/uc?export=download&id=1wOKcLORv6cd22h9ww_sjs4jByz5ng39g',
        'icon': Icons.view_agenda,
        'color': const Color(0xFF5D9C99), // Teal Green
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE), // White background
      appBar: AppBar(
        title: Text(
          'مواد مجانية',
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(),
            SizedBox(height: 20.h),
            
            // Materials List
            _buildMaterialsList(materials),
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
              Icons.picture_as_pdf,
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
                  'مواد تعليمية مجانية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'مجموعة من الملفات التعليمية المساعدة في تطوير مهارات النطق واللغة',
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

  Widget _buildMaterialsList(List<Map<String, dynamic>> materials) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: materials.length,
        itemBuilder: (context, index) {
          final material = materials[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF37817D).withOpacity(0.1),
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
                      material['color'].withOpacity(0.05),
                      const Color(0xFFF8B134).withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: material['color'].withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Download Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: material['color'].withOpacity(0.3),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _launchURL(material['url']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: material['color'],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.download, size: 18.sp),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'تحميل',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Material Icon
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: material['color'],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF082726),
                                width: 1.5.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: material['color'].withOpacity(0.3),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 3.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              material['icon'],
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      // Material Title
                      Text(
                        material['title'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082726),
                        ),
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // Material Description
                      Text(
                        material['description'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.6,
                          color: const Color(0xFF082726),
                        ),
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // File Type Indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: material['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: material['color'].withOpacity(0.3),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: material['color'],
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'PDF',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: material['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}