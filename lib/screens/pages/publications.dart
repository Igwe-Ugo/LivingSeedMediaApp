import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/publications/publications.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AboutBooks> books = [];
  List<AboutBooks> filteredBooks = [];
  List<String> choices = [
    'All',
    'Books',
    'Magazines',
    'Bible study materials',
    'Seminar papers',
  ];

  List<IconData> iconChoices = [
    Icons.all_inbox_outlined,
    Iconsax.book,
    Iconsax.book_1,
    Iconsax.book_15,
    Icons.auto_stories_outlined,
  ];

  String? selectedValue;

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
    debugPrint(value);
  }

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(_filterBooks);
  }

  void _filterBooks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books
          .where((book) =>
              book.bookTitle.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _loadBooks() async {
    books = await Provider.of<AboutBookProvider>(context, listen: false)
        .booksFuture!; // load books from json
    setState(() {
      filteredBooks = books; // initially, all books are displayed
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBooks);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UsersAuthProvider>(context, listen: false).userData;

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/LSeed-Logo-1.png',
                      scale: 5,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Publications',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () => GoRouter.of(context).go(
                        '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.notificationPath}', extra: user),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          const Icon(Iconsax.message),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '2',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome\n${user!.fullname}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Playfair',
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(user.userImage),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).disabledColor.withOpacity(0.15),
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search for title, authors, topics...',
                  prefixIcon: const Icon(Iconsax.book_1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_searchController.text.isEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Categories',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ),
              InlineChoice<String>.single(
                clearable: true,
                value: selectedValue,
                onChanged: setSelectedValue,
                itemCount: choices.length,
                itemBuilder: (state, i) {
                  return ChoiceChip(
                    avatar: Icon(iconChoices[i],
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    side: const BorderSide(style: BorderStyle.none),
                    selected: state.selected(choices[i]),
                    onSelected: state.onSelected(choices[i]),
                    label: Text(
                      choices[i],
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                  );
                },
                listBuilder: ChoiceList.createWrapped(
                  spacing: 5,
                  runSpacing: 5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (selectedValue == 'All')
                const AllPage()
              else if (selectedValue == 'Books')
                const Books()
              else
                const AllPage()
            ],
            if (_searchController.text.isNotEmpty) ...[
              // show search results only when a user is typing...
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.9, // Adjust height
                child: filteredBooks.isEmpty
                    ? Column(
                        children: const [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.not_interested_rounded,
                            size: 70,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Sorry, No matching books found!",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () => GoRouter.of(context).go(
                                    '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.aboutBookPath}',
                                    extra: book),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                            ),
                                            child: Image.asset(
                                              book.coverImage,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    book.bookTitle,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0),
                                                  ),
                                                  Text(
                                                    book.author,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                'N${book.amount.toString()}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.0),
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
                        },
                      ),
              ),
            ]
          ],
        ),
      ),
    ));
  }
}
