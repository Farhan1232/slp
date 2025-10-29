
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slp/Screens/quiz/quiz_result_screen.dart';

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({required this.question, required this.options, required this.correctIndex});
}

class QuizController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxInt score = 0.obs;

  late SharedPreferences prefs;
  RxList<int> scoreHistory = <int>[].obs;

  final List<Question> questions = [
    Question(
      question: 'أي من التالي يعتبر من سلوكيات التأتأة الثانوية (المترافقة)؟',
      options: [
        'وميض العين السريع',
        'تكرار الكلمات',
        'رفع الصوت بشكل مفرط',
        'تحريك اليد أثناء الكلام',
      ],
      correctIndex: 0,
    ),
    Question(
      question: 'في أي عمر يبدأ الطفل باستخدام كلمات وظيفية ذات معنى؟',
      options: [
        'بعمر السنتين تقريباً',
        'بعمر السنة تقريباً',
        'بعمر 3 سنوات',
        'منذ الولادة',
      ],
      correctIndex: 1,
    ),
    Question(
      question: 'من الطرق المفيدة لتقليل إجهاد الأحبال الصوتية:',
      options: [
        'شرب الماء للترطيب',
        'التحدث بسرعة كبيرة',
        'الصراخ عند الغضب',
        'عدم التوقف بين الجمل',
      ],
      correctIndex: 0,
    ),
    Question(
      question: 'أي نوع من الأفيزيا يتميز بصعوبة في التعبير مع قدرة نسبية على الفهم؟',
      options: [
        'أفيزيا بروكا',
        'أفيزيا عالمية',
        'أفيزيا فيرنيكه',
        'أفيزيا توصيلية',
      ],
      correctIndex: 0,
    ),
  Question(
  question: 'طفل عمره 3 سنوات، لا يكوّن جملاً، ويستخدم فقط 20 كلمة، مع تاريخ عائلي لتأخر الكلام، ما هو التشخيص الأقرب؟',
  options: [
    'تأخر لغوي يحتاج لتقييم مختص',
    'اضطراب مخارج الأصوات',
    'تأخر عقلي',
    'تأتأة',
  ],
  correctIndex: 0,
),

    Question(
      question: 'صح أم خطأ؟ الأطفال الذين لديهم تأخر لغوي دائماً لديهم مستوى ذكاء منخفض:',
      options: [
        'خطأ',
        'صح',
        'يعتمد على الحالة',
        'لا يمكن الجزم',
      ],
      correctIndex: 2,
    ),
  ];

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    } else {
      saveScore();
      Get.off(() => ResultScreen());
    }
  }

  void checkAnswer(int selectedIndex) {
    final correctIndex = questions[currentIndex.value].correctIndex;

    if (selectedIndex == correctIndex) {
      score.value++;
      Get.defaultDialog(
        title: 'إجابة صحيحة ✅',
        middleText: 'أحسنت!',
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            nextQuestion();
          },
          child: Text('التالي'),
        ),
      );
    } else {
      Get.defaultDialog(
        title: 'إجابة خاطئة ❌',
        middleText: 'حاول مرة أخرى!',
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            nextQuestion();
          },
          child: Text('التالي'),
        ),
      );
    }
  }

  Future<void> saveScore() async {
    prefs = await SharedPreferences.getInstance();
    scoreHistory.add(score.value);
    List<String> scoreStrings = scoreHistory.map((e) => e.toString()).toList();
    await prefs.setStringList('scores', scoreStrings);
  }

  Future<void> loadScores() async {
    prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('scores') ?? [];
    scoreHistory.value = scores.map(int.parse).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadScores();
  }
}
