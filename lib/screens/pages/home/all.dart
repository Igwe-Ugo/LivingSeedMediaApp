import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/pages/home/home.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  final double _fontSize = 11;
  @override
  Widget build(BuildContext context) {
    return Consumer2<AboutBookProvider, BibleStudyProvider>(
        builder: (context, bookProvider, bibleStudyProvider, child) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Books',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'We think you will like these',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(
                        '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.moreBooksPath}'),
                    child: Text('More...',
                        style: TextStyle(
                            fontSize: _fontSize,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bookProvider.allBooks
                      .map((book) => BooksPage(about_books: book))
                      .toList(),
                )),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bible Study Materials',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'We think you will like these',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(
                        '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.moreBibleStudyPath}'),
                    child: Text('More...',
                        style: TextStyle(
                            fontSize: _fontSize,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bibleStudyProvider.allBibleStudies
                      .map((bible_study) =>
                          BibleStudyPage(bible_study: bible_study))
                      .toList(),
                )),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seminar Papers & Magazines',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'We think you will like these',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('More...',
                        style: TextStyle(
                            fontSize: _fontSize,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bookProvider.allBooks
                      .map((book) => BooksPage(about_books: book))
                      .toList(),
                )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }
}
