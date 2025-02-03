// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
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
              '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.aboutBookPath}',
              extra: about_books),
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
                        buildStarRating(about_books.ratingReviews),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'N${about_books.amount.toString()}',
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

  Widget buildStarRating(List<RatingReview> ratingReviews) {
    if (ratingReviews.isEmpty) {
      return Row(
        children: List.generate(
          5,
          (index) =>
              const Icon(Icons.star_border, color: Colors.grey, size: 16),
        ),
      );
    }

    // Compute average rating
    double averageRating =
        ratingReviews.map((r) => r.reviewRating).reduce((a, b) => a + b) /
            ratingReviews.length;

    int fullStars = averageRating.floor(); // Full stars
    bool hasHalfStar =
        (averageRating - fullStars) >= 0.5; // Check for half star
    int emptyStars =
        5 - fullStars - (hasHalfStar ? 1 : 0); // Remaining empty stars

    return Row(
      children: [
        Text(
          averageRating.toStringAsFixed(2).toString(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        // Filled Stars
        ...List.generate(
          fullStars,
          (index) => const Icon(Iconsax.star1, color: Colors.orange, size: 16),
        ),

        // Half Star (if applicable)
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.orange, size: 16),

        // Empty Stars
        ...List.generate(
          emptyStars,
          (index) =>
              const Icon(Icons.star_border, color: Colors.grey, size: 16),
        ),
      ],
    );
  }
}
