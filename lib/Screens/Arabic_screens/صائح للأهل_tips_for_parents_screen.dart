import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TipsForParentsScreen extends StatelessWidget {
  const TipsForParentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800), // Standard mobile design size
    );

    final List<String> tips = [
      "احرص على تحدثك بشكل واضح يوميا مع طفلك",
      "استخدم طول جملة مناسب لمستوى طفلك اللغوي",
      "اعمل على اثراء لغة طفلك في البيئات المختلفة (المنزل - السيارة - الشارع)",
      "دع الطفل يشاركك في النشاطات اليومية مثل الطبخ، ري النباتات، وغيرها",
      "في حال وجود تأخر لغوي يجب عليك أولا عمل فحص السمع وذلك للتأكد من سلامة عتبة السمع وعدم وجود ضعف سمع، وكذلك يجب الفحص للتأكد من عدم وجود سوائل خلف الطبلة والتي بدورها تؤدي إلى ضعف سمع توصيلي مؤقت",
      "إذا كان صوت طفلك غير مناسب لعمره ولجنسه فعليك مراجعة طبيب الأنف والأذن والحنجرة لعمل التنظير ومن ثم مراجعة اختصاصي النطق إذا استدعى الأمر بعد تبيّن الأسباب",
      "لا تقوم بالضغط على طفلك في حال وجود تأتأة في كلامه، ولا تطلب منه أن يأخذ نفسا قبل الكلام، وذلك لتجنب حدوث السلوكات المترافقة مع التأتأة لاحقا",
      "في حال وجود شد أو ارتخاء في عضلات النطق لدى طفلك، قم بإجراء التمارين المناسبة بناءً على توصية اختصاصي النطق واللغة",
      "التدريب المنزلي يعتبر عامل أساسي في تقدم الطفل لغويا",
      "خذ النصائح من المختص في المجال ولا تستمع للنصائح العشوائية المقدمة من غير المختصين",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE), // White background
      appBar: AppBar(
        title: Text(
          'نصائح للأهل',
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
            
            // Tips List
            _buildTipsList(tips),
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
              Icons.family_restroom,
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
                  'نصائح قيمة للأهل',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'إرشادات عملية لمساعدة طفلك في تطوير مهارات النطق واللغة',
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

  Widget _buildTipsList(List<String> tips) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: tips.length,
        itemBuilder: (context, index) {
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
                      const Color(0xFF5D9C99).withOpacity(0.05),
                      const Color(0xFFF8B134).withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF5D9C99).withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  leading: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8B134).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8B134),
                        width: 1.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082726),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    tips[index],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF082726),
                    ),
                  ),
                  trailing: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D9C99),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF082726),
                        width: 1.5.w,
                      ),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: Colors.white,
                      size: 18.sp,
                    ),
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