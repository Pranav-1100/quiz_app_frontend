import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final VoidCallback? onTap;

  const AnswerOption({
    Key? key,
    required this.text,
    required this.isSelected,
    this.isCorrect = false,
    this.isIncorrect = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.1);
    Color borderColor = isSelected ? Colors.blue : Colors.grey;

    if (isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.3);
      borderColor = Colors.green;
    } else if (isIncorrect) {
      backgroundColor = Colors.red.withOpacity(0.3);
      borderColor = Colors.red;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected || isCorrect || isIncorrect ? Colors.black : Colors.black54,
            fontWeight: isSelected || isCorrect || isIncorrect ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}