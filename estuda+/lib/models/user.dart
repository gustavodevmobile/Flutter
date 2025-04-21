class User {
  final String userName;
  final String birthDate;
  final String schoolYear;

  const User({
    required this.userName,
    required this.birthDate,
    required this.schoolYear,
  });

  User.toUser(Map<String, dynamic> map)
      : userName = map['userName'],
        birthDate = map['birthDate'],
        schoolYear = map['schoolYear'];

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'birthDate': birthDate,
      'schoolYear': schoolYear
    };
  }
}
