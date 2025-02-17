// notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            ),
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).brightness == Brightness.dark
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
                    color: Theme.of(context).brightness == Brightness.dark
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Consumer2<UsersAuthProvider, NotificationProvider>(
          builder: (context, userProvider, notificationProvider, child) {
            var user = userProvider.userData!;
            return TabBarView(
              children: [
                // General Notifications Tab
                _buildNotificationsList(
                    notificationProvider.generalNotifications,
                    'No general notifications',
                    user.emailAddress),
                // Personal Notifications Tab
                _buildNotificationsList(
                    user.emailAddress != null
                        ? notificationProvider
                                .personalNotifications[user.emailAddress] ??
                            []
                        : [],
                    'No personal notifications',
                    user.emailAddress),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItems> notifications,
      String emptyMessage, String userEmail) {
    return notifications.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          )
        : ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCard(
                notification: notification,
                userEmail: userEmail,
              );
            },
          );
  }
}

// notification_card.dart
class NotificationCard extends StatelessWidget {
  final NotificationItems notification;
  final String? userEmail;

  const NotificationCard(
      {super.key, required this.notification, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          Provider.of<NotificationProvider>(context, listen: false)
              .markAsRead(notification, userEmail);
          GoRouter.of(context).go(
              '${LivingSeedAppRouter.homePath}/${LivingSeedAppRouter.notificationPath}/${LivingSeedAppRouter.noticesPath}',
              extra: notification);
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: notification.isRead
            ? Colors.transparent
            : Theme.of(context).primaryColor.withAlpha(70),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    notification.notificationImage,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.notification_important, size: 40);
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.notificationTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              notification.notificationDate,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notification.notificationTime,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.notificationMessage,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
