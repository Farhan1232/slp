import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TipsForParentsScreen extends StatefulWidget {
  const TipsForParentsScreen({super.key});

  @override
  State<TipsForParentsScreen> createState() => _TipsForParentsScreenState();
}

class _TipsForParentsScreenState extends State<TipsForParentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedLanguage = 'english'; // Default language
  bool isLoading = true;
  
  // Header data
  String headerTitle = '';
  String headerDescription = '';
  
  // Tips list
  List<Map<String, dynamic>> tips = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch header section
      await _fetchHeaderData();
      
      // Fetch tips content
      await _fetchTipsData();
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
      
      // Show error message
      if (mounted) {
        // Use a language-aware message if possible, or fallback
        String errorMessage = selectedLanguage == 'arabic' 
            ? 'خطأ في تحميل البيانات: $e' 
            : 'Error loading data: $e';
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchHeaderData() async {
    try {
      final docSnapshot = await _firestore
          .collection('screens_title')
          .doc('Tips for Parents(نصائح للأهل)')
          .collection(selectedLanguage)
          .doc('content')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          headerTitle = data?['title'] ?? '';
          headerDescription = data?['description'] ?? '';
        });
      } else {
        // Fallback for missing header data
        _setDefaultHeaderData();
      }
    } catch (e) {
      print('Error fetching header data: $e');
      _setDefaultHeaderData();
    }
  }
  
  void _setDefaultHeaderData() {
     setState(() {
      if (selectedLanguage == 'arabic') {
        headerTitle = 'نصائح قيمة للأهل';
        headerDescription = 'إرشادات عملية لمساعدة طفلك في تطوير مهارات النطق واللغة';
      } else {
        headerTitle = 'Valuable Tips for Parents';
        headerDescription = 'Practical guidance to help your child develop speech and language skills';
      }
    });
  }

  Future<void> _fetchTipsData() async {
    try {
      final docSnapshot = await _firestore
          .collection('parent_content')
          .doc(selectedLanguage)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final descriptionsData = data?['descriptions'] as List<dynamic>? ?? [];
        
        // Convert to list of maps and sort by index
        List<Map<String, dynamic>> tipsList = [];
        for (var item in descriptionsData) {
          if (item is Map<String, dynamic>) {
            tipsList.add(item);
          }
        }
        
        // Sort by createdAt or maintain original order
        setState(() {
          tips = tipsList;
        });
      }
    } catch (e) {
      print('Error fetching tips data: $e');
    }
  }

  void _changeLanguage(String language) {
    if (selectedLanguage == language) return; // Prevent unnecessary reload
    
    setState(() {
      selectedLanguage = language;
    });
    
    // Update GetX locale
    Get.updateLocale(
      Locale(language == 'arabic' ? 'ar' : 'en'),
    );
    
    _fetchData();
  }
  

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800), // Standard mobile design size
    );
    
    // *** FIX: Determine Directionality ***
    final isRtl = selectedLanguage == 'arabic';
    final crossAxisAlignment = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;


    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE), // White background
      appBar: AppBar(
        title: Text(
          'tips_for_parents'.tr, // <-- use GetX localization key
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D9C99),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF5D9C99),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                // *** FIX: Use dynamic crossAxisAlignment for the main column ***
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  // Language Toggle Buttons
                  _buildLanguageToggle(),
                  SizedBox(height: 16.h),
                  
                  // Header Section
                  _buildHeaderSection(isRtl, crossAxisAlignment), // Pass directionality
                  SizedBox(height: 20.h),
                  
                  // Tips List
                  _buildTipsList(isRtl), // Pass directionality
                ],
              ),
            ),
    );
  }

Widget _buildLanguageToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF37817D).withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLanguageButton(
              'العربية',
              'arabic',
            ),
          ),
          Container(
            width: 1.w,
            height: 40.h,
            color: const Color(0xFF5D9C99).withOpacity(0.2),
          ),
          Expanded(
            child: _buildLanguageButton(
              'English',
              'english' ,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String label, String language) {
    final isSelected = selectedLanguage == language;
    
    return InkWell(
      onTap: () => _changeLanguage(language),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5D9C99)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF5D9C99),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // *** MODIFIED: Accept directionality flags ***
  Widget _buildHeaderSection(bool isRtl, CrossAxisAlignment crossAxisAlignment) {
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
        // *** FIX: Set text direction to swap icon/text position ***
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Decorative Icon (appears first in LTR, last in RTL)
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
              Icons.family_restroom,
              color: const Color(0xFF082726), // Dark Border
              size: 30.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              // *** FIX: Use dynamic crossAxisAlignment for text alignment ***
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(
                  headerTitle,
                  // *** FIX: Use TextAlign.start for bi-directional support ***
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  headerDescription,
                  // *** FIX: Use TextAlign.start for bi-directional support ***
                  textAlign: TextAlign.start,
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
  
 Widget _buildTipsList(bool isRtl) {
    if (tips.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            selectedLanguage == 'arabic' 
                ? 'لا توجد نصائح متاحة' 
                : 'No tips available',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF37817D),
            ),
          ),
        ),
      );
    }

    // Determine the TextDirection for the Directionality widget
    final textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;

    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          final description = tip['description'] ?? '';
          
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
            child: Directionality( // <--- WRAP ListTile in Directionality
              textDirection: textDirection, // <--- PASS textDirection here
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
                  child: ListTile(
                    // textDirection REMOVED from ListTile
                    horizontalTitleGap: 8.w,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    
                    // Leading (appears on the right in RTL via Directionality)
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
                    
                    // Title (The main text)
                    title: Text(
                      description,
                      // The text alignment (TextAlign.start) will now correctly
                      // respect the Directionality widget wrapped around the ListTile.
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF082726),
                      ),
                    ),
                    
                    // Trailing (appears on the left in RTL via Directionality)
                    trailing: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D9C99),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF082726),
                          width: 1.5.w,
                        ),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}