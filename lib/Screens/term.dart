import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  final String termsText = """
1. مقدمة
مرحبًا بكم في تطبيق عالم النطق واللغة.
باستخدام هذا التطبيق، فإنك توافق على الالتزام بالشروط والأحكام التالية.
يرجى قراءة هذه الشروط بعناية قبل استخدام التطبيق. إذا لم توافق على أي جزء منها، يرجى عدم استخدام التطبيق.

2. تعريف التطبيق
تطبيق عالم النطق واللغة يهدف إلى زيادة الوعي باضطرابات النطق واللغة، وخاصة التأخر اللغوي.
يوفر التطبيق مواد تعليمية ومقاطع فيديو وإرشادات تساعد أولياء الأمور والمعلمين في تدريب الأطفال بالشكل الصحيح، مع إمكانية تحميل بعض المواد التدريبية المصممة خصيصًا لهذا الغرض.

3. استخدام التطبيق
• يُسمح باستخدام التطبيق لأغراض تعليمية وتوعوية فقط.
• يمنع التعديل على المواد التعليمية القابلة للتنزيل الموجودة في التطبيق.
• يتحمل المستخدم المسؤولية الكاملة عن أي استخدام غير قانوني أو مخالف لهذه الشروط.
• لا يجوز استخدام التطبيق بطريقة تضر أو تعطل عمله أو تؤثر سلبًا على مستخدمين آخرين.

4. الخصوصية
نحن نحترم خصوصيتك.
قد نقوم بجمع بعض المعلومات الأساسية (مثل البريد الإلكتروني أو الاسم) لغرض تحسين تجربة المستخدم أو التواصل معك.
لن تتم مشاركة بياناتك مع أي طرف ثالث دون موافقتك، إلا في الحالات التي يفرضها القانون.

5. المواد التدريبية والفيديوهات
• المواد المقدمة في التطبيق هي لأغراض تعليمية فقط ولا تُعتبر بديلاً عن استشارة أخصائي نطق معتمد.
• التطبيق لا يتحمل أي مسؤولية عن نتائج استخدام هذه المواد دون إشراف مختص.

6. الاشتراكات والمدفوعات (إن وجدت)
• في حال وجود مواد مدفوعة أو اشتراكات، يتم تحديد الأسعار والشروط داخل التطبيق بشكل واضح.
• لا تُسترد المدفوعات بعد تحميل المواد أو الوصول إلى المحتوى المدفوع، إلا في حال وجود خطأ تقني.

7. التحديثات والتعديلات
قد يتم تعديل هذه الشروط من وقت لآخر دون إشعار مسبق.
يُعتبر استمرارك في استخدام التطبيق بعد نشر التعديلات موافقةً ضمنية على الشروط الجديدة.

8. إخلاء المسؤولية
لا يضمن التطبيق خلو المحتوى من الأخطاء، كما لا يتحمل أي ضرر ناتج عن سوء استخدام المعلومات أو اعتماد المستخدم عليها دون استشارة مختص.

9. التواصل معنا
في حال وجود أي استفسارات أو ملاحظات حول هذه الشروط أو التطبيق، يمكنك التواصل معنا عبر البريد الإلكتروني:
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
          "الشروط والأحكام",
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
            
            // Terms Content
            _buildTermsContent(),
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
              Icons.description,
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
                  'الشروط والأحكام',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'يرجى قراءة الشروط والأحكام بعناية قبل استخدام التطبيق',
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

  Widget _buildTermsContent() {
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
              // Important Note
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: const Color(0xFFF8B134),
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'مهم: باستخدامك للتطبيق فإنك توافق على جميع الشروط والأحكام المذكورة أدناه',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF082726),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // Terms Text
              Text(
                termsText,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.8,
                  color: const Color(0xFF082726),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 20.h),
              
              // Agreement Section
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
                          Icons.check_circle,
                          color: const Color(0xFF5D9C99),
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'موافقة المستخدم',
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
                      'باستمرارك في استخدام التطبيق، فإنك توافق على الالتزام بهذه الشروط والأحكام وأي تعديلات لاحقة عليها',
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
            ],
          ),
        ),
      ),
    );
  }
}