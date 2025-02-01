import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Reviews extends StatefulWidget {
  final List<RatingReview> reviewRating;
  const Reviews({super.key, required this.reviewRating});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<bool> stars = [false, false, false, false, false];
  bool showWriteReviewTextField = false;

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
                  onPressed: () => GoRouter.of(context).go(
                      '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.aboutBookPath}/${LivingSeedAppRouter.reviewsPath}/${LivingSeedAppRouter.writeReviewPath}'),
                  icon: const Icon(Iconsax.edit_2),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          '4.8',
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
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            LinearPercentIndicator(
                              barRadius: const Radius.circular(2),
                              width: MediaQuery.of(context).size.width * .5,
                              lineHeight: 6.0,
                              percent: 0.4,
                              progressColor: Colors.black45,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            LinearPercentIndicator(
                              barRadius: const Radius.circular(2),
                              width: MediaQuery.of(context).size.width * .5,
                              lineHeight: 6.0,
                              percent: 0.7,
                              progressColor: Colors.black45,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            LinearPercentIndicator(
                              barRadius: const Radius.circular(2),
                              width: MediaQuery.of(context).size.width * .5,
                              lineHeight: 6.0,
                              percent: 0.6,
                              progressColor: Colors.black45,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            LinearPercentIndicator(
                              barRadius: const Radius.circular(2),
                              width: MediaQuery.of(context).size.width * .5,
                              lineHeight: 6.0,
                              percent: 0.3,
                              progressColor: Colors.black45,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Iconsax.star1,
                              color: Colors.orange,
                              size: 12,
                            ),
                            LinearPercentIndicator(
                              barRadius: const Radius.circular(2),
                              width: MediaQuery.of(context).size.width * .5,
                              lineHeight: 6.0,
                              percent: 0.2,
                              progressColor: Colors.black45,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('2,706 Ratings',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return IconButton(
                          onPressed: null,
                          icon: Icon(
                            Iconsax.star1,
                            color: Colors.orange.withOpacity(0.5),
                            size: 30,
                          ),
                        );
                      }),
                    ),
                    Icon(
                      Icons.star_half,
                      size: 30,
                      color: Colors.orange.withOpacity(0.5),
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).disabledColor,
                ),
                Column(
                  children: widget.reviewRating.map((reviews) {
                    return ReviewsWidget(context: context, reviewText: reviews.reviewText, date: reviews.date, reviewTitle: reviews.reviewTitle, reviewer: reviews.reviewer);
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
  const ReviewsWidget({
    super.key,
    required this.context,
    required this.reviewText,
    required this.date,
    required this.reviewTitle,
    required this.reviewer,
  });

  final BuildContext context;
  final String reviewText;
  final String date;
  final String reviewTitle;
  final String reviewer;

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
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Iconsax.star1,
                      color: Colors.orange,
                      size: 12,
                    ),
                    const Icon(
                      Iconsax.star1,
                      color: Colors.orange,
                      size: 12,
                    ),
                    const Icon(
                      Iconsax.star1,
                      color: Colors.orange,
                      size: 12,
                    ),
                    const Icon(
                      Iconsax.star1,
                      color: Colors.orange,
                      size: 12,
                    ),
                    Icon(
                      Iconsax.star1,
                      color: Colors.grey.withOpacity(0.3),
                      size: 12,
                    ),
                  ],
                ),
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
