import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/question_model.dart';

List<QuestionModel> useFetchQuestions(String quizId) {
  final questions = useState<List<QuestionModel>>([]);

  useEffect(() {
    ApiService.fetchQuestions(quizId).then((fetchedQuestions) {
      questions.value = fetchedQuestions;
    }).catchError((error) {
      print('Error fetching questions: $error');
    });
    return null;
  }, [quizId]);

  return questions.value;
}