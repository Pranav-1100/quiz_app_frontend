import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/quiz_model.dart';
import 'package:flutter_application_2/controllers/user_controller.dart';
import 'package:get/get.dart';

class QuizzesResult {
  final bool isLoading;
  final String? error;
  final List<QuizModel>? data;

  QuizzesResult({required this.isLoading, this.error, this.data});

  factory QuizzesResult.loading() => QuizzesResult(isLoading: true);
  factory QuizzesResult.error(String error) => QuizzesResult(isLoading: false, error: error);
  factory QuizzesResult.data(List<QuizModel> data) => QuizzesResult(isLoading: false, data: data);

  T when<T>({
    required T Function() loading,
    required T Function(String error) error,
    required T Function(List<QuizModel> data) data,
  }) {
    if (isLoading) return loading();
    if (this.error != null) return error(this.error!);
    if (this.data != null) return data(this.data!);
    throw StateError('Impossible state');
  }
}

QuizzesResult useFetchQuizzes() {
  final result = useState<QuizzesResult>(QuizzesResult.loading());
  final userController = Get.find<UserController>();

  useEffect(() {
    if (userController.user.value == null) {
      result.value = QuizzesResult.error('User not logged in');
      return null;
    }

    ApiService.fetchQuizzes(userController.user.value!.id).then((fetchedQuizzes) {
      result.value = QuizzesResult.data(fetchedQuizzes);
    }).catchError((error) {
      print('Error fetching quizzes: $error');
      result.value = QuizzesResult.error(error.toString());
    });

    return null;
  }, [userController.user.value]);

  return result.value;
}