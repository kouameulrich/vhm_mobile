class Leaman {
  final String leamanLastName;
  final String leamanFirstName;
  final String leamanPhone;
  final String leamanDateOfEntry;
  final String leamanGender;
  final String leamanStatus;
  final String leamanChurch;
  final String leamanChurchInfo;
  final String leamanInvited;

  Leaman({
    required this.leamanLastName,
    required this.leamanFirstName,
    required this.leamanPhone,
    required this.leamanDateOfEntry,
    required this.leamanGender,
    required this.leamanStatus,
    required this.leamanChurch,
    required this.leamanChurchInfo,
    required this.leamanInvited,
  });

  factory Leaman.fromJson(Map<String, dynamic> json) => Leaman(
        leamanLastName: json['leamanLastName'],
        leamanFirstName: json['leamanFirstName'],
        leamanPhone: json['leamanPhone'],
        leamanDateOfEntry: json['leamanDateOfEntry'],
        leamanGender: json['leamanGender'],
        leamanStatus: json['leamanStatus'],
        leamanChurch: json['leamanChurch'],
        leamanChurchInfo: json['leamanChurchInfo'],
        leamanInvited: json['leamanInvited'],
      );

  Map<String, dynamic> toJson() => {
        'leamanLastName': leamanLastName,
        'leamanFirstName': leamanFirstName,
        'leamanPhone': leamanPhone,
        'leamanDateOfEntry': leamanDateOfEntry,
        'leamanGender': leamanGender,
        'leamanStatus': leamanStatus,
        'leamanChurch': leamanChurch,
        'leamanChurchInfo': leamanChurchInfo,
        'leamanInvited': leamanInvited,
      };
}
