import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/screens/models/models.dart';

Future<List<AboutBooks>> loadAboutBook() async {
  try {
    String jsonString =
        await rootBundle.loadString('assets/json/about_book.json');

    // decode JSON and convert to a list of book object
    List<AboutBooks> aboutBook = AboutBooks.fromJsonList(jsonString);
    return aboutBook;
  } catch (e) {
    print('Error loading JSON: $e');
    return [];
  }
}
