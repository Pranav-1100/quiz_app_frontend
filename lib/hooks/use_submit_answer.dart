import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_application_2/services/api_service.dart';

bool useSubmitAnswer(int questionId, int answer) {
  final isCorrect = useState<bool>(false);

  useEffect(() {
    ApiService.submitAnswer(questionId, answer).then((result) {
      isCorrect.value = result;
    }).catchError((error) {
      print('Error submitting answer: $error');
    });
    return null;
  }, [questionId, answer]);

  return isCorrect.value;
}