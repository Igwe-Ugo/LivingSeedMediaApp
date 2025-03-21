import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class AboutBibleStudy extends StatelessWidget {
  final BibleStudyMaterial about_biblestudy;
  const AboutBibleStudy({super.key, required this.about_biblestudy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 0),
          child: Row(
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
                width: 20,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    about_biblestudy.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Playfair'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 130,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(about_biblestudy.coverImage),
                      )),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Provider.of<UsersAuthProvider>(context, listen: false)
                      .addToBibleStudyCart(about_biblestudy);
                  Users user =
                      Provider.of<UsersAuthProvider>(context, listen: false)
                          .userData!;
                  NotificationItems newNotification = NotificationItems(
                    notificationImage: about_biblestudy.coverImage,
                    notificationTitle: 'Bible Study Material added to cart',
                    notificationMessage:
                        'A bible study material with the name: ${about_biblestudy.title} has been added to your cart item. You can view it in your cart session. You have done a great job by uplisting this in your purchases, do well to purchase!',
                    notificationDate:
                        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                    notificationTime:
                        "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
                  );
                  Provider.of<NotificationProvider>(context, listen: false)
                      .sendPersonalNotification(
                          user.emailAddress, newNotification);
                  showMessage(
                      'Bible study material has been added to Cart', context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  minimumSize: const Size(10, 60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₦ ${about_biblestudy.amount.toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 17.0,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 17.0,
                          color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 17,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Add to Cart',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 17.0,
                            color: Colors.white),
                        textAlign: TextAlign.start),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    about_biblestudy.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    about_biblestudy.subTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).disabledColor.withOpacity(0.4),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Have ${about_biblestudy.chapterNum} Chapters',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: about_biblestudy.contents.length,
                    itemBuilder: (context, index) {
                      var chapters = about_biblestudy.contents[index];
                      return Container(
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 15),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          horizontalTitleGap: 0,
                          minLeadingWidth: 25,
                          contentPadding: EdgeInsets.all(0),
                          leading: Text(chapters.chapterNum.toString()),
                          title: Text(chapters.chapterTitle,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    )));
  }
}
