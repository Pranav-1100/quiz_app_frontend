import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/models/quiz_model.dart';
import 'package:flutter_application_2/views/quiz/quiz_detail_screen.dart'; // Make sure this import is correct

class QuizCard extends StatelessWidget {
  final QuizModel quiz;

  const QuizCard({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => Get.toNamed('/quiz/${quiz.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                quiz.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDifficultyChip(),
                  if (quiz.completed)
                    Icon(Icons.check_circle, color: Colors.green)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip() {
    Color color;
    String text;
    switch (quiz.difficulty) {
      case 1:
        color = Colors.green;
        text = 'Easy';
        break;
      case 2:
        color = Colors.orange;
        text = 'Medium';
        break;
      default:
        color = Colors.red;
        text = 'Hard';
    }
    return Chip(
      label: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}