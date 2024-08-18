import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuizTimer extends HookWidget {
  final int durationInSeconds;

  QuizTimer({required this.durationInSeconds});

  @override
  Widget build(BuildContext context) {
    final remainingTime = useState(durationInSeconds);

    useEffect(() {
      final timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (remainingTime.value > 0) {
          remainingTime.value--;
        }
      });
      return timer.cancel;
    }, []);

    return Text('Time remaining: ${remainingTime.value} seconds');
  }
}