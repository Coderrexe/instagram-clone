import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:instagram_clone/screens/user_auth/signup_screen.dart';
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
      // StreamBuilder rebuilds app every time there is a new event from stream.
      // In this case, we want the app to update the feed page every time a new
      // post is posted.
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          // Show loading animation if posts are still loading.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          // Once all the posts are loaded in, display them.
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              postData:
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
            ),
          );
        },
      ),
    );
  }
}
