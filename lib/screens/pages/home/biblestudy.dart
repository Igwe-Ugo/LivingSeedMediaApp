// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';
import '../../models/models.dart';
import '../services/bible_study_services.dart';

class BibleStudy extends StatelessWidget {
  const BibleStudy({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<BibleStudyProvider>(context, listen: false)
          .bibleStudyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading books"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No books found"));
        }
        List<BibleStudyMaterial> bibleStudy = snapshot.data!;
        return Column(
          children: bibleStudy
              .map(
                  (bible_study) => buildBibleStudy(context, bibleStudy: bible_study))
              .toList(),
        );
      },
    );
  }

  Widget buildBibleStudy(BuildContext context,
      {required BibleStudyMaterial bibleStudy}) {
    return Column(
      children: [
        InkWell(
          onTap: () => GoRouter.of(context).go(
              '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.aboutBibleStudyPath}',
              extra: bibleStudy),
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
                        bibleStudy.coverImage,
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
                        Text(
                          bibleStudy.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        buildStarRating(bibleStudy.ratingReviews),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'N${bibleStudy.amount.toString()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
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

  Widget buildStarRating(List<ReviewRating> ratingReviews) {
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
