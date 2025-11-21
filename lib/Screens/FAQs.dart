import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedLanguage = 'english'; // Default language
  bool _isLoading = true;
  
  Map<String, dynamic>? _headerData;
  List<Map<String, dynamic>> _faqList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch header data
      await _fetchHeaderData();
      
      // Fetch FAQ questions
      await _fetchFaqQuestions();
      
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchHeaderData() async {
    try {
      DocumentSnapshot headerDoc = await _firestore
          .collection('screens_title')
          .doc('App Questions(أسئلة عن التطبيق)')
          .collection(_selectedLanguage)
          .doc('content')
          .get();

      if (headerDoc.exists) {
        setState(() {
          _headerData = headerDoc.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      print('Error fetching header: $e');
    }
  }

  Future<void> _fetchFaqQuestions() async {
    try {
      QuerySnapshot faqSnapshot = await _firestore
          .collection('questions')
          .doc(_selectedLanguage)
          .collection('qa')
          .orderBy('createdAt', descending: false)
          .get();

      List<Map<String, dynamic>> faqs = [];
      for (var doc in faqSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        faqs.add({
          'question': data['question'] ?? '',
          'answer': data['answer'] ?? '',
          'createdAt': data['createdAt'] ?? '',
        });
      }

      setState(() {
        _faqList = faqs;
      });
    } catch (e) {
      print('Error fetching FAQs: $e');
    }
  }

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _fetchData();

    Get.updateLocale(
      language == 'arabic' ? const Locale('ar') : const Locale('en'),
    );
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
      'App_questions'.tr, // <-- use GetX localization key
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF5D9C99),
              ),
            )
          : Column(
              children: [
                // Language Toggle Buttons
                _buildLanguageToggle(),
                
                // Decorative header section
                _buildHeaderSection(),
                SizedBox(height: 10.h),

                // FAQ List
                Expanded(
                  child: _faqList.isEmpty
                      ? Center(
                          child: Text(
                            _selectedLanguage == 'arabic'
                                ? 'لا توجد أسئلة متاحة'
                                : 'No questions available',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFF37817D),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _faqList.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          itemBuilder: (context, index) {
                            final faq = _faqList[index];
                            return _buildFaqItem(faq, index, context);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildLanguageToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(4.w),
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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLanguageButton(
              label: 'العربية',
              isSelected: _selectedLanguage == 'arabic',
              onTap: () => _changeLanguage('arabic'),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildLanguageButton(
              label: 'English',
              isSelected: _selectedLanguage == 'english',
              onTap: () => _changeLanguage('english'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5D9C99)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF082726),
                  width: 1.5.w,
                )
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF37817D),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    if (_headerData == null) {
      return const SizedBox.shrink();
    }

    String title = _headerData!['title'] ?? '';
    String description = _headerData!['description'] ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8B134).withOpacity(0.1), // Mustard Yellow light
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF8B134).withOpacity(0.3), // Mustard Yellow
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          // Decorative icon
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134), // Mustard Yellow
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.help_outline,
              color: const Color(0xFF082726),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: _selectedLanguage == 'arabic'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: _selectedLanguage == 'arabic'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726), // Dark Border
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  textAlign: _selectedLanguage == 'arabic'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF37817D), // Darker Teal
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(
      Map<String, dynamic> faq, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
        shadowColor:
            const Color(0xFF37817D).withOpacity(0.2), // Darker Teal shadow
        child: ExpansionTile(
          collapsedIconColor: const Color(0xFF5D9C99), // Teal Green
          iconColor: const Color(0xFFF8B134), // Mustard Yellow when expanded
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          leading: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFF5D9C99), // Teal Green
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726), // Dark Border
                width: 1.5.w,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            faq['question'] ?? '',
            textAlign: _selectedLanguage == 'arabic'
                ? TextAlign.right
                : TextAlign.left,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF082726), // Dark Border
              height: 1.4,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF5D9C99)
                    .withOpacity(0.05), // Teal Green light
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF37817D)
                        .withOpacity(0.2), // Darker Teal
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Answer icon
                  Container(
                    width: 24.w,
                    height: 24.h,
                    margin: EdgeInsets.only(
                      left: _selectedLanguage == 'english' ? 8.w : 0,
                      right: _selectedLanguage == 'arabic' ? 8.w : 0,
                      top: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF37817D), // Darker Teal
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      faq['answer'] ?? '',
                      textAlign: _selectedLanguage == 'arabic'
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.6,
                        color: const Color(0xFF082726), // Dark Border
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}