import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/quiz_controller.dart';
import 'package:flutter_application_2/models/quiz_model.dart';
import 'package:flutter_application_2/widgets/custom_app_bar.dart';
import 'package:flutter_application_2/widgets/primary_button.dart';
import 'package:flutter_application_2/widgets/info_card.dart';

class QuizDetailScreen extends StatelessWidget {
  final String quizId;
  final QuizController _quizController = Get.find<QuizController>();

  QuizDetailScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quiz = _quizController.getQuizById(quizId);
      if (quiz == null) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Quiz Not Found'),
          body: Center(child: Text('The requested quiz was not found.')),
        );
      }

      return Scaffold(
        appBar: CustomAppBar(title: quiz.name),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  title: 'Description',
                  content: quiz.description,
                ),
                SizedBox(height: 16),
                InfoCard(
                  title: 'Difficulty',
                  content: _getDifficultyText(quiz.difficulty),
                ),
                SizedBox(height: 16),
                InfoCard(
                  title: 'Threshold',
                  content: '${quiz.threshold} points',
                ),
                SizedBox(height: 16),
                InfoCard(
                  title: 'Status',
                  content: quiz.completed ? 'Completed' : 'Not attempted',
                ),
                SizedBox(height: 24),
                PrimaryButton(
                  text: 'Start Quiz',
                  onPressed: () => _startQuiz(quiz),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  void _startQuiz(QuizModel quiz) {
    _quizController.startQuiz(quiz.id.toString()).then((_) {
      Get.toNamed('/quiz/${quiz.id}/start');
    }).catchError((error) {
      Get.snackbar(
        'Error',
        'Failed to start quiz: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
}