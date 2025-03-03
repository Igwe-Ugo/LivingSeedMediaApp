import 'dart:convert';

class BibleStudyMaterial {
  final String title;
  final double amount;
  final String subTitle;
  final String coverImage;
  final String pdfLink;
  final int chapterNum;
  final List<Map<String, String>> contents;

  BibleStudyMaterial(
      {required this.title,
      required this.chapterNum,
      required this.amount,
      required this.coverImage,
      required this.pdfLink,
      required this.contents,
      required this.subTitle});

  factory BibleStudyMaterial.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> extractedContents = [];
    if (json['contents'] != null && json['contents'] is List) {
      extractedContents = (json['contents'] as List)
          .map((chapter) => Map<String, String>.from(chapter as Map))
          .toList();
    }

    return BibleStudyMaterial(
        subTitle: json['subTitle'],
        coverImage: json['coverImage'],
        title: json['title'],
        chapterNum: json['chapterNum'],
        amount: (json['amount'] as num).toDouble(),
        pdfLink: json['pdfLink'],
        contents: extractedContents);
  }

  Map<String, dynamic> toJson() {
    return {
      "coverImage": coverImage,
      "title": title,
      "subTitle": subTitle,
      "amount": amount,
      "pdfLink": pdfLink,
      "chapterNum": chapterNum,
      "contents": contents
    };
  }

  static List<BibleStudyMaterial> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => BibleStudyMaterial.fromJson(item)).toList();
  }
}
