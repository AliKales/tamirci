class MIban {
  String fullName;
  String bankName;
  String ibanNo;

  MIban({
    required this.fullName,
    required this.bankName,
    required this.ibanNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'bankName': bankName,
      'ibanNo': ibanNo,
    };
  }

  factory MIban.fromJson(Map<String, dynamic> json) {
    return MIban(
      fullName: json['fullName'] as String,
      bankName: json['bankName'] as String,
      ibanNo: json['ibanNo'] as String,
    );
  }

  @override
  String toString() =>
      "MIban(fullName: $fullName,bankName: $bankName,ibanNo: $ibanNo)";

  @override
  int get hashCode => Object.hash(fullName, bankName, ibanNo);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MIban &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          bankName == other.bankName &&
          ibanNo == other.ibanNo;
}
