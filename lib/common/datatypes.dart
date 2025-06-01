class BankAccount {
  String bankName;
  String? nickname;
  int? savingsBalance;
  int? fdBalance;

  BankAccount({
    required this.bankName,
    this.nickname,
    this.savingsBalance = 0,
    this.fdBalance = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'nickname': nickname,
      'savingsBalance': savingsBalance,
      'fdBalance': fdBalance,
    };
  }

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bankName: json['bankName'] as String,
      nickname: json['nickname'] as String?,
      savingsBalance: json['savingsBalance'] as int? ?? 0,
      fdBalance: json['fdBalance'] as int? ?? 0,
    );
  }
}
