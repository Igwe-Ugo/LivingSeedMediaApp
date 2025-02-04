import 'dart:convert';

class CartItems {
  final String bookTitle;
  final String coverImage;
  final String bookAuthor;
  final int amount;

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
      amount: (json['amount']),
    );
  }
}

class PurchasedBooksItems {
  final String bookTitle;
  final String coverImage;
  final String bookAuthor;
  final String readBookPath;
  final int date;

  PurchasedBooksItems({
    required this.bookTitle,
    required this.coverImage,
    required this.bookAuthor,
    required this.readBookPath,
    required this.date
  });

  factory PurchasedBooksItems.fromJson(Map<String, dynamic> json) {
    return PurchasedBooksItems(
      bookTitle: json["bookTitle"],
      bookAuthor: json["bookAuthor"],
      coverImage: json["coverImage"],
      readBookPath: json['readBookPath'],
      date: (json['date'] as num).toInt(),
    );
  }
}

class MediaItems {
  final String title;
  final String mediaImage;
  final String mediaUrl;
  final String speaker;
  final String size;
  final String date;
  final String time;

  MediaItems({
    required this.title,
    required this.mediaImage,
    required this.mediaUrl,
    required this.speaker,
    required this.size,
    required this.date,
    required this.time,
  });

  factory MediaItems.fromJson(Map<String, dynamic> json) {
    return MediaItems(
        title: json["title"],
        mediaImage: json["mediaImage"],
        mediaUrl: json["mediaUrl"],
        speaker: json["speaker"],
        size: json['size'],
        date: json['date'],
        time: json['time'],
      );
  }
}

class Users {
  final String fullname;
  final String emailAddress;
  final String telephone;
  final String userImage;
  final String password;
  final String gender;
  final String dateOfBirth;
  final String role;
  final List<CartItems> cart;
  final List<PurchasedBooksItems> bookPurchased;
  final List<MediaItems> downloads;

  Users(
      {required this.fullname,
      required this.emailAddress,
      required this.userImage,
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
      extractedCart = (json['cart'] as List)
          .map((e) => CartItems.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<PurchasedBooksItems> extractedBookPurchased = [];
    if (json['bookPurchased'] != null && json['bookPurchased'] is List) {
      extractedBookPurchased = (json['bookPurchased'] as List)
          .map((e) => PurchasedBooksItems.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<MediaItems> extractedDownloads = [];
    if (json['downloads'] != null && json['downloads'] is List) {
      extractedDownloads = (json['downloads'] as List)
          .map((item) => MediaItems.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Users(
        fullname: json['fullname'],
        emailAddress: json['emailAddress'],
        userImage: json['userImage'],
        telephone: json['telephone'],
        password: json['password'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'],
        role: json['role'],
        cart: extractedCart,
        downloads: extractedDownloads,
        bookPurchased: extractedBookPurchased);
  }

  // Convert a JSON string (list) to a list of Users
  static List<Users> fromJsonList(String jsonString) {
    List<dynamic> jsonList = json.decode(jsonString); // Ensure it's a list
    return jsonList.map((json) => Users.fromJson(json)).toList();
  }
}
