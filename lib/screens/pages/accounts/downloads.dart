import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/models/models.dart';

class Downloads extends StatefulWidget {
  final Users user;
  const Downloads({super.key, required this.user});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    'Downloads',
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.user.downloads.length,
                itemBuilder: (context, index) {
                  var downloadsFile = widget.user.downloads[index];
                  return InkWell(
                    onTap: () {},
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                downloadsFile.mediaImage,
                                height: 100,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(downloadsFile.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(downloadsFile.speaker,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(downloadsFile.size,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Row(
                                    children: [
                                      Text(downloadsFile.date,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(downloadsFile.time,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
