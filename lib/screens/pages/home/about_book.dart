import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import 'home.dart';

class AboutBook extends StatefulWidget {
  final AboutBooks about_books;
  const AboutBook({super.key, required this.about_books});

  @override
  State<AboutBook> createState() => _AboutBookState();
}

class _AboutBookState extends State<AboutBook> {
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
    if (widget.about_books.ratingReviews.isNotEmpty) {
      allReviews = widget.about_books.ratingReviews
          .map((review) => review.reviewRating.toInt())
          .reduce((a, b) => (a + b)); // sums all ratings
      ratings = widget.about_books.ratingReviews
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
                        image: AssetImage(widget.about_books.coverImage),
                      )),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Provider.of<UsersAuthProvider>(context, listen: false)
                      .addToBookCart(widget.about_books);
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
                      '₦ ${widget.about_books.amount.toString()}',
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
                          fontSize: 20.0,
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
                    widget.about_books.bookTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.about_books.author,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.about_books.aboutPreface,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    maxLines: 5,
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
                            int averageRating = widget
                                    .about_books.ratingReviews.isNotEmpty
                                ? (allReviews /
                                        widget.about_books.ratingReviews.length)
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
                      widget.about_books.ratingReviews.isNotEmpty
                          ? Text(
                              (allReviews /
                                      widget.about_books.ratingReviews.length)
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
                        if (widget.about_books != null) {
                          GoRouter.of(context).go(
                              '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.aboutBookPath}/${LivingSeedAppRouter.reviewsPath}',
                              extra: widget.about_books);
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
                    height: 20,
                  ),
                  const Text("What's it about?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.about_books.aboutBook,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: more == false ? 5 : 30,
                    textAlign: TextAlign.justify,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          more = !more;
                        });
                      },
                      child: Text(
                        more == false ? 'see more...' : 'see less...',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Who's it about?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.about_books.whoseAbout,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Have ${widget.about_books.chapterNum} Chapters',
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
                    itemCount: widget.about_books.chapters
                        .length, // Loops through list of maps
                    itemBuilder: (context, index) {
                      Map<String, String> chapterMap =
                          widget.about_books.chapters[index]; // Get Map

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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Who is the author?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.about_books.aboutAuthor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text("Recommended for you",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          BooksPage(
                            about_books: widget.about_books,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        )
      ],
    )));
  }
}
