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
    debugPrint("Raw JSON Data: $jsonString");

    _users = Users.fromJsonList(jsonString);

    debugPrint("Users loaded: ${_users.length}");
    debugPrint(
        "First user: ${_users.isNotEmpty ? _users.first.emailAddress : 'No users found'}");
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    if (_users.isEmpty) {
      await initializeUsers(); // Ensure users are loaded before checking
    }

    debugPrint("Loaded users: ${_users.map((u) => u.emailAddress).toList()}");

    Users? user = _users.firstWhereOrNull(
      (u) => u.emailAddress == email && u.password == password,
    );

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    } else {
      debugPrint("Error: Invalid credentials for $email");
      return false;
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
      _currentUser!.bookPurchased.addAll(_currentUser!.cart.map((cartItem) =>
          PurchasedBooksItems(
              bookTitle: cartItem.bookTitle,
              coverImage: cartItem.coverImage,
              bookAuthor: cartItem.bookAuthor)));
      _currentUser!.cart.clear();
      notifyListeners();
    }
  }

  void addToDownloads(MediaItems media) {
    _currentUser?.downloads.add(media);
    notifyListeners();
  }
}
