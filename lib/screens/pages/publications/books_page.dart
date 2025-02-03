import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';
import 'package:livingseed_media/screens/models/models.dart';

class BooksPage extends StatefulWidget {
  final AboutBooks about_books;
  const BooksPage({super.key, required this.about_books});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late int allReviews;
  Color filledColor = Colors.orange.withOpacity(0.7);
  Color unfilledColor = Colors.grey;
  double starSize = 12.0;
  late Map<int, int> ratingCount;
  late int totalReviews;
  late List<int> ratings;

  @override
  void initState() {
    super.initState();
    if (widget.about_books.ratingReviews.isNotEmpty) {
      allReviews = widget.about_books.ratingReviews
          .map((review) => review.reviewRating.toInt())
          .reduce((a, b) => (a + b)); // sums all ratings
      ratings = widget.about_books.ratingReviews
          .map((rating) => rating.reviewRating.toInt())
          .toList();
    } else {
      allReviews = 0;
    }
    _calculateRatings();
  }

  void _calculateRatings() {
    // Initialize map to store counts for each star (1-5)
    ratingCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    // Count occurrences of each rating
    for (int rating in ratings) {
      ratingCount[rating] = (ratingCount[rating] ?? 0) + 1;
    }

    // Get total number of reviews
    totalReviews = widget.about_books.ratingReviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return _bookGridView(context);
  }

  Widget _bookGridView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(
            '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.aboutBookPath}',
            extra: widget.about_books);
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        width: 130,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  color: Theme.of(context).canvasColor,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(widget.about_books.coverImage))),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.about_books.bookTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    widget.about_books.author,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        (allReviews / widget.about_books.ratingReviews.length)
                            .toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            if (index <
                                (allReviews /
                                        widget.about_books.ratingReviews.length)
                                    .floor()) {
                              // filled
                              return Icon(
                                Iconsax.star1,
                                color: filledColor,
                                size: starSize,
                              );
                            } else if (index <
                                (allReviews /
                                    widget.about_books.ratingReviews.length)) {
                              // halffilled
                              return Icon(
                                Icons.star_half,
                                color: filledColor,
                                size: starSize,
                              );
                            } else {
                              // unfilled
                              return Icon(
                                Iconsax.star1,
                                color: unfilledColor,
                                size: starSize,
                              );
                            }
                          })),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
