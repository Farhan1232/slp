import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/Screens/screen_widget_button.dart';
import 'package:slp/controller/auth_controller.dart';

import 'package:slp/widget/button_widget.dart';
import 'package:slp/widget/textfield.dart';


class ForgetPasswordScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final LanguageController languageController = Get.find<LanguageController>();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgetPasswordScreen({Key? key}) : super(key: key);

  String tr(String key) {
    return languageController.getTranslation(
      key,
      languageController.forgotPasswordScreenLanguage.value,
    );
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF082726),
            size: 24.sp,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          child: Form(
            key: formKey,
            child: Obx(() {
              // Force rebuild when language changes
              final _ = languageController.forgotPasswordScreenLanguage.value;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ScreenLanguageButton(
                      currentLanguage: languageController.forgotPasswordScreenLanguage.value,
                      onLanguageChange: (lang) {
                        languageController.changeForgotPasswordLanguage(lang);
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildTopSection(),
                  SizedBox(height: 30.h),
                  _buildHeaderText(),
                  SizedBox(height: 50.h),
                  _buildEmailField(),
                  SizedBox(height: 40.h),
                  _buildResetButton(),
                  SizedBox(height: 30.h),
                  _buildBackToLogin(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFF5D9C99),
                borderRadius: BorderRadius.circular(35.r),
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 35.sp,
              ),
            ),
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8B134),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.mail_outline,
                color: const Color(0xFF082726),
                size: 30.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Container(
          width: 180.w,
          height: 45.h,
          decoration: BoxDecoration(
            color: const Color(0xFF5D9C99),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
            border: Border.all(
              color: const Color(0xFF082726),
              width: 2.w,
            ),
          ),
          child: Center(
            child: Text(
              tr('need_help'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('forgot_password_header'),
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF082726),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          tr('reset_password_instruction'),
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF37817D),
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: CustomTextField(
        controller: emailController,
        hintText: tr('enter_your_email'),
        labelText: tr('email'),
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return tr('email_required');
          }
          if (!GetUtils.isEmail(value)) {
            return tr('valid_email_required');
          }
          return null;
        },
      ),
    );
  }

 Widget _buildResetButton() {
  return Obx(() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF37817D).withOpacity(0.3),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: CustomButton(
          text: tr('send_reset_link'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              authController.resetPassword(
                emailController.text.trim(),
                lang: languageController.forgotPasswordScreenLanguage.value, // ADD THIS
              );
            }
          },
          isLoading: authController.isLoading.value,
        ),
      ));
}

  Widget _buildBackToLogin() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFF8B134),
              width: 2.w,
            ),
          ),
        ),
        child: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            tr('back_to_login'),
            style: TextStyle(
              color: const Color(0xFF082726),
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}