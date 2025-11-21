import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/Screens/profile_menu.dart';
import 'package:slp/controller/auth_controller.dart';
import 'package:slp/controller/profile_controller.dart';


class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController = Get.put(ProfileController());
  final LanguageController languageController = Get.find<LanguageController>();

  ProfileScreen({Key? key}) : super(key: key);

  String tr(String key) {
    return languageController.getMainAppTranslation(key);
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
            tr('profile_title'),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D9C99),
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
        child: Obx(() {
          final _ = languageController.mainAppLanguage.value;
          
          return Column(
            children: [
              SizedBox(height: 30.h),
              _buildProfileHeader(),
              SizedBox(height: 30.h),
              _buildMenuItems(),
              SizedBox(height: 20.h),
            ],
          );
        }),
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
            const Color(0xFF5D9C99).withOpacity(0.1),
            const Color(0xFFF8B134).withOpacity(0.05),
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
            final profileImageUrl = profileController.profileImageUrl.value;
            
            ImageProvider? imageProvider;
            if (profileImageUrl != null) {
              imageProvider = NetworkImage(profileImageUrl);
            }

            return GestureDetector(
              onTap: () {
                profileController.pickImageFromGallery();
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: const Color(0xFF5D9C99).withOpacity(0.2),
                    backgroundImage: imageProvider,
                    child: profileImageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 50.sp,
                            color: const Color(0xFF5D9C99),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8B134),
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
                        color: const Color(0xFF082726),
                      ),
                    ),
                  ),
                  if (profileController.isLoading.value)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
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
              authController.currentUser.value?.name ?? tr('default_user'),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF082726),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // User Email
          Obx(
            () => Text(
              authController.currentUser.value?.email ?? 'N/A',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF37817D),
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
            title: tr('terms_and_conditions'),
            iconColor: const Color(0xFF5D9C99),
            onTap: () {
              Get.toNamed('/terms');
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.privacy_tip,
            title: tr('privacy_policy'),
            iconColor: const Color(0xFF5D9C99),
            onTap: () {
              Get.toNamed('/privacy');
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.share,
            title: tr('share_app'),
            iconColor: const Color(0xFF5D9C99),
            onTap: () {
              profileController.shareApp(); // Call shareApp method
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.star_rate,
            title: tr('rating_and_feedback'),
            iconColor: const Color(0xFF5D9C99),
            onTap: () {
              profileController.openRating(); // Call openRating method
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.info,
            title: tr('about_app'),
            iconColor: const Color(0xFF5D9C99),
            onTap: () {
              Get.toNamed('/about');
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.system_update,
            title: tr('version'),
            iconColor: const Color(0xFF5D9C99),
            trailing: Obx(
              () => Text(
                profileController.appInfo.value?.version ?? '1.0.0',
                style: TextStyle(
                  color: const Color(0xFF37817D),
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
            title: tr('logout'),
            iconColor: Colors.red,
            onTap: () {
              _showLogoutDialog();
            },
          ),
          Divider(height: 1.h, color: Colors.grey.shade200),
          ProfileMenuItem(
            icon: Icons.delete_forever,
            title: tr('delete_account'),
            iconColor: Colors.red.shade700,
            onTap: () {
              _showDeleteDialog();
            },
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          tr('logout'),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF082726),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          tr('confirm_logout'),
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
                      tr('cancel'),
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
                    onPressed: () {
                      Get.back();
                      authController.logout();
                    },
                    child: Text(
                      tr('logout'),
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
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          tr('delete_account'),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF082726),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          tr('confirm_delete'),
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
                      tr('cancel'),
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
                        await Future.delayed(const Duration(milliseconds: 500));
                        Get.snackbar(
                          tr('delete_success_title'),
                          tr('delete_success_message'),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade50,
                          colorText: Colors.green.shade700,
                        );
                        await authController.logout();
                      } catch (e) {
                        await authController.logout();
                        Get.snackbar(
                          tr('delete_failure_title'),
                          tr('delete_failure_message'),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade50,
                          colorText: Colors.red.shade700,
                        );
                      }
                    },
                    child: Text(
                      tr('delete_account'),
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
  }
}