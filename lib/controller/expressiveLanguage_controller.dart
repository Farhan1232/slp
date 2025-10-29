import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

/// ---------- Controller ----------
class ExpressiveLanguageController extends GetxController {
  final List<Map<String, String>> exercises = [
    {
      'title': 'أن يسمي الطفل المجسمات عند عرضها أمامه ( اضغط لمعرفة كيفية تقديم الهدف للطفل)',
      'url': 'https://drive.google.com/file/d/1WgLixTh28Aw_UmVCv3ru48Hw3LSyf_Ep/view?usp=sharing',
    },
    {
      'title': 'أن يسمي الطفل المهن المختلفة ( اضغط لمعرفة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1WgLixTh28Aw_UmVCv3ru48Hw3LSyf_Ep/view?usp=sharing',
    },
    {
      'title': 'أن يسمي الطفل أجزاء الوجه ( اضغط لمعرفة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1OqwRBJM6FhkBOLuqYrJQVpPnrc2O_EI1/view?usp=sharing',
    },
    {
      'title': 'أن يجيب الطفل على صيغ الاسئلة المختلفة ( اضغط لمعرفة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1ei1eW94rRXV_T3b2lnqA5b9KSeX6kTjC/view?usp=sharing',
    },
    {
      'title': 'أن يسمي الطفل ظروف المكان ( اضغط لمعرفة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1kd3XhGSiu4jMOMM1CNhrQk4FG0tSyKuD/view?usp=sharing',
    },
    {
      'title': 'أن يقلد الطفل الأصوات البيئية ( اضغط لمعرفة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1E27HmXMvTXxq4Zl4YufBrFCVvgSBHOAM/view?usp=sharing',
    },
  ];

  /// Open video in browser
  Future<void> openVideo(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('خطأ', 'تعذر فتح الرابط');
    }
  }
}
