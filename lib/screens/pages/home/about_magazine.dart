import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/models/models.dart';

class AboutMagazine extends StatelessWidget {
  final MagazineModel magazine;

  const AboutMagazine({super.key, required this.magazine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(magazine.magazineTitle)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(magazine.coverImage, fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text(magazine.magazineTitle,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("Issue: ${magazine.issue}",
                  style: const TextStyle(fontSize: 16)),
              const Divider(),
              Text("Published by: ${magazine.publisher}",
                  style: const TextStyle(fontSize: 16)),
              Text("Publication Date: ${magazine.publicationDate}",
                  style: const TextStyle(fontSize: 16)),
              const Divider(),
              Text("Editor's Desk", style: Theme.of(context).textTheme.titleLarge),
              Text(magazine.editorsDesk.editor),
              const Divider(),
              Text("Contents", style: Theme.of(context).textTheme.titleLarge),
              Column(
                children: magazine.contents.map((chapter) {
                  return ListTile(
                    title: Text("${chapter.chapterNumber}. ${chapter.chapterTitle}"),
                    subtitle: Text("By ${chapter.chapterAuthor}"),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
