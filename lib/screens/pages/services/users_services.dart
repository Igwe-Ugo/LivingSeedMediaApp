// ignore_for_file: prefer_final_fields

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/models.dart';

class UsersAuthProvider extends ChangeNotifier {
  Users? _currentUser;
  Users? get userData => _currentUser;
  List<Users> _users = [];

  Future<void> initializeUsers() async {
    String jsonString = await rootBundle.loadString('assets/json/users.json');
    _users = Users.fromJsonList(jsonString);
    notifyListeners();
  }

  Future<Users?> signIn(String email, String password) async {
    if (_users.isEmpty) {
      await initializeUsers(); // Ensure users are loaded before checking
    }

    Users? user = _users.firstWhereOrNull(
      (u) => u.emailAddress == email && u.password == password,
    );

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return _currentUser;
    } else {
      debugPrint("Error: Invalid credentials for $email");
      return null;
    }
  }

  void signout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUserInfo(Users updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void addToCart(PurchasedBooksItems bookPurchase) {
    if (_currentUser != null) {
      // Will attend to this later because I am meant to pass about_book here....
      /* _currentUser!.bookPurchased.addAll(_currentUser!.cart.map((cartItem) =>
          PurchasedBooksItems(
              bookTitle: cartItem.bookTitle,
              coverImage: cartItem.coverImage,
              bookAuthor: cartItem.bookAuthor,
              readBookPath: cartItem.
              ))); */
      _currentUser!.cart.clear();
      notifyListeners();
    }
  }

  void addToDownloads(MediaItems media) {
    _currentUser?.downloads.add(media);
    notifyListeners();
  }
}
