class Members {
  final int memberId;
  final String memberLastName;
  final String memberFirstName;
  final String memberFullName;
  final String memberPhone;
  final String? memberStatus;
  bool flag;

  Members({
    required this.memberId,
    required this.memberLastName,
    required this.memberFirstName,
    required this.memberFullName,
    required this.memberPhone,
    required this.memberStatus,
    required this.flag,
  });

  factory Members.fromJson(Map<String, dynamic> json) => Members(
        memberId: json['memberId'],
        memberLastName: json['memberLastName'],
        memberFirstName: json['memberFirstName'],
        memberFullName: json['memberFullName'],
        memberPhone: json['memberPhone'],
        memberStatus: json['memberStatus'],
        flag: json['flag'],
      );

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'memberLastName': memberLastName,
        'memberFirstName': memberFirstName,
        'memberFullName': memberFullName,
        'memberPhone': memberPhone,
        'memberStatus': memberStatus,
        'flag': flag
      };
}
