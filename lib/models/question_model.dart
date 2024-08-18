class QuestionModel {
  final int id;
  final String text;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final int timerDuration;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.timerDuration,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      text: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? 0,
      explanation: json['explanation'] ?? '',
      timerDuration: json['timer_duration'] ?? 30, // Default to 30 seconds if not provided
    );
  }

  QuestionModel copyWith({
    int? id,
    String? text,
    List<String>? options,
    int? correctAnswer,
    String? explanation,
    int? timerDuration,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      timerDuration: timerDuration ?? this.timerDuration,
    );
  }
}