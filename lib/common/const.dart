class Const {
  static final Const _instance = Const._internal();
  static final double maxCardWidth = 400;
  static final double maxScreenHeight = 1000;

  factory Const() {
    return _instance;
  }

  Const._internal() {
    // init
  }
}
