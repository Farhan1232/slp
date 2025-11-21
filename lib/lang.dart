// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:slp/controller/lang_controller.dart';


// class LanguageSettingsScreen extends StatelessWidget {
//   const LanguageSettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Initialize LanguageController
//     final SampleLanguageController languageController = Get.put(SampleLanguageController());

//     ScreenUtil.init(
//       context,
//       designSize: const Size(360, 800),
//     );

//     return Scaffold(
//       backgroundColor: const Color(0xFFFEFEFE),
//       appBar: AppBar(
//         title: Obx(() => Text(
//           languageController.isArabic ? 'إعدادات اللغة' : 'Language Settings',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20.sp,
//             color: Colors.white,
//           ),
//         )),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF5D9C99),
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20.r),
//             bottomRight: Radius.circular(20.r),
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               _buildHeaderSection(languageController),
//               SizedBox(height: 40.h),
              
//               // Language Selection Cards
//               _buildLanguageCard(
//                 languageController: languageController,
//                 language: 'english',
//                 title: 'English',
//                 subtitle: 'Switch to English',
//                 icon: Icons.language,
//               ),
//               SizedBox(height: 16.h),
              
//               _buildLanguageCard(
//                 languageController: languageController,
//                 language: 'arabic',
//                 title: 'العربية',
//                 subtitle: 'التبديل إلى العربية',
//                 icon: Icons.translate,
//               ),
              
//               SizedBox(height: 40.h),
              
//               // Information Card
//               _buildInfoCard(languageController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(SampleLanguageController controller) {
//     return Obx(() => Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             const Color(0xFF5D9C99).withOpacity(0.1),
//             const Color(0xFFF8B134).withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(
//           color: const Color(0xFF5D9C99).withOpacity(0.3),
//           width: 1.5.w,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF37817D).withOpacity(0.1),
//             blurRadius: 15.r,
//             offset: Offset(0, 6.h),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 60.w,
//             height: 60.h,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8B134),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: const Color(0xFF082726),
//                 width: 2.w,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFFF8B134).withOpacity(0.3),
//                   blurRadius: 8.r,
//                   offset: Offset(0, 4.h),
//                 ),
//               ],
//             ),
//             child: Icon(
//               Icons.g_translate,
//               color: const Color(0xFF082726),
//               size: 30.sp,
//             ),
//           ),
//           SizedBox(width: 16.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   controller.isArabic ? 'اللغة الحالية' : 'Current Language',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: const Color(0xFF37817D),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   controller.currentLanguageDisplay,
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF082726),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ));
//   }

//   Widget _buildLanguageCard({
//     required SampleLanguageController languageController,
//     required String language,
//     required String title,
//     required String subtitle,
//     required IconData icon,
//   }) {
//     return Obx(() {
//       final isSelected = languageController.currentLanguage.value == language;
      
//       return GestureDetector(
//         onTap: () => languageController.changeLanguage(language),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: EdgeInsets.all(20.w),
//           decoration: BoxDecoration(
//             gradient: isSelected
//                 ? LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       const Color(0xFF5D9C99),
//                       const Color(0xFF37817D),
//                     ],
//                   )
//                 : null,
//             color: isSelected ? null : Colors.white,
//             borderRadius: BorderRadius.circular(20.r),
//             border: Border.all(
//               color: isSelected 
//                   ? const Color(0xFF5D9C99) 
//                   : const Color(0xFF5D9C99).withOpacity(0.3),
//               width: isSelected ? 2.w : 1.5.w,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: isSelected 
//                     ? const Color(0xFF5D9C99).withOpacity(0.3)
//                     : const Color(0xFF37817D).withOpacity(0.1),
//                 blurRadius: isSelected ? 15.r : 8.r,
//                 offset: Offset(0, isSelected ? 6.h : 3.h),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // Language Icon
//               Container(
//                 width: 50.w,
//                 height: 50.h,
//                 decoration: BoxDecoration(
//                   color: isSelected 
//                       ? Colors.white.withOpacity(0.2)
//                       : const Color(0xFFF8B134).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isSelected 
//                         ? Colors.white 
//                         : const Color(0xFFF8B134),
//                     width: 2.w,
//                   ),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: isSelected 
//                       ? Colors.white 
//                       : const Color(0xFF082726),
//                   size: 24.sp,
//                 ),
//               ),
//               SizedBox(width: 16.w),
              
//               // Language Text
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                         color: isSelected 
//                             ? Colors.white 
//                             : const Color(0xFF082726),
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: isSelected 
//                             ? Colors.white.withOpacity(0.9)
//                             : const Color(0xFF37817D),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Check Icon (if selected)
//               if (isSelected)
//                 Container(
//                   width: 30.w,
//                   height: 30.h,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.check,
//                     color: const Color(0xFF5D9C99),
//                     size: 20.sp,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildInfoCard(SampleLanguageController controller) {
//     return Obx(() => Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8B134).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(
//           color: const Color(0xFFF8B134).withOpacity(0.3),
//           width: 1.w,
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.info_outline,
//             color: const Color(0xFFF8B134),
//             size: 24.sp,
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Text(
//               controller.isArabic
//                   ? 'سيتم تطبيق اللغة المختارة على جميع شاشات التطبيق بما في ذلك المحتوى المسترجع من قاعدة البيانات'
//                   : 'The selected language will be applied to all app screens including content fetched from the database',
//               style: TextStyle(
//                 fontSize: 13.sp,
//                 color: const Color(0xFF082726),
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }

