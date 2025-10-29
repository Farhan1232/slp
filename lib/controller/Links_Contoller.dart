
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LinksController extends GetxController {
  // Each map contains a title (Arabic) and the Google Drive link
  final RxList<Map<String, String>> buttons = <Map<String, String>>[
    {
      'title': 'ما هي أسباب التأخر اللغوي',
      'link': 'https://drive.google.com/file/d/1CX7uUp8siqInEPGbdzNH-FzPKyc5puij/view?usp=sharing'
    },
    {
      'title': 'ما هو دور اختصاصي النطق واللغة',
      'link': 'https://drive.google.com/file/d/1TKE6D_PUKGxqXO9EUwzkcsagYi2AH_g-/view?usp=sharing'
    },
    {
      'title': 'ما هي الفحوصات الواجب اجراءها قبل تقييم النطق واللغة',
      'link': 'https://drive.google.com/file/d/19wslevigLlyKZ5fpiOMByU2jK6ebD93V/view?usp=sharing'
    },
    {
      'title': 'والدي تكلم بعمر الخمس سنوات، وطفلي غير ناطق حتى الآن، هل أنتظر حتى عمر الخمس سنوات ؟',
      'link': 'https://drive.google.com/file/d/1Y1qPfpLfGmhamvnzVMXV-K5qQWJExhSr/view?usp=sharing'
    },
    {
      'title': 'كيف أسحب الأجهزة اللوحية من طفلي حيث أنه مدمن على استخدامها؟',
      'link': 'https://drive.google.com/file/d/13N5naFpJwNe2OejYbR8O540lNHrHUmxp/view?usp=sharing'
    },
    {
      'title': 'عمر طفلي 10 سنوات، وهو غير ناطق، كيف أتواصل معه؟',
      'link': 'https://drive.google.com/file/d/1wqHodshv6zeBgNulsqVP1CQjpOAm9kDW/view?usp=sharing'
    },
  ].obs;
}
