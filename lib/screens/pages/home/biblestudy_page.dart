import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';
import 'package:livingseed_media/screens/models/models.dart';

class BibleStudyPage extends StatelessWidget {
  final BibleStudyMaterial bible_study;
  const BibleStudyPage({super.key, required this.bible_study});

  @override
  Widget build(BuildContext context) {
    return _bookGridView(context);
  }

  Widget _bookGridView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (bible_study != null) {
          GoRouter.of(context).go(
              '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.aboutBibleStudyPath}',
              extra: bible_study);
        }
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
                      image: AssetImage(bible_study.coverImage))),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bible_study.title,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
