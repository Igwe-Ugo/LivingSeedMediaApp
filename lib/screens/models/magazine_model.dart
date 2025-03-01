import 'dart:convert';

class MagazineModel {
  final String magazineTitle;
  final String issue;
  final String coverImage;
  final String publisher;
  final int price;
  final String publicationDate;
  final String subTitle;
  final EditorsDesk editorsDesk;
  final List<Chapter> contents;
  final BibleStudyMagazine bibleStudy;

  MagazineModel({
    required this.magazineTitle,
    required this.issue,
    required this.price,
    required this.coverImage,
    required this.publisher,
    required this.publicationDate,
    required this.editorsDesk,
    required this.contents,
    required this.bibleStudy,
    required this.subTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'magazineTitle': magazineTitle,
      'issue': issue,
      'price': price,
      'coverImage': coverImage,
      'publisher': publisher,
      'publicationDate': publicationDate,
      'subTitle': subTitle,
      'editorsDesk': editorsDesk.toJson(),
      'contents': contents.map((item) => item.toJson()).toList(),
      'bibleStudy': bibleStudy.toJson(),
    };
  }

  static List<MagazineModel> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => MagazineModel.fromJson(item)).toList();
  }

  factory MagazineModel.fromJson(Map<String, dynamic> json) {
    return MagazineModel(
        magazineTitle: json['magazineTitle'],
        issue: json['issue'],
        price: json['price'],
        coverImage: json['coverImage'],
        publisher: json['publisher'],
        publicationDate: json['publicationDate'],
        editorsDesk: EditorsDesk.fromJson(json['editorsDesk']),
        contents: (json['contents'] as List)
            .map((item) => Chapter.fromJson(item))
            .toList(),
        bibleStudy: BibleStudyMagazine.fromJson(json['bibleStudy']),
        subTitle: json['subTitle']);
  }
}

class EditorsDesk {
  final String title;
  final String editor;
  final int pageNumber;

  EditorsDesk(
      {required this.title, required this.pageNumber, required this.editor});

  factory EditorsDesk.fromJson(Map<String, dynamic> json) {
    return EditorsDesk(
        pageNumber: json['pageNumber'],
        title: json['title'],
        editor: json['editor']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'pageNumber': pageNumber,
      'editor': editor,
    };
  }
}

class Chapter {
  final int chapterNumber;
  final String chapterTitle;
  final String chapterAuthor;
  final int pageNumber;

  Chapter({
    required this.chapterNumber,
    required this.chapterTitle,
    required this.chapterAuthor,
    required this.pageNumber,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: json['chapterNumber'],
      chapterTitle: json['chapterTitle'],
      chapterAuthor: json['chapterAuthor'],
      pageNumber: json['pageNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'chapterAuthor': chapterAuthor,
      'pageNumber': pageNumber,
    };
  }
}

class BibleStudyMagazine {
  final String title;
  final List<String> keyVerses;

  BibleStudyMagazine({
    required this.title,
    required this.keyVerses,
  });

  factory BibleStudyMagazine.fromJson(Map<String, dynamic> json) {
    return BibleStudyMagazine(
      title: json['title'],
      keyVerses: List<String>.from(json['keyVerses']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'keyVerses': keyVerses,
    };
  }
}
