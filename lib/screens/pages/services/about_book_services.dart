// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/screens/models/models.dart';
import 'package:path_provider/path_provider.dart';

Future<List<AboutBooks>> loadAboutBook() async {
  try {
    String jsonString =
        await rootBundle.loadString('assets/json/about_book.json');

    // decode JSON and convert to a list of book object
    List<AboutBooks> aboutBook = AboutBooks.fromJsonList(jsonString);
    return aboutBook;
  } catch (e) {
    debugPrint('Error Loading JSON: $e');
    return [];
  }
}

class AboutBookProvider extends ChangeNotifier {
  AboutBooks? _currentBook;
  AboutBooks? get bookData => _currentBook;
  List<AboutBooks> _books = [];
  List<AboutBooks> get allBooks => _books;

  Future<void> initializeUsers() async {
    String jsonString =
        await rootBundle.loadString('assets/json/about_book.json');
    _books = AboutBooks.fromJsonList(jsonString);
    await _loadUserFromLocal();
    notifyListeners();
  }

  Future<void> _loadUserFromLocal() async {
    try {
      final file = await _getUserFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        _books = jsonList.map((json) => AboutBooks.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local user data: $e');
    }
  }

  Future<File> _getUserFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/about_book.json');
  }

  Future<void> _saveUserToLocal() async {
    final file = await _getUserFile();
    String jsonData = json.encode(_books.map((book) => book.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  Future<bool> uploadBook(AboutBooks newBook) async {
    if (_books.any((book) => book.bookTitle == newBook.bookTitle)) {
      return false;
    }
    _books.add(newBook);
    _currentBook = newBook;
    await _saveUserToLocal();
    notifyListeners();
    return true;
  }
}
