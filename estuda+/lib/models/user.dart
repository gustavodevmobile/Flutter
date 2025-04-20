class User {
  final String userName;
  final String birthDate;
  final String schoolYear;

  const User({
    required this.userName,
    required this.birthDate,
    required this.schoolYear,
  });

  User.toMap(Map<String, dynamic> map)
      : userName = map['userName'],
        birthDate = map['birthDate'],
        schoolYear = map['schoolYear'];
}
