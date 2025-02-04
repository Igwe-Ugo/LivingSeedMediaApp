import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';
import '../../models/models.dart';
import '../services/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Users? user = Provider.of<UsersAuthProvider>(context).userData;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                    'Profile',
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
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      child: Image.asset(user!.userImage),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Change Profile Picture',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile Information',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                title: Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.fullname,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Iconsax.arrow_right_34),
              ),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Information',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const ListTile(
                title: Text(
                  'PH Code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'EBE20-M250482',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Iconsax.copy),
              ),
              ListTile(
                title: Text(
                  'E-mail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.emailAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Iconsax.arrow_right_34),
              ),
              ListTile(
                title: Text(
                  'Gender',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.gender,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.dateOfBirth,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Iconsax.arrow_right_34),
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              Center(
                  child: TextButton(
                      onPressed: () => showDeleteDialog(context),
                      child: const Text(
                        'Close Account',
                        style: TextStyle(color: Colors.red),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showDeleteDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Delete Account?',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: const SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to delete your account with us?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            GoRouter.of(context).go(LivingSeedAppRouter.signUpPath);
            showMessage('Account has been deleted!', context);
          },
          child: Text(
            'delete account'.toUpperCase(),
            style: const TextStyle(fontSize: 13, color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'not yet'.toUpperCase(),
            style:
                TextStyle(fontSize: 13, color: Theme.of(context).disabledColor),
          ),
        ),
      ],
    ),
  );
}
