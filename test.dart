class MyClass {
  call() {
    print('callable class code runs...');
  }
}

void main(List<String> args) {
  MyClass()(); // output - callable class code runs...
  final a = true;
  final b = true;
  print(a == b);
}
