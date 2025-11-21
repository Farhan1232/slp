import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slp/Screens/quiz/quiz_result_screen.dart';

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String language;
  final dynamic createdAt;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.language,
    this.createdAt,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Handle correctAnswer - it can be 1-4 or 0-3
    int correctAnswer = 0;
    if (data['correctAnswer'] != null) {
      correctAnswer = data['correctAnswer'] is int 
          ? data['correctAnswer'] as int 
          : int.tryParse(data['correctAnswer'].toString()) ?? 1;
      
      // If correctAnswer is 1-4, convert to 0-3
      if (correctAnswer >= 1 && correctAnswer <= 4) {
        correctAnswer = correctAnswer - 1;
      }
    }
    
    return Question(
      question: data['question'] ?? '',
      options: [
        data['option1'] ?? '',
        data['option2'] ?? '',
        data['option3'] ?? '',
        data['option4'] ?? '',
      ],
      correctIndex: correctAnswer,
      language: data['language'] ?? 'english',
      createdAt: data['createdAt'], // Keep as dynamic, no Timestamp conversion
    );
  }
}

class QuizController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxInt currentIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxList<Question> questions = <Question>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<int> scoreHistory = <int>[].obs;
  
  // Language selection (default: arabic)
  final RxString selectedLanguage = 'english'.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
    loadScoreHistory();
  }

  // Fetch questions from Firebase Firestore
  Future<void> loadQuestions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('Loading questions for language: ${selectedLanguage.value}');
      
      // Fetch questions from Firestore
      // Path: quiz/{language}/questions/{questionDoc}
      QuerySnapshot querySnapshot = await _firestore
          .collection('quiz')
          .doc(selectedLanguage.value) // 'arabic' or 'english'
          .collection('questions')
          .get();

      print('Found ${querySnapshot.docs.length} questions');

      if (querySnapshot.docs.isEmpty) {
        errorMessage.value = selectedLanguage.value == 'arabic' 
            ? 'لا توجد أسئلة متاحة' 
            : 'No questions available';
        isLoading.value = false;
        return;
      }

      // Convert documents to Question objects
      questions.value = querySnapshot.docs
          .map((doc) {
            try {
              return Question.fromFirestore(doc);
            } catch (e) {
              print('Error parsing question ${doc.id}: $e');
              return null;
            }
          })
          .where((q) => q != null)
          .cast<Question>()
          .toList();

      // Sort by createdAt if available
      questions.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        
        int aTime = a.createdAt is Timestamp 
            ? (a.createdAt as Timestamp).millisecondsSinceEpoch 
            : (a.createdAt is int ? a.createdAt as int : 0);
            
        int bTime = b.createdAt is Timestamp 
            ? (b.createdAt as Timestamp).millisecondsSinceEpoch 
            : (b.createdAt is int ? b.createdAt as int : 0);
            
        return aTime.compareTo(bTime);
      });

      print('Successfully loaded ${questions.length} questions');
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = selectedLanguage.value == 'arabic'
          ? 'حدث خطأ أثناء تحميل الأسئلة: $e'
          : 'Error loading questions: $e';
      print('Error loading questions: $e');
      
      // Show error dialog
      Get.snackbar(
        selectedLanguage.value == 'arabic' ? 'خطأ' : 'Error',
        selectedLanguage.value == 'arabic' 
            ? 'فشل تحميل الأسئلة. يرجى المحاولة مرة أخرى.'
            : 'Failed to load questions. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Change language and reload questions
  Future<void> changeLanguage(String language) async {
    if (selectedLanguage.value == language) return;
    
    selectedLanguage.value = language;
    currentIndex.value = 0;
    score.value = 0;
    await loadQuestions();
  }

  // Move to next question
  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    } else {
      saveResultToFirebase();
      Get.off(() => ResultScreen());
    }
  }

  // Check if answer is correct
  void checkAnswer(int selectedIndex) {
    final correctIndex = questions[currentIndex.value].correctIndex;

    if (selectedIndex == correctIndex) {
      score.value++;
      Get.defaultDialog(
        title: selectedLanguage.value == 'arabic' ? 'إجابة صحيحة ✅' : 'Correct Answer ✅',
        middleText: selectedLanguage.value == 'arabic' ? 'أحسنت!' : 'Well done!',
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          color: Color(0xFF5D9C99),
          fontWeight: FontWeight.bold,
        ),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            nextQuestion();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5D9C99),
            foregroundColor: Colors.white,
          ),
          child: Text(selectedLanguage.value == 'arabic' ? 'التالي' : 'Next'),
        ),
      );
    } else {
      Get.defaultDialog(
        title: selectedLanguage.value == 'arabic' ? 'إجابة خاطئة ❌' : 'Wrong Answer ❌',
        middleText: selectedLanguage.value == 'arabic' 
            ? 'الإجابة الصحيحة: ${questions[currentIndex.value].options[correctIndex]}'
            : 'Correct answer: ${questions[currentIndex.value].options[correctIndex]}',
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            nextQuestion();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF8B134),
            foregroundColor: Color(0xFF082726),
          ),
          child: Text(selectedLanguage.value == 'arabic' ? 'التالي' : 'Next'),
        ),
      );
    }
  }

  // Save quiz result to Firebase Firestore
  Future<void> saveResultToFirebase() async {
    try {
      User? user = _auth.currentUser;
      
      if (user == null) {
        // Sign in anonymously if no user
        UserCredential credential = await _auth.signInAnonymously();
        user = credential.user;
        print('Signed in anonymously');
      }

      String userId = user?.uid ?? 'anonymous_${DateTime.now().millisecondsSinceEpoch}';
      
      // Calculate percentage
      int totalQuestions = questions.length;
      double percentage = totalQuestions > 0 ? (score.value / totalQuestions) * 100 : 0;

      // Create result document
      Map<String, dynamic> resultData = {
        'userId': userId,
        'score': score.value,
        'totalQuestions': totalQuestions,
        'percentage': percentage,
        'language': selectedLanguage.value,
        'timestamp': FieldValue.serverTimestamp(),
        'completedAt': DateTime.now().toIso8601String(),
      };

      // Save to Firestore: results/{userId}/quizResults/{resultDoc}
      await _firestore
          .collection('results')
          .doc(userId)
          .collection('quizResults')
          .add(resultData);

      // Update score history
      scoreHistory.add(score.value);

      print('Result saved successfully!');
    } catch (e) {
      print('Error saving result: $e');
      Get.snackbar(
        selectedLanguage.value == 'arabic' ? 'خطأ' : 'Error',
        selectedLanguage.value == 'arabic' ? 'فشل حفظ النتيجة' : 'Failed to save result',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // Load score history from Firebase
  Future<void> loadScoreHistory() async {
    try {
      User? user = _auth.currentUser;
      
      if (user == null) {
        print('No user logged in. Cannot load score history.');
        return;
      }

      // Fetch user's quiz results
      QuerySnapshot querySnapshot = await _firestore
          .collection('results')
          .doc(user.uid)
          .collection('quizResults')
          .where('language', isEqualTo: selectedLanguage.value)
          .orderBy('timestamp', descending: false)
          .get();

      // Extract scores
      scoreHistory.value = querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['score'] as int)
          .toList();

      print('Loaded ${scoreHistory.length} previous scores');
    } catch (e) {
      print('Error loading score history: $e');
    }
  }

  // Reset quiz
  void resetQuiz() {
    currentIndex.value = 0;
    score.value = 0;
    loadQuestions();
    loadScoreHistory();
  }
}