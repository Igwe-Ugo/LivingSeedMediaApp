import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';
import 'package:livingseed_media/screens/pages/publications/publications.dart';

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  final TextEditingController _searchController = TextEditingController();
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
  Widget build(BuildContext context) {
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
                        '${LivingSeedAppRouter.publicationsPath}/${LivingSeedAppRouter.notificationPath}'),
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Categories',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
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
        ),
      ),
    ));
  }
}
