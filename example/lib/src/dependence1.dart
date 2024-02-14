import 'package:dependence_file_annotation/dependence_file_annotation.dart';

@DependenceClass()
class Dependence1 {
  static String getHello() {
    return 'Hello from Dependence1';
  }
}

@DependenceClass()
class Dependence2 {
  static String getHello() {
    return 'Hello from Dependence2';
  }
}

@DependenceClass()
class Dependence3 {
  static String getHello() {
    return 'Hello from Dependence3';
  }
}
