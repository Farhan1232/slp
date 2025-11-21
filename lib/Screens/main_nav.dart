import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slp/Screens/home.dart';
import 'package:slp/Screens/profile.dart';
import 'package:slp/Screens/quiz/quiz_result_screen.dart';
import 'package:slp/controller/auth_controller.dart';


class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final RxInt currentIndex = 0.obs;
  final LanguageController languageController = Get.find<LanguageController>();

  final List<Widget> screens = [
    HomeScreen(),
    ResultScreen(),
    ProfileScreen(),
  ];

  String tr(String key) {
    return languageController.getMainAppTranslation(key);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Force rebuild when language changes
      final _ = languageController.mainAppLanguage.value;
      
      return Scaffold(
        body: screens[currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex.value,
          onTap: (index) {
            currentIndex.value = index;
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF5D9C99),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: tr('home_tab'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.score),
              activeIcon: const Icon(Icons.score),
              label: tr('result_tab'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.settings),
              label: tr('setting'),
            ),
          ],
        ),
      );
    });
  }
}