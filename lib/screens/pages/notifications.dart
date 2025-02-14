import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/pages/notices/notices.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    // Ensure notifications loads only once...
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsersAuthProvider>(context, listen: false)
          .userData
          ?.emailAddress;
      Provider.of<AdminAuthProvider>(context, listen: false)
          .initializeNotifications(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminAuthProvider>(
        builder: (context, notificationProvider, child) {
      final generalNotices = notificationProvider.generalNotices;
      final personalNotices = notificationProvider.personalNotices[
              Provider.of<UsersAuthProvider>(context, listen: false)
                  .userData
                  ?.emailAddress] ??
          [];
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
                    ),
                  ),
                  const SizedBox(width: 15),
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
              const SizedBox(height: 10),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicatorColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        indicator: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        tabs: [
                          Tab(
                            child: Text(
                              'General',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Personal',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: [
                          // General Notices List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: generalNotices.length,
                            itemBuilder: (context, index) =>
                                GeneralNotices(generalNotices[index]),
                          ),

                          // Personal Notices List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: personalNotices.length,
                            itemBuilder: (context, index) {
                              return PersonalNotices(personalNotices[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
