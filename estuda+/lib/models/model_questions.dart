import 'dart:typed_data';

// Class responsável pelo modelo de questões que serão recebidas da api.
class ModelQuestions {
  String id;
  String elementarySchool;
  String schoolYear;
  String discipline;
  String subject;
  String question;
  Uint8List image;
  String answer;
  String alternativeA;
  String alternativeB;
  String alternativeC;
  String alternativeD;
  String? explanation;
  String? dateResponse;
  String? hourResponse;
  String? timeResponse;

  ModelQuestions({
    required this.id,
    required this.elementarySchool,
    required this.schoolYear,
    required this.discipline,
    required this.subject,
    required this.question,
    required this.image, // Assuming image is an object or null
    required this.answer,
    required this.alternativeA,
    required this.alternativeB,
    required this.alternativeC,
    required this.alternativeD,
    required this.explanation,
    required this.dateResponse,
    required this.hourResponse,
    required this.timeResponse,

  });
// Método que converte Map<String<dynamic>> para ModelQuestions
  ModelQuestions.toModelQuestions(
    Map<String, dynamic> ask,
  )   : id = ask['id'].toString(),
        elementarySchool = ask['elementarySchool'],
        schoolYear = ask['schoolYear'],
        discipline = ask['discipline'],
        subject = ask['subject'],
        question = ask['question'],
        image = ask['image'],
        answer = ask['answer'],
        alternativeA = ask['alternativeA'],
        alternativeB = ask['alternativeB'],
        alternativeC = ask['alternativeC'],
        alternativeD = ask['alternativeD'],
        explanation = ask['explanation'],
        dateResponse = ask['dateResponse'],
        hourResponse = ask['hourResponse'],
        timeResponse = ask['timeResponse'];

}
