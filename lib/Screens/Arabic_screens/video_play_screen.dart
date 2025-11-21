import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    
    final args = Get.arguments;
    final videoUrl = args['videoUrl'] ?? '';
    
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });
    
    _controller.addListener(() {
      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
    );

    final args = Get.arguments;
    final title = args['title'] ?? 'تشغيل الفيديو';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D9C99),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_controller),
                      
                      // Controls Overlay
                      if (_showControls)
                        Container(
                          color: Colors.black26,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top gradient
                              Container(
                                height: 80.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black54,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Center play/pause button
                              Center(
                                child: Container(
                                  width: 70.w,
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5D9C99).withOpacity(0.8),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 10.r,
                                        offset: Offset(0, 4.h),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    iconSize: 40.sp,
                                    icon: Icon(
                                      _isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                ),
                              ),
                              
                              // Bottom controls
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black87,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Progress bar
                                    VideoProgressIndicator(
                                      _controller,
                                      allowScrubbing: true,
                                      colors: VideoProgressColors(
                                        playedColor: const Color(0xFF5D9C99),
                                        bufferedColor: Colors.grey,
                                        backgroundColor: Colors.white24,
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                    ),
                                    
                                    // Time and controls
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Current time / Total time
                                        Text(
                                          '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        
                                        // Additional controls
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.replay_10,
                                                color: Colors.white,
                                                size: 24.sp,
                                              ),
                                              onPressed: () {
                                                final currentPosition = _controller.value.position;
                                                final newPosition = currentPosition - const Duration(seconds: 10);
                                                _controller.seekTo(
                                                  newPosition < Duration.zero ? Duration.zero : newPosition,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.forward_10,
                                                color: Colors.white,
                                                size: 24.sp,
                                              ),
                                              onPressed: () {
                                                final currentPosition = _controller.value.position;
                                                final duration = _controller.value.duration;
                                                final newPosition = currentPosition + const Duration(seconds: 10);
                                                _controller.seekTo(
                                                  newPosition > duration ? duration : newPosition,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
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
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'حدث خطأ في تحميل الفيديو',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D9C99),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('رجوع'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: const Color(0xFF5D9C99),
                    strokeWidth: 3.w,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'جاري تحميل الفيديو...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}