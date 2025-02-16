import 'dart:convert';

class ReviewRating {
  final String reviewText;
  final String reviewTitle;
  final String date;
  final String reviewer;
  final double reviewRating;

  ReviewRating(
      {required this.reviewText,
      required this.reviewTitle,
      required this.date,
      required this.reviewer,
      required this.reviewRating});

  // Convert JSON to RatingReview object
  factory ReviewRating.fromJson(Map<String, dynamic> json) {
    return ReviewRating(
      reviewText: json["reviewText"],
      date: json["date"],
      reviewTitle: json["reviewTitle"],
      reviewer: json["reviewer"],
      reviewRating: (json["reviewRating"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reviewText": reviewText,
      "date": date,
      "reviewTitle": reviewTitle,
      "reviewer": reviewer,
      "reviewRating": reviewRating,
    };
  }
}

class BibleStudyMaterial {
  final String title;
  final double amount;
  final String subTitle;
  final String coverImage;
  final String pdfLink;
  final int chapterNum;
  final List<ReviewRating> ratingReviews;
  final List<Map<String, String>> contents;

  BibleStudyMaterial(
      {required this.title,
      required this.chapterNum,
      required this.amount,
      required this.coverImage,
      required this.pdfLink,
      required this.ratingReviews,
      required this.contents,
      required this.subTitle});

  factory BibleStudyMaterial.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> extractedContents = [];
    if (json['contents'] != null && json['contents'] is List) {
      extractedContents = (json['contents'] as List)
          .map((chapter) => Map<String, String>.from(chapter as Map))
          .toList();
    }

    List<ReviewRating> extractedReviews = [];
    if (json['ratingReviews'] != null && json['ratingReviews'] is List) {
      extractedReviews = (json['ratingReviews'] as List)
          .map((item) => ReviewRating.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return BibleStudyMaterial(
        subTitle: json['subTitle'],
        coverImage: json['coverImage'],
        title: json['title'],
        chapterNum: json['chapterNum'],
        amount: (json['amount'] as num).toDouble(),
        pdfLink: json['pdfLink'],
        ratingReviews: extractedReviews,
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
      "ratingReviews": ratingReviews.map((review) => review.toJson()).toList(),
      "contents": contents
    };
  }

  static List<BibleStudyMaterial> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => BibleStudyMaterial.fromJson(item)).toList();
  }
}
