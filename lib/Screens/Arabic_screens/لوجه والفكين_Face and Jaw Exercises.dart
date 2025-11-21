import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaceAndJawScreen extends StatefulWidget {
  const FaceAndJawScreen({super.key});

  @override
  State<FaceAndJawScreen> createState() => _FaceAndJawScreenState();
}

class _FaceAndJawScreenState extends State<FaceAndJawScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = false;
  String? _error;
  String _selectedLanguage = 'english'; // Default language

  // Teal Green Color
  final Color _tealGreen = const Color(0xFF5D9C99);

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final docName = _selectedLanguage == 'arabic'
          ? 'arabic_oral_motor_main'
          : 'english_oral_motor_main';

      final doc = await _firestore.collection('content').doc(docName).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['items'] != null) {
          final items = data['items'] as List;
          setState(() {
            _exercises =
                items.map((item) => item as Map<String, dynamic>).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'No exercises found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Document not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading exercises: $e';
        _isLoading = false;
      });
    }
  }

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _selectedLanguage == 'arabic';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isArabic ? 'تمارين الوجه والفكين' : 'Oral Motor Exercise',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _tealGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchExercises,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Language Selector Buttons
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _LanguageButton(
                    label: 'العربية',
                    isSelected: _selectedLanguage == 'arabic',
                    onTap: () => _changeLanguage('arabic'),
                    tealGreen: _tealGreen,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _LanguageButton(
                    label: 'English',
                    isSelected: _selectedLanguage == 'english',
                    onTap: () => _changeLanguage('english'),
                    tealGreen: _tealGreen,
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(_tealGreen),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          isArabic ? 'جاري التحميل...' : 'Loading exercises...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            ElevatedButton.icon(
                              onPressed: _fetchExercises,
                              icon: const Icon(Icons.refresh),
                              label: Text(
                                isArabic ? 'إعادة المحاولة' : 'Retry',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _tealGreen,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _exercises.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  isArabic
                                      ? 'لا توجد تمارين'
                                      : 'No exercises available',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchExercises,
                            color: _tealGreen,
                            child: ListView.builder(
                              padding: EdgeInsets.all(16.w),
                              itemCount: _exercises.length,
                              itemBuilder: (context, index) {
                                final exercise = _exercises[index];
                                return _ExerciseCard(
                                  exercise: exercise,
                                  index: index,
                                  isArabic: isArabic,
                                  tealGreen: _tealGreen,
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color tealGreen;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.tealGreen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? tealGreen : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? tealGreen : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: tealGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final int index;
  final bool isArabic;
  final Color tealGreen;

  const _ExerciseCard({
    required this.exercise,
    required this.index,
    required this.isArabic,
    required this.tealGreen,
  });

  @override
  Widget build(BuildContext context) {
    final description = exercise['description'] ?? 'No description';
    final imageUrl = exercise['imageUrl'];
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: () {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            _showImageDialog(context, imageUrl, description);
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tealGreen.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: screenWidth > 600
                ? _buildWideLayout(imageUrl, description)
                : _buildNarrowLayout(imageUrl, description),
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(String? imageUrl, String description) {
    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberBadge(),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                description,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (imageUrl != null && imageUrl.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  Icons.zoom_in,
                  color: tealGreen.withOpacity(0.7),
                  size: 20.sp,
                ),
              ),
          ],
        ),
        if (imageUrl != null && imageUrl.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _buildImage(imageUrl),
        ],
      ],
    );
  }

  Widget _buildWideLayout(String? imageUrl, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberBadge(),
        SizedBox(width: 16.w),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: isArabic
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                description,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (imageUrl != null && imageUrl.isNotEmpty) ...[
          SizedBox(width: 16.w),
          Expanded(
            flex: 1,
            child: _buildImage(imageUrl),
          ),
        ],
      ],
    );
  }

  Widget _buildNumberBadge() {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: tealGreen,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: tealGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.network(
        imageUrl,
        height: 200.h,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(tealGreen),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: 48.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Image not available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showImageDialog(
      BuildContext context, String imageUrl, String description) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16.r),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 300.h,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(tealGreen),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: Colors.white, size: 32.sp),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}