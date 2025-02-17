// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/pages/notices/notices.dart';
import 'package:provider/provider.dart';
import '../common/widget.dart';
import '../models/models.dart';
import 'services/services.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool switchSavedCollectionPrivate = false;
  final double _fontSize = 13.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body:
          Consumer3<UsersAuthProvider, DarkThemeProvider, NotificationProvider>(
              builder: (context, userProvider, themeChangeProvider,
                  noticeProvider, child) {
        final themeChange = themeChangeProvider;
        Users user = userProvider.userData!;
        var unreadCount = noticeProvider.getUnreadCount(user.emailAddress);
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
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
                        Text(
                          'Account',
                          style: TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                        onTap: () => GoRouter.of(context).go(
                            '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.notificationPath}',
                            extra: user),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Icon(Iconsax.message,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: NotificationBadge(count: unreadCount),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: user != null && user.userImage.isNotEmpty
                        ? Image.asset(user.userImage)
                        : Icon(Icons.person),
                  ),
                  title: Text(
                    user != null && user.userImage.isNotEmpty
                        ? user.fullname
                        : 'Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  subtitle: Text(
                    user != null && user.userImage.isNotEmpty
                        ? user.emailAddress
                        : 'Email Address',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: _fontSize,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  trailing: IconButton(
                      onPressed: () => GoRouter.of(context).go(
                          '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.profilePath}'),
                      icon: const Icon(
                        Iconsax.edit,
                        size: 20,
                      ),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Collections',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                          '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.cartPath}',
                          extra: user),
                      leading: const Icon(Icons.shopping_cart_outlined),
                      title: Text(
                        'My Cart',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                          '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.booksPurchasedPath}',
                          extra: user),
                      leading: const Icon(Iconsax.archive_book),
                      title: Text(
                        'Books Purchased',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    user != null && user.role == 'Admin'
                        ? ListTile(
                            onTap: () {
                              GoRouter.of(context).go(
                                  '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.dashboardPath}');
                            },
                            leading:
                                const Icon(Icons.admin_panel_settings_outlined),
                            title: Text(
                              'Admin',
                              style: TextStyle(
                                  fontSize: _fontSize,
                                  fontWeight: FontWeight.w700),
                            ),
                            trailing:
                                const Icon(Icons.keyboard_arrow_right_outlined),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Help  and support',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Iconsax.activity),
                      title: Text(
                        'About Livng Seed',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Iconsax.message_question),
                      title: Text(
                        'Ask a question',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.phone_in_talk_outlined),
                      title: Text(
                        'Counselling',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Iconsax.calendar),
                      title: Text(
                        'Upcoming meetings',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.sun_1),
                      title: Text(
                        'Dark mode',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: Switch(
                        activeColor: Colors.white,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        inactiveThumbColor: Colors.white,
                        value: themeChange.darkTheme,
                        trackOutlineColor: WidgetStateProperty.resolveWith(
                            (states) => Colors.transparent),
                        onChanged: (value) {
                          setState(() {
                            themeChange.darkTheme = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                          '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.changePasswordPath}'),
                      leading: const Icon(Iconsax.lock_1),
                      title: Text(
                        'Change Password',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                  decoration: BoxDecoration(
                    border: BoxBorder.lerp(
                        Border.all(color: Theme.of(context).disabledColor),
                        Border.all(color: Theme.of(context).disabledColor),
                        2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () => showLogoutDialog(context),
                    child: Text('Log out',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      }),
    );
  }
}

Future<void> showLogoutDialog(BuildContext context) {
  double _fontSize = 13.0;
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Logging out?',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to log out from your account on this device?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<UsersAuthProvider>(context, listen: false).signout();
            Navigator.of(context).pop();
            GoRouter.of(context).go(LivingSeedAppRouter.loginPath);
            showMessage('Logged Out!', context);
          },
          child: Text(
            'log out'.toUpperCase(),
            style: TextStyle(
                fontSize: _fontSize, color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'not yet'.toUpperCase(),
            style: TextStyle(
                fontSize: _fontSize, color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    ),
  );
}
