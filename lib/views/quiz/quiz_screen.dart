import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/quiz_controller.dart';
import 'package:flutter_application_2/models/question_model.dart';
import 'package:flutter_application_2/widgets/custom_app_bar.dart';
import 'package:flutter_application_2/widgets/question_card.dart';
import 'package:flutter_application_2/widgets/answer_option.dart';
import 'package:flutter_application_2/widgets/primary_button.dart';
import 'package:flutter_application_2/widgets/timer_display.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController _quizController = Get.find<QuizController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quizController.startQuiz(widget.quizId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Quiz',
        actions: [
          Obx(() => TimerDisplay(seconds: _quizController.remainingTime.value)),
        ],
      ),
      body: Obx(() {
        if (_quizController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (_quizController.currentQuestion.value == null) {
          return Center(child: Text('No questions available'));
        }
        QuestionModel question = _quizController.currentQuestion.value!;
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QuestionCard(
                        questionNumber: _quizController.currentQuestionIndex.value + 1,
                        totalQuestions: _quizController.questions.length,
                        questionText: question.text,
                      ),
                      SizedBox(height: 24),
                      ...question.options.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String option = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: AnswerOption(
                            text: option,
                            isSelected: _quizController.selectedAnswer.value == idx,
                            isCorrect: _quizController.isAnswerSubmitted.value && 
                                      _quizController.selectedAnswer.value == idx && 
                                      _quizController.isLastAnswerCorrect.value,
                            isIncorrect: _quizController.isAnswerSubmitted.value && 
                                        _quizController.selectedAnswer.value == idx && 
                                        !_quizController.isLastAnswerCorrect.value,
                            onTap: _quizController.isAnswerSubmitted.value 
                              ? null 
                              : () => _quizController.selectAnswer(idx),
                          ),
                        );
                      }).toList(),
                      if (_quizController.lifelineExplanation.value.isNotEmpty)
        if (_quizController.lifelineExplanation.value.isNotEmpty)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lifeline Hint:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(_quizController.lifelineExplanation.value),
                    ],
                  ),
                ),
              ),

            ElevatedButton(
              onPressed: _quizController.isLifelineAvailable.value
                ? _quizController.useLifeline
                : null,
              child: Text('Use Lifeline'),
            ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Use Lifeline',
                        onPressed: _quizController.isAnswerSubmitted.value || !_quizController.isLifelineAvailable.value
                          ? null 
                          : () => _quizController.useLifeline(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton(
                        text: _quizController.isAnswerSubmitted.value
                          ? (_quizController.isLastQuestion ? 'Finish Quiz' : 'Next Question')
                          : 'Submit Answer',
                        onPressed: _quizController.isAnswerSubmitted.value
                          ? () => _quizController.moveToNextQuestion()
                          : (_quizController.selectedAnswer.value != -1
                              ? () => _quizController.submitAnswer()
                              : null),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}