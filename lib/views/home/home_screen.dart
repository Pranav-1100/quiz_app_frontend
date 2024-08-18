import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/quiz_model.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/quiz_controller.dart';
import 'package:flutter_application_2/widgets/quiz_card.dart';
import 'package:flutter_application_2/widgets/coin_display.dart';
import 'package:flutter_application_2/widgets/custom_app_bar.dart';
import 'package:flutter_application_2/widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  final QuizController _quizController = Get.find<QuizController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Quiz App',
        actions: [CoinDisplay()],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: Obx(() {
          if (_quizController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_quizController.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_quizController.errorMessage.value, 
                       style: TextStyle(color: Colors.red, fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _quizController.fetchQuizzes(),
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  ),
                ],
              ),
            );
          } else if (_quizController.allQuizzes.isEmpty) {
            return Center(child: Text('No quizzes available', 
                                      style: TextStyle(fontSize: 20, color: Colors.indigo)));
          } else {
            return RefreshIndicator(
              onRefresh: _quizController.fetchQuizzes,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnalytics(),
                      SizedBox(height: 20),
                      _buildQuizSection('All Quizzes', _quizController.allQuizzes),
                      SizedBox(height: 20),
                      _buildQuizSection('Completed Quizzes', _getHardcodedCompletedQuizzes()),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.toNamed('/leaderboard');
          }
        },
      ),
    );
  }

  Widget _buildQuizSection(String title, List<QuizModel> quizzes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        SizedBox(height: 10),
        quizzes.isEmpty
            ? Text('No $title available', style: TextStyle(fontSize: 16, color: Colors.grey))
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return QuizCard(quiz: quiz);
                },
              ),
      ],
    );
  }

  Widget _buildAnalytics() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 10),
            _buildAnalyticItem('Total Quizzes', _quizController.allQuizzes.length.toString()),
            _buildAnalyticItem('Completed Quizzes', _getHardcodedCompletedQuizzes().length.toString()),
            _buildAnalyticItem('Completion Rate', '${_calculateCompletionRate()}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
        ],
      ),
    );
  }

  String _calculateCompletionRate() {
    if (_quizController.allQuizzes.isEmpty) return '0';
    double rate = (_getHardcodedCompletedQuizzes().length / _quizController.allQuizzes.length) * 100;
    return rate.toStringAsFixed(2);
  }

  List<QuizModel> _getHardcodedCompletedQuizzes() {
    return [
      QuizModel(
        id: 1,
        name: "General Knowledge",
        description: "Test your knowledge on various topics",
        difficulty: 1,
        completed: true,
        threshold: 70,
      ),
    ];
  }
}