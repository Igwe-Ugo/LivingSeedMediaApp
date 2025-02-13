import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  final TextEditingController _searchUserController = TextEditingController();
  List<Users> users = [];
  List<Users> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _searchUserController.addListener(_filterUsers);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUsers();
  }

  void _filterUsers() {
    String query = _searchUserController.text.toLowerCase();
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.fullname.toLowerCase().contains(query) ||
              user.emailAddress.toLowerCase().contains(query) ||
              user.telephone.contains(query))
          .toList();
    });
  }

  void _loadUsers() {
    users = Provider.of<UsersAuthProvider>(context).allUsers;
    setState(() {
      filteredUsers = users;
    });
  }

  @override
  void dispose() {
    _searchUserController.removeListener(_filterUsers);
    _searchUserController.dispose();
    super.dispose();
  }

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
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).disabledColor.withOpacity(0.15),
                ),
              ),
              child: TextField(
                controller: _searchUserController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search for any user...',
                  prefixIcon: const Icon(Iconsax.user_search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_searchUserController.text.isEmpty) ...[
              Expanded(
                  child: Column(
                children: allUsers
                    .map((users) => CustomUserTile(
                          user: users,
                          telephone: users.telephone,
                          imageUrl: users.userImage,
                          name: users.fullname,
                          email: users.emailAddress,
                          onOptionSelected: (po) {},
                          isAdmin: users.role,
                        ))
                    .toList(),
              ))
            ] else if (_searchUserController.text.isNotEmpty) ...[
              // show search results only when entry is typed...
              filteredUsers.isEmpty
                  ? Center(
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.not_interested_rounded,
                            size: 70,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Sorry, No User found with this identity!",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                      children: filteredUsers
                          .map((filteredUser) => CustomUserTile(
                                user: filteredUser,
                                telephone: filteredUser.telephone,
                                imageUrl: filteredUser.userImage,
                                name: filteredUser.fullname,
                                email: filteredUser.emailAddress,
                                onOptionSelected: (po) {},
                                isAdmin: filteredUser.role,
                              ))
                          .toList(),
                    ))
            ]
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
  final String telephone;
  final Function(String) onOptionSelected;

  const CustomUserTile({
    super.key,
    required this.user,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.telephone,
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
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  telephone,
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
                  child: Text(
                    'Make Admin',
                    overflow: TextOverflow.ellipsis,
                  ),
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
                  child: Text(
                    'Remove Admin',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              DropdownMenuItem(
                onTap: () {
                  Provider.of<UsersAuthProvider>(context).deleteUser(name);
                  GoRouter.of(context).pop();
                  showMessage('User has been deleted!', context);
                },
                value: 'delete',
                child: Text(
                  'Delete User',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
