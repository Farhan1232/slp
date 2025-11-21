import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenLanguageButton extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChange;

  const ScreenLanguageButton({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF082726),
          width: 2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption('English', 'en'),
          Container(
            width: 2.w,
            height: 20.h,
            color: const Color(0xFF082726).withOpacity(0.2),
          ),
          _buildLanguageOption('العربية', 'ar'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String label, String langCode) {
    final isSelected = currentLanguage == langCode;
    
    return GestureDetector(
      onTap: () => onLanguageChange(langCode),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D9C99) : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF082726),
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}