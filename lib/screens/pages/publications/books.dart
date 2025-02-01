// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widget.dart';
import '../../models/models.dart';
import '../services/services.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  late Future<List<AboutBooks>> aboutBooksFuture;

  @override
  void initState() {
    super.initState();
    aboutBooksFuture = loadAboutBook();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: aboutBooksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading books"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No books found"));
        }
        List<AboutBooks> about_books = snapshot.data!;
        return Column(
          children: about_books
              .map((books) => buildBooks(context, about_books: books))
              .toList(),
        );
      },
    );
  }

  Widget buildBooks(BuildContext context, {required AboutBooks about_books}) {
    return Column(
      children: [
        InkWell(
          onTap: () => GoRouter.of(context).go(
              '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.aboutBookPath}'),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Image.asset(
                        about_books.coverImage,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              about_books.bookTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              about_books.author,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              about_books.rating.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 12,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 12,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 12,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 12,
                            ),
                            const Icon(
                              Icons.star_outline,
                              color: Colors.deepOrange,
                              size: 12,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          about_books.amount,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                        ),
                        Text(
                          about_books.productionDate.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 0.4,
        )
      ],
    );
  }
}
