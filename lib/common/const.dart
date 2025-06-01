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

  Map<String, dynamic> banks = {
    "HDFC Bank": {"logo": "assets/images/banks/hdfc.png"},
    "ICICI Bank": {"logo": "assets/images/banks/icici.png"},
    "State Bank of India": {"logo": "assets/images/banks/sbi.png"},
    "Kotak Mahindra Bank": {"logo": "assets/images/banks/kotak.png"},
    "Axis Bank": {"logo": "assets/banks/images/axis.png"},
    "Punjab National Bank": {"logo": "assets/images/banks/pnb.png"},
    "Airtel Payment Bank": {"logo": "assets/images/banks/airtel.png"},
    "Fi Bank": {"logo": "assets/images/banks/fi.png"},
  };
}
