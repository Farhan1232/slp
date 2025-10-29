import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefinitionsScreen extends StatelessWidget {
  const DefinitionsScreen({super.key});

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
          'تعريفات',
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
            
            // Definitions List
            _buildDefinitionsList(),
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
              Icons.menu_book,
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
                  'الموسوعة التعريفية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'مجموعة من التعريفات الأساسية المعتمدة لدى اختصاصيي النطق واللغة',
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

  Widget _buildDefinitionsList() {
    final definitions = [
      {
        'title': 'التأخر اللغوي',
        'definition': 'هو حالة يتأخر فيها الطفل عن المعدل الطبيعي في اكتساب وتطور مهارات اللغة (سواء الاستقبالية أو التعبيرية) مقارنة بأقرانه بنفس العمر، وله عدة مظاهر وأسباب مختلفة.',
      },
      {
        'title': 'الأبراكسيا الكلامية',
        'definition': 'هي اضطراب عصبي في البرمجة الحركية للكلام. سببه ليس ضعف بالعضلات وإنما خلل في التخطيط وتنظيم الحركات اللازمة لإنتاج الكلام.',
      },
      {
        'title': 'عسر التلفظ (Dysarthria)',
        'definition': 'هو اضطراب عصبي في تنفيذ الحركات بسبب ضعف أو شلل في العضلات.',
      },
      {
        'title': 'الأفيزيا',
        'definition': 'هي اضطراب لغوي عصبي ينتج عن إصابة الدماغ، غالباً في المناطق المسؤولة عن اللغة، وتؤثر على قدرة الشخص على فهم اللغة، التحدث، القراءة أو الكتابة، وذلك بحسب مكان الإصابة.',
      },
      {
        'title': 'التأتأة',
        'definition': 'هي اضطراب في طلاقة الكلام، يظهر عندما يواجه الشخص صعوبة في انسيابية الحديث، ويتمثل في التكرار للأصوات أو الكلمات، الإطالة، أو توقفات وانحباس الكلام.',
      },
      {
        'title': 'اضطراب مخارج الأصوات',
        'definition': 'هو صعوبة في نطق بعض الأصوات بالشكل الصحيح.',
      },
      {
        'title': 'اضطراب فونولوجي',
        'definition': 'هي أخطاء نمطية في استخدام الأصوات تؤثر على وضوح الكلام.',
      },
      {
        'title': 'اضطرابات الصوت',
        'definition': 'هي مشكلات تؤثر على جودة الصوت أو نبرته أو شدته أو مدته بحيث لا تتناسب مع عمر الشخص أو جنسه أو حالته التواصلية.',
      },
      {
        'title': 'اضطرابات التواصل الاجتماعي',
        'definition': 'هي صعوبة في استخدام اللغة في المواقف الاجتماعية.',
      },
      {
        'title': 'المهارات ما قبل اللغوية',
        'definition': 'هي مجموعة من القدرات التي يطورها الطفل قبل أن يبدأ باستخدام الكلمات والجمل، وتشكل الأساس الضروري لاكتساب اللغة والتواصل. هذه المهارات تظهر عادة في السنة الأولى والثانية من العمر.',
      },
      {
        'title': 'صعوبات البلع',
        'definition': 'هي اضطراب في عملية البلع ينتج عن خلل في حركة وتنسيق عضلات الفم والبلعوم والمرئ عند تناول الطعام أو الشراب، مما يؤدي إلى صعوبة في نقلهم بأمان وكفاءة من الفم إلى المعدة.',
      },
      {
        'title': 'اللغة التعبيرية',
        'definition': 'هي إحدى مكونات مهارة اللغة، وتشير إلى قدرة الفرد على استخدام اللغة للتعبير عن أفكاره ومشاعره واحتياجاته، سواء أكان ذلك بالكلام أو الكتابة أو الإيماءات أو حتى باستخدام وسائل بديلة للتواصل.',
      },
      {
        'title': 'اللغة الاستقبالية',
        'definition': 'تعرف بأنها إحدى مكونات مهارة اللغة، وتشير إلى قدرة الفرد على استقبال وفهم المعلومات اللغوية من الآخرين، سواءً أكانت منطوقة أو مكتوبة دون الحاجة بالضرورة إلى إنتاج الكلام نفسه.',
      },
    ];

    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: definitions.length,
        itemBuilder: (context, index) {
          final definition = definitions[index];
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
                child: ExpansionTile(
                  collapsedIconColor: const Color(0xFF5D9C99),
                  iconColor: const Color(0xFFF8B134),
                  tilePadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
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
                    definition['title']!,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF082726),
                    ),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D9C99).withOpacity(0.05),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: const Color(0xFF37817D).withOpacity(0.2),
                            width: 1.w,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Definition Icon
                          Container(
                            width: 24.w,
                            height: 24.h,
                            margin: EdgeInsets.only(left: 8.w, top: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF37817D),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              definition['definition']!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.6,
                                color: const Color(0xFF082726),
                              ),
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
        },
      ),
    );
  }
}