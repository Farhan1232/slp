import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FreeMaterialsScreen extends StatefulWidget {
  const FreeMaterialsScreen({super.key});

  @override
  State<FreeMaterialsScreen> createState() => _FreeMaterialsScreenState();
}

class _FreeMaterialsScreenState extends State<FreeMaterialsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedLanguage = 'english'; // Default language
  bool _isLoadingHeader = true;
  bool _isLoadingMaterials = true;
  
  // Header data
  String _headerTitle = '';
  String _headerDescription = '';
  
  // Materials data
  List<Map<String, dynamic>> _materials = [];

  @override
  void initState() {
    super.initState();
    _fetchHeaderData();
    _fetchMaterialsData();
  }

  // Fetch header section data
  Future<void> _fetchHeaderData() async {
    setState(() => _isLoadingHeader = true);
    
    try {
      final docSnapshot = await _firestore
          .collection('screens_title')
          .doc('Free PDF Materials(مواد مجانية PDF)')
          .collection(_selectedLanguage)
          .doc('content')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          _headerTitle = data?['title'] ?? '';
          _headerDescription = data?['description'] ?? '';
          _isLoadingHeader = false;
        });
      }
    } catch (e) {
      print('Error fetching header data: $e');
      setState(() => _isLoadingHeader = false);
    }
  }

  // Fetch materials data
  Future<void> _fetchMaterialsData() async {
    setState(() => _isLoadingMaterials = true);
    
    try {
      final collectionName = _selectedLanguage == 'english' ? 'pdfs_en' : 'pdfs_ar';
      final querySnapshot = await _firestore
          .collection(collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> materials = [];
      
      // Define colors and icons for variety
      final colors = [
        const Color(0xFF5D9C99), // Teal Green
        const Color(0xFFF8B134), // Mustard Yellow
        const Color(0xFF37817D), // Darker Teal
      ];
      
      final icons = [
        Icons.emoji_emotions,
        Icons.directions_run,
        Icons.help_outline,
        Icons.compare_arrows,
        Icons.category,
        Icons.warning_amber,
        Icons.view_agenda,
      ];

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        final doc = querySnapshot.docs[i];
        final data = doc.data();
        
        materials.add({
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'url': data['pdfUrl'] ?? '',
          'createdAt': data['createdAt'] ?? '',
          'icon': icons[i % icons.length],
          'color': colors[i % colors.length],
        });
      }

      setState(() {
        _materials = materials;
        _isLoadingMaterials = false;
      });
    } catch (e) {
      print('Error fetching materials data: $e');
      setState(() => _isLoadingMaterials = false);
    }
  }

  // Switch language
  void _switchLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _fetchHeaderData();
    _fetchMaterialsData();

    Get.updateLocale(
      language == 'english' ? const Locale('en', 'US') : const Locale('ar', 'AR'),
    );
  }

  // Download PDF
  Future<void> _downloadPDF(String url, String title) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedLanguage == 'english' 
              ? 'Downloading...' 
              : 'جاري التحميل...',
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color(0xFF5D9C99),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedLanguage == 'english' 
              ? 'Error downloading file' 
              : 'خطأ في تحميل الملف',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // View PDF in full screen
  Future<void> _viewPDF(String url, String title) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(
          pdfUrl: url,
          title: title,
        ),
      ),
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
    title: Text(
      'free_materials'.tr, // <-- use GetX localization key
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // Language Toggle
            _buildLanguageToggle(),
            SizedBox(height: 16.h),
            
            // Header Section
            _isLoadingHeader 
              ? _buildLoadingHeader()
              : _buildHeaderSection(),
            SizedBox(height: 20.h),
            
            // Materials List
            _isLoadingMaterials
              ? _buildLoadingMaterials()
              : _buildMaterialsList(),
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
              'English',
              'english',
              _selectedLanguage == 'english',
            ),
          ),
          Expanded(
            child: _buildLanguageButton(
              'العربية',
              'arabic',
              _selectedLanguage == 'arabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String label, String value, bool isSelected) {
    return GestureDetector(
      onTap: () => _switchLanguage(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D9C99) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF082726),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.r),
      ),
      height: 120.h,
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF5D9C99),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
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
            blurRadius: 15.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF082726),
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: const Color(0xFF082726),
              size: 30.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: _selectedLanguage == 'english' 
                ? CrossAxisAlignment.start 
                : CrossAxisAlignment.end,
              children: [
                Text(
                  _headerTitle,
                  textAlign: _selectedLanguage == 'english' 
                    ? TextAlign.left 
                    : TextAlign.right,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  _headerDescription,
                  textAlign: _selectedLanguage == 'english' 
                    ? TextAlign.left 
                    : TextAlign.right,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF37817D),
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

  Widget _buildLoadingMaterials() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF5D9C99),
        ),
      ),
    );
  }

  Widget _buildMaterialsList() {
    if (_materials.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            _selectedLanguage == 'english' 
              ? 'No materials available' 
              : 'لا توجد مواد متاحة',
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
        itemCount: _materials.length,
        itemBuilder: (context, index) {
          final material = _materials[index];
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
                      material['color'].withOpacity(0.05),
                      const Color(0xFFF8B134).withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: material['color'].withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: _selectedLanguage == 'english'
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Action Buttons
                          Row(
                            children: [
                              // View Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: material['color'].withOpacity(0.3),
                                      blurRadius: 8.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () => _viewPDF(
                                    material['url'],
                                    material['title'],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: material['color'],
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 10.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Icon(Icons.visibility, size: 18.sp),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              // Download Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: material['color'].withOpacity(0.3),
                                      blurRadius: 8.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () => _downloadPDF(
                                    material['url'],
                                    material['title'],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: material['color'],
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.download, size: 18.sp),
                                      SizedBox(width: 6.w),
                                      Text(
                                        _selectedLanguage == 'english' 
                                          ? 'Download' 
                                          : 'تحميل',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Material Icon
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: material['color'],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF082726),
                                width: 1.5.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: material['color'].withOpacity(0.3),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 3.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              material['icon'],
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      // Material Title
                      Text(
                        material['title'],
                        textAlign: _selectedLanguage == 'english' 
                          ? TextAlign.left 
                          : TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082726),
                        ),
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // Material Description
                      Text(
                        material['description'],
                        textAlign: _selectedLanguage == 'english' 
                          ? TextAlign.left 
                          : TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.6,
                          color: const Color(0xFF082726),
                        ),
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // File Type Indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: material['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: material['color'].withOpacity(0.3),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: material['color'],
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'PDF',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: material['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// PDF Viewer Screen
class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PDFViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
  });

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5D9C99),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_totalPages > 0)
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        
        controller: _pdfViewerController,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          setState(() {
            _totalPages = details.document.pages.count;
          });
        },
        onPageChanged: (PdfPageChangedDetails details) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Zoom In
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () {
              _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25;
            },
            backgroundColor: const Color(0xFF5D9C99),
            child: const Icon(Icons.zoom_in, color: Colors.white),
          ),
          SizedBox(height: 8.h),
          // Zoom Out
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () {
              if (_pdfViewerController.zoomLevel > 1) {
                _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25;
              }
            },
            backgroundColor: const Color(0xFF5D9C99),
            child: const Icon(Icons.zoom_out, color: Colors.white),
          ),
          SizedBox(height: 8.h),
          // Jump to Page
          FloatingActionButton.small(
            heroTag: 'jump_page',
            onPressed: () {
              _showPageJumpDialog();
            },
            backgroundColor: const Color(0xFF5D9C99),
            child: const Icon(Icons.format_list_numbered, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showPageJumpDialog() {
    final TextEditingController pageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Go to Page'),
        content: TextField(
          controller: pageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter page number (1-$_totalPages)',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final page = int.tryParse(pageController.text);
              if (page != null && page > 0 && page <= _totalPages) {
                _pdfViewerController.jumpToPage(page);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D9C99),
            ),
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }
}