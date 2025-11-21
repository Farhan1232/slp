import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DefinitionsScreen extends StatefulWidget {
  const DefinitionsScreen({super.key});

  @override
  State<DefinitionsScreen> createState() => _DefinitionsScreenState();
}

class _DefinitionsScreenState extends State<DefinitionsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedLanguage = 'english'; // Default language
  bool isLoading = true;

  // Header section data
  Map<String, dynamic>? headerData;
  
  // Definitions list data
  List<Map<String, dynamic>> definitions = [];

  @override
  void initState() {
    super.initState();
    // Initialize GetX locale to default language
    Get.updateLocale(Locale(selectedLanguage == 'arabic' ? 'ar_AR' : 'en_US'));
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Determine the locale for GetX, needed for proper Directionality in the build methods
      final currentLocale = selectedLanguage == 'arabic' ? 'ar_AR' : 'en_US';
      Get.updateLocale(Locale(currentLocale));


      // Fetch header section data
      final headerDoc = await _firestore
          .collection('screens_title')
          .doc('Definitions(تعريفات)')
          .collection(selectedLanguage)
          .doc('content')
          .get();

      if (headerDoc.exists) {
        headerData = headerDoc.data();
      } else {
        headerData = null; // Ensure it's null if not found
      }

      // Fetch definitions content directly from the 'content' array field
      final docSnapshot = await _firestore
          .collection('content')
          .doc(selectedLanguage)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();

        // Ensure 'content' field exists and is a list
        final List<dynamic> contentList = data?['contents'] ?? [];

        definitions = contentList.map((item) {
          return {
            'id': item['id'] ?? '',
            'title': item['title'] ?? '',
            'definition': item['description'] ?? '',
            'createdAt': item['createdAt'] ?? '',
          };
        }).toList();
      } else {
        definitions = [];
      }

    } catch (e) {
      print('Error fetching data: $e');
      definitions = []; // Clear data on error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void switchLanguage(String language) {
    if (selectedLanguage != language) {
      setState(() {
        selectedLanguage = language;
      });
      // Update GetX locale immediately to change Directionality
      Get.updateLocale(Locale(selectedLanguage == 'arabic' ? 'ar_AR' : 'en_US'));
      fetchData();
    }
  }

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
      'definitions'.tr, // <-- use GetX localization key
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
                children: [
                  // Language Toggle Buttons
                  _buildLanguageToggle(),
                  SizedBox(height: 16.h),

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

  Widget _buildLanguageToggle() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF5D9C99).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLanguageButton(
              'العربية',
              'arabic',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildLanguageButton(
              'English',
              'english',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String label, String language) {
    final isSelected = selectedLanguage == language;
    return GestureDetector(
      onTap: () => switchLanguage(language),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5D9C99)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF5D9C99),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    // Determine if the text direction is RTL (Arabic)
    final isRtl = selectedLanguage == 'arabic';
    
    // Determine the main and cross axis alignments based on direction
    final mainAxisAlignment = isRtl ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAxisAlignment = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    // Get default values for when data is missing, ensuring they respect direction
    final defaultTitle = isRtl ? 'الموسوعة التعريفية' : 'The Definitional Encyclopedia';
    final defaultDescription = isRtl 
        ? 'مجموعة من التعريفات الأساسية المعتمدة لدى اختصاصيي النطق واللغة' 
        : 'A set of essential definitions adopted by speech and language specialists';


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
      // Use Row with text direction awareness
      child: Row(
        // Conditionally reverse the Row order for Arabic (RTL)
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
              crossAxisAlignment: crossAxisAlignment, // Adjusted
              children: [
                Text(
                  headerData?['title'] ?? defaultTitle,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left, // Added text alignment
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  headerData?['description'] ?? defaultDescription,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left, // Added text alignment
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
    // Check the current directionality based on the GetX locale.
    // This is the key to ensuring correct alignment (start = LTR-left, RTL-right).
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if (definitions.isEmpty) {
      // Use localization for the "No definitions available" message
      final noDataText = isRtl ? 'لا توجد تعريفات متاحة' : 'No definitions available';
      return Expanded(
        child: Center(
          child: Text(
            noDataText,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF37817D),
            ),
          ),
        ),
      );
    }

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
                    // CHANGED: Use TextAlign.start for bi-directional support
                    textAlign: TextAlign.start,
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
                      // Use a Row that respects the current text direction
                      child: Row(
                        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Definition Icon
                          Container(
                            width: 24.w,
                            height: 24.h,
                            // Adjusted margin based on direction
                            margin: isRtl ? EdgeInsets.only(right: 8.w, top: 2.h) : EdgeInsets.only(right: 8.w, top: 2.h),
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
                              // CHANGED: Use TextAlign.start for bi-directional support
                              textAlign: TextAlign.start,
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