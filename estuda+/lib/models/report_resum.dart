class ReportResum {
  final String schoolYear;
  final String discipline;
  final String subject;
  final String date;
  final String hours;
  final String timeResponse;

  const ReportResum({
    required this.schoolYear,
    required this.discipline,
    required this.subject,
    required this.date,
    required this.hours,
    required this.timeResponse,
  });

  ReportResum.toMap(Map<String, dynamic> map)
      : schoolYear = map['schoolYear'],
        discipline = map['discipline'],
        subject = map['subject'],
        date = map['date'],
        hours = map['hours'],
        timeResponse = map['timeResponse'];
}
