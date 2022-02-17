import 'package:flutter/material.dart';

// File containing widths of screens, used for creating responsive design.
import 'package:instagram_clone/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder helps us build responsive layout.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // If user device is web view.
          return webScreenLayout;
        } else {
          // If user device is mobile.
          return mobileScreenLayout;
        }
      },
    );
  }
}
