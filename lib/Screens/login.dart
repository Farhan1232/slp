import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slp/Screens/screen_widget_button.dart';
import 'package:slp/controller/auth_controller.dart';

import 'package:slp/widget/button_widget.dart';
import 'package:slp/widget/textfield.dart';


class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final LanguageController languageController = Get.put(LanguageController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  String tr(String key) {
    return languageController.getTranslation(
      key,
      languageController.loginScreenLanguage.value,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: formKey,
            child: Obx(() {
              // Force rebuild when language changes
              final _ = languageController.loginScreenLanguage.value;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ScreenLanguageButton(
                      currentLanguage: languageController.loginScreenLanguage.value,
                      onLanguageChange: (lang) {
                        languageController.changeLoginLanguage(lang);
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildTopSection(),
                  SizedBox(height: 40.h),
                  _buildWelcomeText(),
                  SizedBox(height: 30.h),
                  _buildFormFields(),
                  SizedBox(height: 30.h),
                  _buildLoginButton(),
                  SizedBox(height: 30.h),
                  _buildSignUpSection(),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFF5D9C99),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.face,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8B134),
                borderRadius: BorderRadius.circular(40.r),
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.face,
                color: const Color(0xFF082726),
                size: 40.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Container(
          width: 120.w,
          height: 40.h,
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
              tr('hello_exclamation'),
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

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('welcome_back'),
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF082726),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          tr('login_to_continue'),
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF37817D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        Container(
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
        ),
        SizedBox(height: 20.h),
        Container(
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
          child: Obx(() => CustomTextField(
                controller: passwordController,
                hintText: tr('enter_password'),
                labelText: tr('password'),
                prefixIcon: Icons.lock_outline,
                obscureText: !authController.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF37817D),
                  ),
                  onPressed: authController.togglePasswordVisibility,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('password_required');
                  }
                  if (value.length < 6) {
                    return tr('password_min_length');
                  }
                  return null;
                },
              )),
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Get.toNamed('/forgot-password');
            },
            child: Text(
              tr('forgot_password'),
              style: TextStyle(
                color: const Color(0xFF37817D),
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
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
            text: tr('login'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                authController.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              }
            },
            isLoading: authController.isLoading.value,
          ),
        ));
  }

  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr("no_account"),
          style: TextStyle(
            color: const Color(0xFF37817D),
            fontSize: 14.sp,
          ),
        ),
        Container(
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
              Get.toNamed('/signup');
            },
            child: Text(
              tr('create_account'),
              style: TextStyle(
                color: const Color(0xFF082726),
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}