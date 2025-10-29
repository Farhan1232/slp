import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800), // Standard mobile design size
    );

    final faqs = [
      {
        'question': 'ما هي أهداف تطبيق النطق واللغة؟',
        'answer':
            'يهدف التطبيق إلى دعم الأهالي والأخصائيين في تطوير مهارات اللغة والتواصل لدى الأطفال من خلال تدريبات منزلية منظمة.'
      },
      {
        'question': 'هل يغني التطبيق عن جلسات أخصائي النطق واللغة؟',
        'answer':
            'لا، التطبيق يُستخدم كمساعد فقط، بينما تبقى الجلسات مع الأخصائي ضرورية لتقييم الحالة ووضع خطة مناسبة.'
      },
      {
        'question': 'كيف أستخدم التدريبات المنزلية بشكل فعال؟',
        'answer':
            'يُفضل تطبيق التمارين بانتظام لمدة قصيرة يومياً (10-15 دقيقة) ومراقبة تقدم الطفل دون ضغط أو توتر.'
      },
      {
        'question': 'هل يمكن حفظ تقدّم طفلي؟',
        'answer':
            'نعم، التطبيق يقوم بحفظ البيانات والنتائج في التخزين المحلي بحيث يمكنك مراجعتها لاحقاً.'
      },
      {
        'question': 'هل يمكنني تعديل صورة الملف الشخصي؟',
        'answer': 'نعم، يمكنك تغيير الصورة من صفحة الملف الشخصي واختيار صورة جديدة من المعرض.'
      },
      {
        'question': 'كيف أرسل ملاحظاتي أو تقييمي للتطبيق؟',
        'answer':
            'يمكنك إرسال رأيك أو تقييمك من خلال صفحة "التقييم والتغذية الراجعة" في القائمة الجانبية.'
      },
      {
        'question': 'هل يعمل التطبيق بدون اتصال بالإنترنت؟',
        'answer': 'نعم، معظم الخصائص الأساسية تعمل بدون اتصال بالإنترنت، مثل التدريبات المنزلية والنتائج.'
      },
      {
        'question': 'كيف يمكنني استعادة بياناتي إذا حذفت التطبيق؟',
        'answer':
            'البيانات تحفظ محليًا، لذا يُنصح بعدم حذف التطبيق للحفاظ على سجلك التدريبي.'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE), // White background
      appBar: AppBar(
        title: Text(
          'الأسئلة الشائعة',
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
      body: Column(
        children: [
          // Decorative header section
          _buildHeaderSection(),
          SizedBox(height: 10.h),
          
          // FAQ List
          Expanded(
            child: ListView.builder(
              itemCount: faqs.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return _buildFaqItem(faq, index, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8B134).withOpacity(0.1), // Mustard Yellow light
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF8B134).withOpacity(0.3), // Mustard Yellow
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          // Decorative icon
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
              Icons.help_outline,
              color: const Color(0xFF082726),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أسئلة متكررة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'إجابات على الأسئلة الأكثر شيوعاً حول التطبيق',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF37817D), // Darker Teal
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(Map<String, String> faq, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
        shadowColor: const Color(0xFF37817D).withOpacity(0.2), // Darker Teal shadow
        child: ExpansionTile(
          collapsedIconColor: const Color(0xFF5D9C99), // Teal Green
          iconColor: const Color(0xFFF8B134), // Mustard Yellow when expanded
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          leading: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFF5D9C99), // Teal Green
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 1.5.w,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            faq['question']!,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF082726), // Dark Border
              height: 1.4,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF5D9C99).withOpacity(0.05), // Teal Green light
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF37817D).withOpacity(0.2), // Darker Teal
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Answer icon
                  Container(
                    width: 24.w,
                    height: 24.h,
                    margin: EdgeInsets.only(left: 8.w, top: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF37817D), // Darker Teal
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      faq['answer']!,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.6,
                        color: const Color(0xFF082726), // Dark Border
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}