// profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/Screens/profile_menu.dart';
import 'package:slp/controller/auth_controller.dart';
import 'package:slp/controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

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
          'الملف الشخصي',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D9C99), // Teal Green
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            SizedBox(height: 30.h),

            // Profile Header Section
            _buildProfileHeader(),
            SizedBox(height: 30.h),

            // Menu Items Section
            _buildMenuItems(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Obx(() {
            final localImage = profileController.localImagePath.value;
            return GestureDetector(
              onTap: () {
                profileController.pickImageFromGallery();
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: const Color(
                      0xFF5D9C99,
                    ).withOpacity(0.2), // Teal Green light
                    backgroundImage: localImage != null
                        ? FileImage(File(localImage))
                        : null,
                    child: localImage == null
                        ? Icon(
                            Icons.person,
                            size: 50.sp,
                            color: const Color(0xFF5D9C99), // Teal Green
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8B134), // Mustard Yellow
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF082726).withOpacity(0.3),
                            blurRadius: 4.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 18.sp,
                        color: const Color(0xFF082726), // Dark Border
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 16.h),

          // User Name
          Obx(
            () => Text(
              authController.currentUser.value?.name ?? 'مستخدم',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF082726), // Dark Border
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // User Email
          Obx(
            () => Text(
              authController.currentUser.value?.email ?? '',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF37817D), // Darker Teal
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.2),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.description,
            title: 'الشروط والأحكام',
            iconColor: const Color(0xFF5D9C99), // Teal Green
            onTap: () {
              Get.toNamed('/terms');
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.privacy_tip,
            title: 'سياسة الخصوصية',
            iconColor: const Color(0xFF5D9C99), // Teal Green
            onTap: () {
              Get.toNamed('/privacy');
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.share,
            title: 'مشاركة التطبيق',
            iconColor: const Color(0xFF5D9C99), // Teal Green
            onTap: () {
              profileController.shareApp();
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.star_rate,
            title: 'التقييم والملاحظات',
            iconColor: const Color(0xFF5D9C99), // Teal Green
            onTap: () {
              profileController.openRating();
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.info,
            title: 'حول التطبيق',
            iconColor: const Color(0xFF5D9C99), // Teal Green
            onTap: () {
              Get.toNamed('/about');
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.system_update,
            title: 'الإصدار',
            iconColor: const Color(0xFF5D9C99), // Teal Green
            trailing: Obx(
              () => Text(
                profileController.appInfo.value?.version ?? '1.0.0',
                style: TextStyle(
                  color: const Color(0xFF37817D), // Darker Teal
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: () {},
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            iconColor: Colors.red,
            onTap: () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  title: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF082726), // Dark Border
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF37817D), // Darker Teal
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFF5D9C99), // Teal Green
                                width: 1.5.w,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF5D9C99), // Teal Green
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade400,
                                  Colors.red.shade600,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                Get.back();
                                authController.logout();
                              },
                              child: Text(
                                'تسجيل الخروج',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.delete_forever,
            title: 'حذف الحساب',
            iconColor: Colors.red.shade700,
            onTap: () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  title: Text(
                    'حذف الحساب',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF082726),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    'هل أنت متأكد أنك تريد حذف الحساب نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF37817D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFF5D9C99),
                                width: 1.5.w,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF5D9C99),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade400,
                                  Colors.red.shade600,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () async {
                                Get.back();

                                try {
                                  // Try deleting from Firebase Auth
                                  final user = authController.auth.currentUser;
                                  if (user != null) {
                                    await user.delete();
                                    Get.snackbar(
                                      'تم الحذف بنجاح',
                                      'تم حذف الحساب بنجاح.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.shade50,
                                      colorText: Colors.green.shade700,
                                    );
                                    await authController.logout();
                                  }
                                } catch (e) {
                                  // Handle errors like requires-recent-login
                                  await authController.logout();
                                  Get.snackbar(
                                    'فشل حذف الحساب',
                                    'يرجى تسجيل الدخول مرة أخرى ثم المحاولة مجددًا.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.shade50,
                                    colorText: Colors.red.shade700,
                                  );
                                }
                              },
                              child: Text(
                                'حذف الحساب',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
