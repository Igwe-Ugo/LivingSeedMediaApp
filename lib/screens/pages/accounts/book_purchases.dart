// ignore_for_file: sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';
import 'package:path_provider/path_provider.dart';

class BooksPurchased extends StatefulWidget {
  const BooksPurchased({super.key});

  @override
  State<BooksPurchased> createState() => _BooksPurchasedState();
}

class _BooksPurchasedState extends State<BooksPurchased> {
  String pdfAssetPath = '';

  @override
  void initState() {
    super.initState();
    getFileFromAsset('assets/json/Bunyan_Grace_Abounding.pdf').then((f) {
      setState(() {
        pdfAssetPath = f.path;
        debugPrint(pdfAssetPath);
      });
    });
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/Bunyan_Grace_Abounding.pdf');
      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception('Error opening Asset file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Column(
          children: [
            Row(
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
                  width: 15,
                ),
                const Text(
                  'Book Purchases',
                  style: TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ...buildBooksPurchased(context, [
              {
                'imagePath': 'assets/images/book_frame.png',
                'date': '1905',
                'title': 'Grace Abounding to the Chiefest of Sinners',
                'author': 'John Bunyan',
                'readBookPath': pdfAssetPath,
              },
            ]),
          ],
        ),
      ),
    );
  }

  List<Widget> buildBooksPurchased(
      BuildContext context, List<Map<String, String>> booksPurchased) {
    return booksPurchased
        .map((bookPurchased) => book(
              context,
              imagePath: bookPurchased['imagePath']!,
              date: bookPurchased['date']!,
              title: bookPurchased['title']!,
              readBookPath: bookPurchased['readBookPath']!,
              author: bookPurchased['author']!,
            ))
        .toList();
  }

  Widget book(BuildContext context,
      {required String imagePath,
      required String date,
      required String title,
      required String readBookPath,
      required String author}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (pdfAssetPath != null) {
              GoRouter.of(context).go(
                  '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.booksPurchasedPath}/${LivingSeedAppRouter.readBookPath}',
                  extra: {
                    'readBookPath': readBookPath,
                  });
            }
          },
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
                      width: 70,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(imagePath), fit: BoxFit.fill),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              author,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          date,
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
