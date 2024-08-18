import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_application_2/services/api_service.dart';

Map<String, dynamic> useLifeline(int questionId) {
  final lifelineResult = useState<Map<String, dynamic>>({});

  useEffect(() {
    ApiService.useLifeline(questionId).then((result) {
      lifelineResult.value = result;
    }).catchError((error) {
      print('Error using lifeline: $error');
    });
    return null;
  }, [questionId]);

  return lifelineResult.value;
}