import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final String questionText;

  const QuestionCard({
    Key? key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question $questionNumber of $totalQuestions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            Text(
              questionText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}