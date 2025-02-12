import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

class AdminUserManagement extends StatelessWidget {
  const AdminUserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    List<Users>? allUsers = Provider.of<UsersAuthProvider>(context).allUsers;

    return Scaffold(
      body: Padding(
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
                  'Manage Users',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Members List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {}, icon: Icon(Iconsax.search_normal))
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Column(
              children: allUsers
                  .map((users) => CustomUserTile(
                        user: users,
                        imageUrl: users.userImage,
                        name: users.fullname,
                        email: users.emailAddress,
                        onOptionSelected: (po) {},
                        isAdmin: users.role,
                      ))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }
}

class CustomUserTile extends StatelessWidget {
  final Users user;
  final String imageUrl;
  final String name;
  final String email;
  final String isAdmin;
  final Function(String) onOptionSelected;

  const CustomUserTile({
    super.key,
    required this.user,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Badge for Admins
                if (isAdmin == 'Admin')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          DropdownButton<String>(
            elevation: 5,
            onChanged: (value) {
              if (value != null) {
                onOptionSelected(value);
              }
            },
            icon: const Icon(Icons.more_vert),
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: 'view',
                child: Text('View Details'),
                onTap: () {
                  GoRouter.of(context).go(
                      '${LivingSeedAppRouter.accountPath}/${LivingSeedAppRouter.dashboardPath}/${LivingSeedAppRouter.manageUsersPath}/${LivingSeedAppRouter.userProfilePath}',
                      extra: user);
                },
              ),
              if (isAdmin != 'Admin')
                DropdownMenuItem(
                  onTap: () {
                    Provider.of<UsersAuthProvider>(context, listen: false)
                        .makeAdmin(email);
                    showMessage('User has been made an Admin', context);
                  },
                  value: 'admin',
                  child: Text('Make Admin'),
                ),
              if (isAdmin == 'Admin')
                DropdownMenuItem(
                  onTap: () {
                    Provider.of<UsersAuthProvider>(context, listen: false)
                        .removeAdmin(email);
                    showMessage(
                        'User has been removed from being an Admin', context);
                  },
                  value: 'remove_admin',
                  child: Text('Remove Admin'),
                ),
              DropdownMenuItem(
                onTap: () {
                  Provider.of<UsersAuthProvider>(context).deleteUser(name);
                  GoRouter.of(context).pop();
                  showMessage('User has been deleted!', context);
                },
                value: 'delete',
                child: Text('Delete User'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
