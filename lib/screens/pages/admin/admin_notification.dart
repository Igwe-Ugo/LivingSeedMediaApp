import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/show_message.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notificationTitleController =
      TextEditingController();
  final TextEditingController _notificationMessageController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Manage Notifications',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Notification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.15),
                        ),
                      ),
                      child: TextFormField(
                        controller: _notificationTitleController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Message title...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          fillColor:
                              Theme.of(context).disabledColor.withOpacity(0.2),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the title of the notification';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.15),
                        ),
                      ),
                      child: TextFormField(
                        controller: _notificationMessageController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          fillColor:
                              Theme.of(context).disabledColor.withOpacity(0.2),
                        ),
                        maxLines: 10,
                        maxLength: 300,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please give details about the notification made';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                      onPressed: () {
                        showMessage('Notification Sent!', context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Iconsax.message,
                                color: Colors.white
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Send Notification',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Text(
                'Recent Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        child: Image.asset('assets/images/mlr_2024_flier.jpeg'),
                      ),
                    ),
                    title: Text(
                      'Notification ${index + 1}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle:
                        const Text('This is a sample notification message.'),
                    trailing: IconButton(
                      icon: const Icon(Iconsax.trash, color: Colors.red),
                      onPressed: () {
                        showMessage('Notification Deleted!', context);
                      },
                    ),
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
