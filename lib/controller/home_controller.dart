import 'dart:async';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<String> sliderImages = [
    'assets/images/slider1.jpeg',
    'assets/images/slider2.jpeg',
    'assets/images/slider3.jpeg',
    'assets/images/slider4.jpeg',
  ];

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startAutoSlide();
  }

  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      currentIndex.value =
          (currentIndex.value + 1) % sliderImages.length;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
