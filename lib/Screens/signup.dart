import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slp/Screens/screen_widget_button.dart';
import 'package:slp/controller/auth_controller.dart';
import 'package:slp/widget/button_widget.dart';
import 'package:slp/widget/textfield.dart';


class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final LanguageController languageController = Get.find<LanguageController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<File?> pickedImage = Rx<File?>(null);

  SignupScreen({Key? key}) : super(key: key);

  String tr(String key) {
    return languageController.getTranslation(
      key,
      languageController.signupScreenLanguage.value,
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage.value = File(image.path);
    }
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
              final _ = languageController.signupScreenLanguage.value;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ScreenLanguageButton(
                      currentLanguage: languageController.signupScreenLanguage.value,
                      onLanguageChange: (lang) {
                        languageController.changeSignupLanguage(lang);
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildTopSection(),
                  SizedBox(height: 30.h),
                  _buildWelcomeText(),
                  SizedBox(height: 20.h),
                  _buildProfilePicturePicker(),
                  SizedBox(height: 20.h),
                  _buildFormFields(),
                  SizedBox(height: 40.h),
                  _buildSignUpButton(),
                  SizedBox(height: 30.h),
                  _buildLoginSection(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicturePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Obx(() => Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5D9C99).withOpacity(0.1),
                border: Border.all(
                  color: const Color(0xFF5D9C99),
                  width: 3.w,
                ),
              ),
              child: pickedImage.value != null
                  ? ClipOval(
                      child: Image.file(
                        pickedImage.value!,
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.camera_alt,
                      color: const Color(0xFF37817D),
                      size: 40.sp,
                    ),
            )),
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
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8B134),
                borderRadius: BorderRadius.circular(35.r),
                border: Border.all(
                  color: const Color(0xFF082726),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.face,
                color: const Color(0xFF082726),
                size: 35.sp,
              ),
            ),
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
          ],
        ),
        SizedBox(height: 20.h),
        Container(
          width: 140.w,
          height: 45.h,
          decoration: BoxDecoration(
            color: const Color(0xFF5D9C99),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
              bottomLeft: Radius.circular(20.r),
            ),
            border: Border.all(
              color: const Color(0xFF082726),
              width: 2.w,
            ),
          ),
          child: Center(
            child: Text(
              tr('join_us'),
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
          tr('create_account_header'),
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF082726),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          tr('register_to_start'),
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
            controller: nameController,
            hintText: tr('enter_your_name'),
            labelText: tr('full_name'),
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return tr('name_required');
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
                controller: confirmPasswordController,
                hintText: tr('confirm_password_hint'),
                labelText: tr('confirm_password'),
                prefixIcon: Icons.lock_outline,
                obscureText: !authController.isConfirmPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isConfirmPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF37817D),
                  ),
                  onPressed: authController.toggleConfirmPasswordVisibility,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('confirm_password_required');
                  }
                  if (value != passwordController.text) {
                    return tr('passwords_do_not_match');
                  }
                  return null;
                },
              )),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
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
            text: tr('register'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                authController.signup(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  nameController.text.trim(),
                  profileImage: pickedImage.value,
                );
              }
            },
            isLoading: authController.isLoading.value,
          ),
        ));
  }

  Widget _buildLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr('have_account'),
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
              Get.back();
            },
            child: Text(
              tr('login'),
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