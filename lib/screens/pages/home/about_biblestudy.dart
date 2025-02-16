import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class AboutBibleStudy extends StatefulWidget {
  final BibleStudyMaterial about_biblestudy;
  const AboutBibleStudy({super.key, required this.about_biblestudy});

  @override
  State<AboutBibleStudy> createState() => _AboutBibleStudyState();
}

class _AboutBibleStudyState extends State<AboutBibleStudy> {
  bool more = false;
  late int allReviews;
  Color filledColor = Colors.orange.withOpacity(0.7);
  Color unfilledColor = Colors.grey;
  double starSize = 30.0;
  late Map<int, int> ratingCount;
  late int totalReviews;
  List<int>? ratings;

  @override
  void initState() {
    super.initState();
    if (widget.about_biblestudy.ratingReviews.isNotEmpty) {
      allReviews = widget.about_biblestudy.ratingReviews
          .map((review) => review.reviewRating.toInt())
          .reduce((a, b) => (a + b)); // sums all ratings
      ratings = widget.about_biblestudy.ratingReviews
          .map((rating) => rating.reviewRating.toInt())
          .toList();
    } else {
      allReviews = 0;
      ratings = [];
    }
    _calculateRatings();
  }

  void _calculateRatings() {
    // Initialize map to store counts for each star (1-5)
    ratingCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    if (ratings!.isNotEmpty) {
      // Count occurrences of each rating
      for (int rating in ratings!) {
        ratingCount[rating] = (ratingCount[rating] ?? 0) + 1;
      }
    }

    // Get total number of reviews
    totalReviews = widget.about_biblestudy.ratingReviews.length;
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
            children: [
              IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: const Icon(
                    Iconsax.arrow_left_2,
                    size: 17,
                  )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    widget.about_biblestudy.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Playfair'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 130,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(widget.about_biblestudy.coverImage),
                      )),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Provider.of<UsersAuthProvider>(context, listen: false)
                      .addToBibleStudyCart(widget.about_biblestudy);
                  showMessage('Book has been added to Cart', context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  minimumSize: const Size(10, 60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₦ ${widget.about_biblestudy.amount.toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Add to Cart',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18.0,
                            color: Colors.white),
                        textAlign: TextAlign.start),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.about_biblestudy.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.about_biblestudy.subTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).disabledColor.withOpacity(0.4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            int averageRating =
                                widget.about_biblestudy.ratingReviews.isNotEmpty
                                    ? (allReviews /
                                            widget.about_biblestudy
                                                .ratingReviews.length)
                                        .floor()
                                    : 0; // Default to 0 if there are no reviews

                            if (index < averageRating) {
                              // filled
                              return Icon(
                                Iconsax.star1,
                                color: filledColor,
                                size: starSize,
                              );
                            } else if (index <
                                (allReviews /
                                    widget.about_biblestudy.ratingReviews
                                        .length)) {
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
                      widget.about_biblestudy.ratingReviews.isNotEmpty
                          ? Text(
                              (allReviews /
                                      widget.about_biblestudy.ratingReviews
                                          .length)
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              '0',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        if (widget.about_biblestudy != null) {
                          GoRouter.of(context).go(
                              '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.aboutBibleStudyPath}/${LivingSeedAppRouter.reviewsBibleStudyPath}',
                              extra: widget.about_biblestudy);
                        }
                      },
                      child: Text(
                        'See Reviews',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).disabledColor.withOpacity(0.4),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Have ${widget.about_biblestudy.chapterNum} Chapters',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Prevents scrolling conflicts
                    itemCount: widget.about_biblestudy.contents
                        .length, // Loops through list of maps
                    itemBuilder: (context, index) {
                      Map<String, String> chapterMap =
                          widget.about_biblestudy.contents[index]; // Get Map

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: chapterMap.entries.map((entry) {
                          return Container(
                            margin: const EdgeInsets.all(7),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 10),
                              child: Text(
                                "${entry.key}: ${entry.value}", // Displays "Chapter 1: God's Great Offer"
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    )));
  }
}
