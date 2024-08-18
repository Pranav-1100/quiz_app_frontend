class QuizModel {
  final int id;
  final String name;
  final String description;
  final int difficulty;
  final bool completed;
  final int threshold;

  QuizModel({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.completed,
    required this.threshold,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
  return QuizModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    difficulty: json['difficulty'],
    completed: json['completed'],
    threshold: json['threshold'],
  );
}
}