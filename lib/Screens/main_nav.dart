
// main_screen.dart (Bottom Navigation)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slp/Screens/home.dart';
import 'package:slp/Screens/profile.dart';
import 'package:slp/Screens/quiz/quiz_result_screen.dart';


class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final RxInt currentIndex = 0.obs;

  final List<Widget> screens = [
    HomeScreen(),
    ResultScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: screens[currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) {
              currentIndex.value = index;
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined),
                activeIcon: Icon(Icons.score),
                label: 'النتيجة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'الملف الشخصي',
              ),
            ],
          ),
        ));
  }
}
