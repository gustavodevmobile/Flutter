class Counter {
  static int count = 0;
  static int matchs = 0;

  void increment() {
    count++;
  }

  void decrement() {
    count--;
  }

  void counterMatch() {
    if (matchs == 26) {
      matchs = 0;
    } else {
      matchs++;
    }
  }
}
