import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Reviews extends StatefulWidget {
  final AboutBooks about_books;
  const Reviews({super.key, required this.about_books});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<bool> stars = [false, false, false, false, false];
  bool showWriteReviewTextField = false;
  late int allReviews;
  Color filledColor = Colors.orange.withOpacity(0.7);
  Color unfilledColor = Colors.grey;
  double starSize = 30.0;
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: const Icon(
                      Iconsax.arrow_left_2,
                      size: 17,
                    )),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Playfair'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (widget.about_books != null) {
                      GoRouter.of(context).go(
                          '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.aboutBookPath}/${LivingSeedAppRouter.reviewsPath}/${LivingSeedAppRouter.writeReviewPath}',
                          extra: widget.about_books);
                    }
                  },
                  icon: const Icon(Iconsax.edit_2),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.about_books.bookTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Playfair'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 17),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          (allReviews / widget.about_books.ratingReviews.length)
                              .toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'out of 5',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(5, (index) {
                        int starValue =
                            5 - index; // 5-star at top, 1-star at bottom
                        int starCount = ratingCount[starValue] ?? 0;
                        double iconSize = 12.0;
                        double percentage =
                            totalReviews > 0 ? starCount / totalReviews : 0.0;
                        return Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            ...List.generate(
                                starValue,
                                (index) => Icon(Iconsax.star1,
                                    color: Colors.orange, size: iconSize)),
                            LinearPercentIndicator(
                              barRadius: const Radius.circular(2),
                              width: MediaQuery.of(context).size.width * .5,
                              lineHeight: 6.0,
                              percent: percentage,
                              progressColor: Colors.black45,
                              backgroundColor: Colors.grey[300],
                            ),
                          ],
                        );
                      }),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        '${widget.about_books.ratingReviews.length} Ratings',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      if (index <
                          (allReviews / widget.about_books.ratingReviews.length)
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
                Divider(
                  color: Theme.of(context).disabledColor,
                ),
                Column(
                  children: widget.about_books.ratingReviews.map((reviews) {
                    return ReviewsWidget(
                        context: context,
                        reviewText: reviews.reviewText,
                        date: reviews.date,
                        reviewTitle: reviews.reviewTitle,
                        rating: reviews.reviewRating.toInt(),
                        reviewer: reviews.reviewer);
                  }).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget(
      {super.key,
      required this.context,
      required this.reviewText,
      required this.date,
      required this.reviewTitle,
      required this.reviewer,
      required this.rating,
      this.filledColor = Colors.orange,
      this.unfilledColor = Colors.grey,
      this.starSize = 12.0});

  final BuildContext context;
  final String reviewText;
  final String date;
  final String reviewTitle;
  final String reviewer;
  final int rating;
  final double starSize;
  final Color filledColor;
  final Color unfilledColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviewTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(5, (index) {
                      if (index < rating.floor()) {
                        // filled
                        return Icon(
                          Iconsax.star1,
                          color: filledColor.withOpacity(0.7),
                          size: starSize,
                        );
                      } else if (index < rating) {
                        // haflfilled
                        return Icon(
                          Icons.star_half,
                          color: filledColor.withOpacity(0.7),
                          size: starSize,
                        );
                      } else {
                        return Icon(
                          Iconsax.star1,
                          color: unfilledColor,
                          size: starSize,
                        );
                      }
                    })),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '$reviewer - $date',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 11.0),
                ),
              ],
            ),
            Text(
              reviewText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 0.4,
        )
      ],
    );
  }
}
