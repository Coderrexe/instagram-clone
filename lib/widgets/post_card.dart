import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:instagram_clone/theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.postInfo,
  }) : super(key: key);

  // Post information stored in a map.
  final Map<String, dynamic> postInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        children: [
          // Header: shows user profile picture, username, and 3-dots icon.
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ).copyWith(right: 0.0),
            child: Row(
              children: [
                // User profile picture.
                CircleAvatar(
                  radius: 16.0,
                  backgroundImage: NetworkImage(postInfo['profilePicture']),
                ),
                // Username text.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postInfo['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 3-dots icon to show options.
                IconButton(
                  onPressed: () {
                    // Pop-up dialog when user clicks the 3-dots icon on post,
                    // to show options to edit, delete, etc.
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (text) => InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 16.0,
                                    ),
                                    child: Text(text),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          // Show image of the post.
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              postInfo['postUrl'],
              fit: BoxFit.cover,
            ),
          ),
          // Show like, comment and other IconButtons.
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_outline),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_outline),
                  ),
                ),
              ),
            ],
          ),
          // Show description of the post, and the number of comments.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${postInfo['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                postInfo['description'] != ''
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: postInfo['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' ${postInfo['description']}',
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'View all 69 comments',
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Text(
                    // Convert Timestamp object to human-readable date.
                    DateFormat.yMMMd().format(
                      postInfo['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
