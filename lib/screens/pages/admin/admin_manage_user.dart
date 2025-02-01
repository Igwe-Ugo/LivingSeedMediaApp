import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AdminUserManagement extends StatelessWidget {
  const AdminUserManagement({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return CustomUserTile(
                    imageUrl: 'assets/images/profile.png',
                    name: 'Elijah Nwamadi',
                    email: 'elijahnwamadi1@gmail.com',
                    isAdmin: true,
                    onOptionSelected: (p0) {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomUserTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String email;
  final bool isAdmin;
  final Function(String) onOptionSelected;

  const CustomUserTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.email,
    this.isAdmin = false,
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
          // Leading: User Image
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(imageUrl),
          ),

          const SizedBox(width: 10),

          // Title and Subtitle
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
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Badge for Admins
                if (isAdmin)
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
          // Dropdown Menu
          DropdownButton<String>(
            elevation: 5,
            onChanged: (value) {
              if (value != null) {
                onOptionSelected(value);
              }
            },
            icon: const Icon(Icons.more_vert),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: 'view',
                child: Text('View Details'),
              ),
              DropdownMenuItem(
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
