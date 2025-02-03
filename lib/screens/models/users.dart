import 'dart:convert';

class CartItems {
  final String bookTitle;
  final String coverImage;
  final String bookAuthor;
  final double amount;

  CartItems({
    required this.bookTitle,
    required this.coverImage,
    required this.bookAuthor,
    required this.amount,
  });

  factory CartItems.fromJson(Map<String, dynamic> json) {
    return CartItems(
      bookTitle: json['bookTitle'],
      coverImage: json['coverImage'],
      bookAuthor: json['bookAuthor'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class PurchasedBooks {
  final String bookTitle;
  final String coverImage;
  final String bookAuthor;

  PurchasedBooks({
    required this.bookTitle,
    required this.coverImage,
    required this.bookAuthor,
  });

  factory PurchasedBooks.fromJson(Map<String, dynamic> json) {
    return PurchasedBooks(
      bookTitle: json["bookTitle"],
      bookAuthor: json["bookAuthor"],
      coverImage: json["coverImage"],
    );
  }
}

class DownloadItems {
  final String title;
  final String mediaImage;
  final String mediaUrl;
  final String speaker;

  DownloadItems({
    required this.title,
    required this.mediaImage,
    required this.mediaUrl,
    required this.speaker,
  });

  factory DownloadItems.fromJson(Map<String, dynamic> json) {
    return DownloadItems(
        title: json["title"],
        mediaImage: json["mediaImage"],
        mediaUrl: json["mediaUrl"],
        speaker: json["speaker"]);
  }
}

class Users {
  final String fullname;
  final String emailAddress;
  final String telephone;
  final String password;
  final String gender;
  final String dateOfBirth;
  final String role;
  final List<CartItems> cart;
  final List<PurchasedBooks> bookPurchased;
  final List<DownloadItems> downloads;

  Users(
      {required this.fullname,
      required this.emailAddress,
      required this.telephone,
      required this.password,
      required this.gender,
      required this.dateOfBirth,
      required this.role,
      required this.cart,
      required this.bookPurchased,
      required this.downloads});

  factory Users.fromJson(Map<String, dynamic> json) {
    List<CartItems> extractedCart = [];
    if (json['cart'] != null && json['cart'] is List) {
      extractedCart = (json['cart'][0] as List).map((e) => CartItems.fromJson(e as Map<String, dynamic>)).toList();
    }

    List<PurchasedBooks> extractedBookPurchased = [];
    if (json['bookPurchased'] != null && json['bookPurchased'] is List) {
      extractedBookPurchased = (json['bookPurchased'] as List).map((e) => PurchasedBooks.fromJson(e as Map<String, dynamic>)).toList();
    }

    List<DownloadItems> extractedDownloads = [];
    if (json['downloads'] != null && json['downloads'] is List) {
      extractedDownloads = (json['downloads'] as List)
          .map((item) => DownloadItems.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Users(
        fullname: json['fullname'],
        emailAddress: json['emailAddress'],
        telephone: json['telephone'],
        password: json['password'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'],
        role: json['role'],
        cart: extractedCart,
        downloads: extractedDownloads,
        bookPurchased: extractedBookPurchased);
  }

  static List<Users> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => Users.fromJson(item)).toList();
  }
}
