import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class LivingSeedNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const LivingSeedNavBar({super.key, required this.navigationShell});

  @override
  State<LivingSeedNavBar> createState() => _LivingSeedNavBarState();
}

class _LivingSeedNavBarState extends State<LivingSeedNavBar> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = widget.navigationShell.currentIndex;
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 70,
        elevation: 0,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'Publications',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user),
            label: 'Account',
          )
        ],
      ),
    );
  }
}
