import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher.dart';

/// ---------- Controller ----------
class ReceptiveLanguageController extends GetxController {
  final List<Map<String, String>> exercises = [
    {
      'title': 'أن يتبع التعليمات اللفظية البسيطة ( اضغط لمشاهدة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1KwyMFrRBKZ_j9ve-uAYg3VSri5XUTM3c/view?usp=sharing',
    },
    {
      'title': 'أن يتعرف على العناصر عند ذكر وظيفتها ( اضغط لمشاهدة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1PIKJ4W2mEQvUFkuN4CBXSms9C6xIZHrz/view?usp=sharing',
    },
    {
      'title': 'أن يتعرف على الصور التي تمثل الأفعال ( اضغط لمشاهدة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1JUE1s_PcklC_FqtyDTxFOJIfGYBr61g1/view?usp=sharing',
    },
    {
      'title': 'أن يتعرف الطفل على المشاعر ( اضغط لمشاهدة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1SCW_DvnF63Njik3r8ieJc3I1Snjl-y4E/view?usp=sharing',
    },
    {
      'title': 'أن يتعرف الطفل على أجزاء الوجه ( اضغط لمعرفة كيفية تقديم الهدف)',
      'url': 'https://drive.google.com/file/d/1YW4INSB3Q3X47QM-JduYXcxRTVFvSpWq/view',
    },
    {
      'title': 'أن يتعرف الطفل إلى ظروف المكان ( اضغط لمعرفة كيفية تقديم الهدف )',
      'url': 'https://drive.google.com/file/d/1ujPi8Fbik9AhR38BNpMJMGDzbXTFSLiU/view?usp=sharing',
    },
  ];

  /// open video in browser
  Future<void> openVideo(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('خطأ', 'تعذر فتح الرابط');
    }
  }
}