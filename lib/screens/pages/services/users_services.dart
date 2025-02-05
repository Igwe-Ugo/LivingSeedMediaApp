// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../../models/models.dart';

class UsersAuthProvider extends ChangeNotifier {
  Users? _currentUser;
  Users? get userData => _currentUser;
  List<Users> _users = [];

  Future<void> initializeUsers() async {
    String jsonString = await rootBundle.loadString('assets/json/users.json');
    _users = Users.fromJsonList(jsonString);
    await _loadUserFromLocal();
    notifyListeners();
  }

  Future<void> _loadUserFromLocal() async {
    try {
      final file = await _getUserFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        _users = jsonList.map((json) => Users.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local user data: $e');
    }
  }

  Future<File> _getUserFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/users.json');
  }

  Future<void> _saveUserToLocal() async {
    final file = await _getUserFile();
    String jsonData = json.encode(_users.map((user) => user.toJson()).toList());
    await file.writeAsString(jsonData);
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
    _saveUserToLocal();
  }

  void addToCart(AboutBooks book) {
    if (_currentUser != null) {
      _currentUser!.cart.add(CartItems(
          coverImage: book.coverImage,
          bookTitle: book.bookTitle,
          bookAuthor: book.author,
          amount: book.amount));
      notifyListeners();
      _saveUserToLocal();
    }
  }

  // remove specific item from cart
  void removeFromCart(String bookTitle) {
    if (_currentUser != null) {
      _currentUser!.cart.removeWhere((item) => item.bookTitle == bookTitle);
      notifyListeners();
      _saveUserToLocal();
    }
  }

  // clear the entire cart
  void clearCart() {
    if (_currentUser != null) {
      _currentUser!.cart.clear();
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void addToBookPurchase(AboutBooks book) {
    if (_currentUser != null) {
      _currentUser!.bookPurchased.add(PurchasedBooksItems(
          bookTitle: book.bookTitle,
          coverImage: book.coverImage,
          bookAuthor: book.author,
          readBookPath: book.pdfLink,
          date: book.productionDate));
      notifyListeners();
      clearCart();
      _saveUserToLocal();
    }
  }

  void deletePurchasedBook(String bookTitle) {
    if (_currentUser != null) {
      _currentUser!.bookPurchased
          .removeWhere((item) => item.bookTitle == bookTitle);
      notifyListeners();
      _saveUserToLocal();
    }
  }

  void addToDownloads(MediaItems media) {
    _currentUser?.downloads.add(media);
    notifyListeners();
    _saveUserToLocal();
  }
}
