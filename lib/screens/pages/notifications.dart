import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
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
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'June 1',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                ...notification(context, [
                  {
                    'imagePath': 'assets/images/mlr_2024_flier.jpeg',
                    'title': 'Payment received, thank you!',
                    'description':
                        'Your payment has been successfully approved.',
                  },
                  {
                    'imagePath': 'assets/images/mlr_2024_flier.jpeg',
                    'title': '"Money Routine" is making waves',
                    'description': '@bisoye just liked your collection'
                  },
                  {
                    'imagePath': 'assets/images/mlr_2024_flier.jpeg',
                    'title': '"Money Routine" latest review in.',
                    'description':
                        '@bisoye dropped a new review on your collection.'
                  },
                ]),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'May 24',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                ...notification(context, [
                  {
                    'imagePath': 'assets/images/mlr_2024_flier.jpeg',
                    'title': 'Payment received, thank you!',
                    'description':
                        'Your payment has been successfully approved.',
                  },
                  {
                    'imagePath': 'assets/images/mlr_2024_flier.jpeg',
                    'title': '"Money Routine" is making waves',
                    'description': '@bisoye just liked your collection'
                  },
                  {
                    'imagePath': 'assets/images/mlr_2024_flier.jpeg',
                    'title': '"Money Routine" latest review in.',
                    'description':
                        '@bisoye dropped a new review on your collection.'
                  },
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> notification(
  BuildContext context,
  List<Map<String, String>> notifications,
) {
  return notifications.map((notif) {
    return notify(
      context,
      imagePath: notif['imagePath']!,
      titleNotify: notif['title']!,
      descriptionNotify: notif['description']!,
    );
  }).toList();
}

Widget notify(
  BuildContext context, {
  required String imagePath,
  required String titleNotify,
  required String descriptionNotify,
}) {
  return ListTile(
    onTap: () {},
    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
    leading: Container(
      padding: const EdgeInsets.all(5),
      constraints: const BoxConstraints(
        minWidth: 30,
        minHeight: 30,
      ),
      child: CircleAvatar(
        radius: 15,
        child: Image.asset(imagePath),
      ),
    ),
    title: Text(
      titleNotify,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    subtitle: SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Text(
        descriptionNotify,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    ),
    trailing: const Icon(Iconsax.arrow_right, size: 17),
  );
}
