import 'package:flutter/material.dart';

class CustomToolTip extends StatelessWidget {
  final Widget child;
  final Widget content;

  const CustomToolTip({super.key, required this.child, required this.content});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'wefwefwefcwef',
      preferBelow: false,
      verticalOffset: 20,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {}, // Optional: Add actions when tapped
        child: Stack(
          alignment: Alignment.center,
          children: [
            child,
            Positioned(
              bottom: 30,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
