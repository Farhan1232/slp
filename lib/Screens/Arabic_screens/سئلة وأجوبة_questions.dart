import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slp/controller/Links_Contoller.dart';
import 'package:video_player/video_player.dart';

class questionscreen extends StatelessWidget {
  final LinksController controller = Get.put(LinksController());

  questionscreen({Key? key}) : super(key: key);

  Future<void> _showVideo(BuildContext context, String videoUrl, String title, int index) async {
    VideoPlayerController? videoPlayerController;
    
    try {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoPlayerController.initialize();
      
      // Mark video as watched when opened
      controller.markVideoAsWatched(index);

      await Get.dialog(
        WillPopScope(
          onWillPop: () async {
            if (videoPlayerController != null) {
              await videoPlayerController.pause();
              await videoPlayerController.dispose();
            }
            return true;
          },
          child: Dialog(
            insetPadding: EdgeInsets.all(12.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            child: VideoDialogContent(
              videoPlayerController: videoPlayerController,
              title: title,
              language: controller.currentLanguage.value,
            ),
          ),
        ),
      );
      
      // Ensure video is stopped and disposed after dialog closes
      if (videoPlayerController != null && videoPlayerController.value.isInitialized) {
        await videoPlayerController.pause();
        await videoPlayerController.dispose();
      }
    } catch (e) {
      if (videoPlayerController != null) {
        await videoPlayerController.dispose();
      }
      Get.snackbar(
        controller.currentLanguage.value == 'arabic' ? 'خطأ' : 'Error',
        controller.currentLanguage.value == 'arabic' ? 'فشل تحميل الفيديو' : 'Failed to load video',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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
    title: Text(
      'questions_answers'.tr, // <-- use GetX localization key
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
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF5D9C99),
            ),
          );
        }

        // Show error message if any
        if (controller.errorMessage.value.isNotEmpty && controller.videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D9C99),
                  ),
                  child: Text(
                    controller.currentLanguage.value == 'arabic' ? 'إعادة المحاولة' : 'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            color: const Color(0xFF5D9C99),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  _buildLanguageSelector(),
                  SizedBox(height: 12.h),
                  _buildHeaderSection(),
                  SizedBox(height: 16.h),
                  Expanded(child: _buildGridView()),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

Widget _buildLanguageSelector() {
    // Obx is kept for reactive state management
    return Obx(() => Container(
      // Padding and BoxDecoration from the first code's _buildLanguageToggle
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
        // The structure of Row/Expanded/SizedBox is adapted from the first code
        children: [
          Expanded(
            // Uses the updated _buildLanguageButton with second code's logic
            child: _buildLanguageButton(
              'العربية',
              'arabic',
            ),
          ),
          SizedBox(width: 8.w), // Spacing from the first code
          Expanded(
            // Uses the updated _buildLanguageButton with second code's logic
            child: _buildLanguageButton(
              'English',
              'english',
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildLanguageButton(String label, String language) {
    // Logic is kept from the second code
    final isSelected = controller.currentLanguage.value == language;
    return GestureDetector(
      // Logic is kept from the second code
      onTap: () => controller.changeLanguage(language),
      child: Container(
        // Padding and BoxDecoration from the first code's _buildLanguageButton
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
            // TextStyle from the first code's _buildLanguageButton
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
    return Obx(() => Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5D9C99).withOpacity(0.1),
            const Color(0xFFF8B134).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF5D9C99).withOpacity(0.3),
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8B134),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF082726), width: 2.w),
            ),
            child: Icon(Icons.live_help, color: const Color(0xFF082726), size: 25.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.headerTitle.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF082726),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  controller.headerDescription.value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF37817D),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildGridView() {
    final items = controller.videos;
    
    if (items.isEmpty) {
      return Center(
        child: Text(
          controller.currentLanguage.value == 'arabic' 
              ? 'لا توجد فيديوهات متاحة' 
              : 'No videos available',
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF37817D),
          ),
        ),
      );
    }

    final crossAxisCount = MediaQuery.of(Get.context!).size.width > 600 ? 3 : 2;

    return GridView.builder(
      padding: EdgeInsets.only(bottom: 16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridItem(item, index, context);
      },
    );
  }

  Widget _buildGridItem(Map<String, dynamic> item, int index, BuildContext context) {
    final isWatched = item['isWatched'] ?? false;
    final currentLang = controller.currentLanguage.value;
    
    return GestureDetector(
      onTap: () => _showVideo(context, item['videoUrl'] ?? '', item['title'] ?? '', index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF37817D).withOpacity(0.15),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF5D9C99).withOpacity(0.1),
                  const Color(0xFFF8B134).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFF5D9C99).withOpacity(0.2),
                width: 1.w,
              ),
            ),
            padding: EdgeInsets.all(12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 15.r,
                      backgroundColor: const Color(0xFFF8B134).withOpacity(0.1),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: const Color(0xFF082726),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isWatched)
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18.sp,
                      ),
                  ],
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D9C99),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF082726), width: 1.5.w),
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 22.sp),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      item['title'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF082726),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  currentLang == 'arabic' ? 'انقر للمشاهدة' : 'Click to watch',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF37817D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Separate StatefulWidget for video dialog to avoid Obx issues
class VideoDialogContent extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final String title;
  final String language;

  const VideoDialogContent({
    Key? key,
    required this.videoPlayerController,
    required this.title,
    required this.language,
  }) : super(key: key);

  @override
  State<VideoDialogContent> createState() => _VideoDialogContentState();
}

class _VideoDialogContentState extends State<VideoDialogContent> {
  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.play();
    widget.videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.videoPlayerController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF082726),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: AspectRatio(
                aspectRatio: widget.videoPlayerController.value.aspectRatio,
                child: VideoPlayer(widget.videoPlayerController),
              ),
            ),
            SizedBox(height: 12.h),
            // Video progress bar
            VideoProgressIndicator(
              widget.videoPlayerController,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: const Color(0xFF5D9C99),
                bufferedColor: const Color(0xFF5D9C99).withOpacity(0.3),
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    widget.videoPlayerController.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: const Color(0xFF5D9C99),
                    size: 40.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      if (widget.videoPlayerController.value.isPlaying) {
                        widget.videoPlayerController.pause();
                      } else {
                        widget.videoPlayerController.play();
                      }
                    });
                  },
                ),
                SizedBox(width: 20.w),
                IconButton(
                  icon: Icon(
                    Icons.stop_circle_outlined,
                    color: const Color(0xFFF8B134),
                    size: 36.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.videoPlayerController.pause();
                      widget.videoPlayerController.seekTo(Duration.zero);
                    });
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () async {
                await widget.videoPlayerController.pause();
                await widget.videoPlayerController.dispose();
                Get.back();
              },
              child: Text(
                widget.language == 'arabic' ? 'إغلاق' : 'Close',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF5D9C99),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}