import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/models/models.dart';
import '../common/widget.dart';
import 'services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<AboutBooks>> aboutBooksFuture;

  @override
  void initState() {
    super.initState();
    aboutBooksFuture = loadAboutBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: aboutBooksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading books"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No books found"));
            }

            return Column(
              children: [
                // Header Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/LSeed-Logo-1.png',
                            scale: 2.3,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            'Living Seed Media',
                            style: TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Welcome\nElijah Nwamadi',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Playfair',
                            ),
                          ),
                          InkWell(
                            onTap: () => GoRouter.of(context)
                                .go(LivingSeedAppRouter.dashboardPath),
                            child: CircleAvatar(
                              radius: 25,
                              child: Image.asset('assets/images/avatar.png'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.15),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            hintText:
                                'Search for books, videos, or messages...',
                            prefixIcon: const Icon(Iconsax.search_favorite_1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Books Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SectionTitle(title: 'Books'),
                            TextButton(
                              onPressed: () {},
                              child: Text('More...',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        HorizontalList(about_books: snapshot.data!),
                        const SizedBox(height: 20),
                        // Videos Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SectionTitle(title: 'Video Messages'),
                            TextButton(
                              onPressed: () {},
                              child: Text('More...',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        HorizontalList(about_books: snapshot.data!),
                        const SizedBox(height: 20),
                        // Songs Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SectionTitle(title: 'Audio Messages'),
                            TextButton(
                              onPressed: () {},
                              child: Text('More...',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        HorizontalList(about_books: snapshot.data!),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class HorizontalList extends StatelessWidget {
  final List<AboutBooks> about_books;
  const HorizontalList({super.key, required this.about_books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: about_books.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () => GoRouter.of(context).go(
                  '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.aboutBookPath}',
                  extra: about_books[index]),
              child: Container(
                height: 170,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    color: Theme.of(context).canvasColor,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(about_books[index].coverImage))),
              ),
            ),
          );
        },
      ),
    );
  }
}
