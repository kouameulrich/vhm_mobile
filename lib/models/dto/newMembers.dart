class NewMembers {
  final String memberLastName;
  final String memberFirstName;
  final String memberPhone;
  final String memberDateOfEntry;
  final String memberInvitedBy;
  final String memberGender;
  final int churchId;
  final int memberTypeId;

  NewMembers({
    required this.memberLastName,
    required this.memberFirstName,
    required this.memberPhone,
    required this.memberDateOfEntry,
    required this.memberInvitedBy,
    required this.memberGender,
    required this.churchId,
    required this.memberTypeId,
  });

  factory NewMembers.fromJson(Map<String, dynamic> json) => NewMembers(
        memberLastName: json['memberLastName'],
        memberFirstName: json['memberFirstName'],
        memberPhone: json['memberPhone'],
        memberDateOfEntry: json['memberDateOfEntry'],
        memberInvitedBy: json['memberInvitedBy'],
        memberGender: json['memberGender'],
        churchId: json['churchId'],
        memberTypeId: json['memberTypeId'],
      );

  Map<String, dynamic> toJson() => {
        'memberLastName': memberLastName,
        'memberFirstName': memberFirstName,
        'memberPhone': memberPhone,
        'memberDateOfEntry': memberDateOfEntry,
        'memberInvitedBy': memberInvitedBy,
        'memberGender': memberGender,
        'churchId': churchId,
        'memberTypeId': memberTypeId,
      };
}
