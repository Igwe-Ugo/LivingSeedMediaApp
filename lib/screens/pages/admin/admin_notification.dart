import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

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

  XFile? _coverImage;

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _coverImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
      final generalNotices = notificationProvider.generalNotifications;

      return SingleChildScrollView(
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
                    Column(
                      children: [
                        if (_coverImage != null)
                          Text(
                            'Image Selected',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: WidgetStatePropertyAll(0),
                          ),
                          onPressed: _pickCoverImage,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Iconsax.image,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'Upload Notification Image',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextInput(
                        label: 'Message title...',
                        controller: _notificationTitleController,
                        icon: Icons.title,
                        validator: () {}),
                    CustomTextInput(
                      label: "Message",
                      controller: _notificationMessageController,
                      isIcon: false,
                      maxLine: 10,
                      maxLength: 700,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please give details about the notification made';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(0),
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor)),
                      onPressed: () => _sendNotification(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Iconsax.message, color: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Send Notification',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
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
              Column(
                children: generalNotices
                    .map((notice) => recentNotifications(context,
                        notificationImage: notice.notificationImage,
                        notificationTitle: notice.notificationTitle,
                        notificationMessage: notice.notificationMessage,
                        notificationDate: notice.notificationDate,
                        notificationTime: notice.notificationTime,
                        notificationData: notice))
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }));
  }

  void _sendNotification() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }
    if (_coverImage!.path.isEmpty) {
      return showMessage(
          'Please share an image for this notification', context);
    }

    NotificationItems newNotification = NotificationItems(
      notificationImage: _coverImage!.path.toString(),
      notificationTitle: _notificationTitleController.text,
      notificationMessage: _notificationMessageController.text,
      notificationDate:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      notificationTime:
          "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
    );

    bool success =
        await Provider.of<NotificationProvider>(context, listen: false)
            .sendGeneralNotification(newNotification);
    if (success) {
      showMessage('Notification sent successfully!', context);
      GoRouter.of(context).pop();
    } else {
      showMessage('Notification already exists, please send a new notification',
          context);
      return;
    }
  }

  Widget recentNotifications(BuildContext context,
      {required String notificationImage,
      required String notificationTitle,
      required String notificationMessage,
      required String notificationDate,
      required String notificationTime,
      required NotificationItems notificationData}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            GoRouter.of(context).go(
                '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.dashboardPath}/${LivingSeedAppRouter.manageNotificationsPath}/${LivingSeedAppRouter.anouncementsPath}',
                extra: notificationData);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 100,
                      width: 70,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(notificationImage),
                            fit: BoxFit.fill),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notificationTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              notificationMessage,
                              maxLines: 3,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$notificationTime - $notificationDate',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 11.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  IconButton(
                    onPressed: () {
                      /* Provider.of<AdminAuthProvider>(context, listen: false)
                          .deleteGeneralNotification(notificationTitle); */
                      showMessage('Notification Deleted!', context);
                    },
                    icon: Icon(
                      Iconsax.trash,
                      color: Colors.red,
                      semanticLabel: 'delete notification',
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
  }
}
