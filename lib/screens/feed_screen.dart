import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:instagram_clone/theme.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/instagram_icon.svg',
          color: primaryColor,
          height: 32.0,
        ),
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.messenger_outline,
            ),
          )
        ],
      ),
      body: const PostCard(),
    );
  }
}
