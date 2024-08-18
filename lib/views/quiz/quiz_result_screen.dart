import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/quiz_controller.dart';
import 'package:flutter_application_2/widgets/custom_app_bar.dart';
import 'package:flutter_application_2/widgets/result_summary.dart';
import 'package:flutter_application_2/widgets/primary_button.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizController _quizController = Get.find<QuizController>();

  @override
  Widget build(BuildContext context) {
    final int score = _quizController.score.value;
    final int totalQuestions = _quizController.questions.length;
    final double percentage = (score / totalQuestions) * 100;

    return Scaffold(
      appBar: CustomAppBar(title: 'Quiz Result'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Quiz Complete! ${_quizController.emoji.value}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'You scored',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$score / $totalQuestions',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    _buildResultItem(Icons.monetization_on, 'Coins earned', _quizController.coinsEarned.value.toString()),
                    _buildResultItem(Icons.account_balance_wallet, 'Total coins', _quizController.totalCoins.value.toString()),
                    _buildResultItem(Icons.whatshot, 'Streak', _quizController.streak.value.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            PrimaryButton(
              text: 'Back to Home',
              onPressed: () => Get.offAllNamed('/home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 16)),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}