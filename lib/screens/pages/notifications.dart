// notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  final String? userEmail; // Pass the current user's email

  const Notifications({super.key, this.userEmail});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen initializes
    Provider.of<NotificationProvider>(context, listen: false)
        .loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Personal'),
            ],
          ),
        ),
        body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            return TabBarView(
              children: [
                // General Notifications Tab
                _buildNotificationsList(
                  notificationProvider.generalNotifications,
                  'No general notifications',
                ),

                // Personal Notifications Tab
                _buildNotificationsList(
                  widget.userEmail != null
                      ? notificationProvider
                              .personalNotifications[widget.userEmail] ??
                          []
                      : [],
                  'No personal notifications',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
      List<NotificationItems> notifications, String emptyMessage) {
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
              return NotificationCard(notification: notification);
            },
          );
  }
}

// notification_card.dart
class NotificationCard extends StatelessWidget {
  final NotificationItems notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notification.notificationTime,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
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
    );
  }
}
