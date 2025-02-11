// ignore_for_file: prefer_final_fields
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/screens/models/models.dart';
import 'package:path_provider/path_provider.dart';

Future<List<AboutBooks>> loadAboutBook() async {
  try {
    String jsonString = await rootBundle.loadString('assets/json/about_book.json');

    // Decode JSON and convert to a list of book objects
    List<AboutBooks> aboutBooks = AboutBooks.fromJsonList(jsonString);
    return aboutBooks;
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

  /// **Initialize Books from JSON**
  Future<void> initializeBooks() async {
    try {
      String jsonString = await rootBundle.loadString('assets/json/about_book.json');
      _books = AboutBooks.fromJsonList(jsonString);
      await _loadBooksFromLocal(); // Load local saved books
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing books: $e');
    }
  }

  /// **Load Books from Local Storage**
  Future<void> _loadBooksFromLocal() async {
    try {
      final file = await _getBooksFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        _books = jsonList.map((json) => AboutBooks.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading local book data: $e');
    }
  }

  /// **Get File Path for Books Storage**
  Future<File> _getBooksFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/about_book.json');
  }

  /// **Save Books to Local Storage**
  Future<void> _saveBooksToLocal() async {
    try {
      final file = await _getBooksFile();
      String jsonData = json.encode(_books.map((book) => book.toJson()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      debugPrint('Error saving book data: $e');
    }
  }

  /// **Upload a New Book**
  Future<bool> uploadBook(AboutBooks newBook) async {
    if (_books.any((book) => book.bookTitle == newBook.bookTitle)) {
      return false; // Book already exists
    }
    _books.add(newBook);
    _currentBook = newBook;
    await _saveBooksToLocal();
    notifyListeners();
    return true;
  }
}
