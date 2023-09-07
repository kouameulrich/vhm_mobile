class Members {
  final int memberId;
  final String memberLastName;
  final String memberFirstName;
  final String memberFullName;
  final String memberPhone;
  final String? memberStatus;
  int flag;

  Members({
    required this.memberId,
    required this.memberLastName,
    required this.memberFirstName,
    required this.memberFullName,
    required this.memberPhone,
    required this.memberStatus,
    required bool flag,
  }) : flag = flag ? 1 : 0; // Convertir le booléen en int

  factory Members.fromJson(Map<String, dynamic> json) => Members(
        memberId: json['memberId'],
        memberLastName: json['memberLastName'],
        memberFirstName: json['memberFirstName'],
        memberFullName: json['memberFullName'],
        memberPhone: json['memberPhone'],
        memberStatus: json['memberStatus'],
        flag: json['flag'] == 1, // Convertir le int en booléen
      );

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'memberLastName': memberLastName,
        'memberFirstName': memberFirstName,
        'memberFullName': memberFullName,
        'memberPhone': memberPhone,
        'memberStatus': memberStatus,
        'flag': flag,
      };
}
