import 'package:flutter_test/flutter_test.dart';
import 'package:stage/Stage/stage.dart';

enum St8s { token, oi2 }

void main() {
  Stage.set(St8s.token, 86897);
  print(Stage.get(St8s.token));
}
