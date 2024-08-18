import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/quiz_model.dart';
import 'package:flutter_application_2/models/question_model.dart';
import 'dart:async';

class QuizController extends GetxController {
  final RxList<QuizModel> quizzes = <QuizModel>[].obs;
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final Rx<QuestionModel?> currentQuestion = Rx<QuestionModel?>(null);
  final RxInt selectedAnswer = (-1).obs;
  final RxInt score = 0.obs;
  final RxInt remainingTime = 0.obs;
  final RxList<int> userAnswers = <int>[].obs;
  final RxString errorMessage = ''.obs;
  final RxInt coinsEarned = 0.obs;
  final RxInt totalCoins = 0.obs;
  final RxInt streak = 0.obs;
  final RxString emoji = ''.obs;
  final RxBool isLifelineUsed = false.obs;
  final RxString lifelineExplanation = ''.obs;
  final RxBool isAnswerSubmitted = false.obs;
  final RxBool isLastAnswerCorrect = false.obs;
  final RxBool isLifelineAvailable = true.obs;



  final RxList<QuizModel> allQuizzes = <QuizModel>[].obs;
  final RxList<QuizModel> attemptedQuizzes = <QuizModel>[].obs;
  final RxList<QuizModel> completedQuizzes = <QuizModel>[].obs;



  final UserController userController = Get.find<UserController>();

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchQuizzes() async {
    try {
      isLoading(true);
      errorMessage('');
      if (userController.user.value != null) {
        print('Fetching quizzes for user: ${userController.user.value!.id}');
        final fetchedQuizzes = await ApiService.fetchQuizzes(userController.user.value!.id);
        print('Fetched ${fetchedQuizzes.length} quizzes');
        allQuizzes.assignAll(fetchedQuizzes);
        completedQuizzes.assignAll(fetchedQuizzes.where((quiz) => quiz.completed));
        print('Assigned ${allQuizzes.length} quizzes, ${completedQuizzes.length} completed');
      } else {
        print('User is null');
        errorMessage('User not found');
      }
    } catch (e) {
      print('Error in fetchQuizzes: $e');
      errorMessage('Failed to fetch quizzes: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> startQuiz(String quizId) async {
  try {
    isLoading(true);
    final quiz = getQuizById(quizId);
    if (quiz == null) {
      Get.snackbar('Error', 'Quiz not found');
      return;
    }
    
    final fetchedQuestions = await ApiService.fetchQuestions(quizId);
    if (fetchedQuestions.isEmpty) {
      Get.snackbar('No Questions', 'This quiz has no questions yet.');
      return;
    }
    
    questions.assignAll(fetchedQuestions);
    currentQuestionIndex.value = 0;
    currentQuestion.value = questions.isNotEmpty ? questions[0] : null;
    score.value = 0;
    userAnswers.clear();
    
    if (currentQuestion.value != null) {
      startTimer();
    } else {
      Get.snackbar('Error', 'Failed to load the first question');
    }
  } catch (e) {
    print('Error in startQuiz: $e');
    Get.snackbar('Error', 'Failed to start quiz: ${e.toString()}');
  } finally {
    isLoading(false);
  }
}

  QuizModel? getQuizById(String id) {
    try {
      return allQuizzes.firstWhere((quiz) => quiz.id.toString() == id);
    } catch (e) {
      print('Quiz with id $id not found');
      return null;
    }
  }

  void startTimer() {
    remainingTime.value = currentQuestion.value!.timerDuration;
    _timer = Timer.periodic(Duration(seconds: 50), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        submitAnswer();
      }
    });
  }

  void selectAnswer(int index) {
    selectedAnswer.value = index;
  }

  Future<void> submitAnswer() async {
  if (selectedAnswer.value != -1 && currentQuestion.value != null) {
    try {
      final String answerText = currentQuestion.value!.options[selectedAnswer.value];
      final result = await ApiService.submitAnswer(currentQuestion.value!.id, answerText);
      
      isAnswerSubmitted.value = true;
      isLastAnswerCorrect.value = result['correct'] == true;
      
      if (isLastAnswerCorrect.value) {
        score.value++;
      }
      
      coinsEarned.value = result['coins_earned'] ?? 0;
      totalCoins.value = result['total_coins'] ?? 0;
      streak.value = result['streak'] ?? 0;
      emoji.value = result['emoji'] ?? '';
      
      // Update user's coins
      final UserController userController = Get.find<UserController>();
      userController.updateCoins(totalCoins.value);

      Get.snackbar(
        isLastAnswerCorrect.value ? 'Correct!' : 'Incorrect',
        isLastAnswerCorrect.value ? 'Good job!' : 'Better luck next time!',
        backgroundColor: isLastAnswerCorrect.value ? Colors.green : Colors.red,
        colorText: Colors.white,
      );

      await Future.delayed(Duration(seconds: 2));
      moveToNextQuestion();
    } catch (e) {
      print('Error submitting answer: $e');
      Get.snackbar('Error', 'Failed to submit answer. Moving to next question.');
      moveToNextQuestion();
    }
  } else {
    moveToNextQuestion();
  }
}


  void moveToNextQuestion() {
    userAnswers.add(selectedAnswer.value);
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      currentQuestion.value = questions[currentQuestionIndex.value];
      selectedAnswer.value = -1;
      isAnswerSubmitted.value = false;
      isLifelineAvailable.value = true;
      lifelineExplanation.value = '';
      startTimer();
    } else {
      Get.toNamed('/quiz-result');
    }
  }

  void useLifeline() {
    if (isLifelineAvailable.value && currentQuestion.value != null) {
      isLifelineAvailable.value = false;
      lifelineExplanation.value = "This is a hint for the current question. The correct answer is usually related to the main topic of the question.";
      Get.snackbar('Lifeline Used', 'Explanation revealed!');
    } else if (!isLifelineAvailable.value) {
      Get.snackbar('Lifeline Unavailable', 'You can only use the lifeline once per question.');
    }
  }
void handleLifelineResult(List<dynamic> remainingOptions) {
  if (currentQuestion.value != null) {
    currentQuestion.value = currentQuestion.value!.copyWith(
      options: remainingOptions.cast<String>().toList(),
    );
  }
}

  bool get isLastQuestion => currentQuestionIndex.value == questions.length - 1;
}