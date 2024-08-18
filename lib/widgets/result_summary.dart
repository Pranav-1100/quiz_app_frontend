import 'package:flutter/material.dart';

class ResultSummary extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final double percentage;
  final int coinsEarned;
  final int totalCoins;
  final int streak;
  final String emoji;

  const ResultSummary({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.coinsEarned,
    required this.totalCoins,
    required this.streak,
    required this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Quiz Complete! $emoji',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Text(
              'You scored',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$score / $totalQuestions',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
              'Coins earned: $coinsEarned',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Total coins: $totalCoins',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Streak: $streak',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}