import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/services/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/services/firestore_methods.dart';
import 'package:instagram_clone/theme.dart';
import 'package:instagram_clone/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.postData,
  }) : super(key: key);

  // Post information stored in a map.
  final Map<String, dynamic> postData;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // Whether the like animation should show.
  bool shouldLikeAnimate = false;

  // The number of comments on the post.
  int numberOfComments = 0;

  @override
  initState() {
    super.initState();
    getNumberOfComments(widget.postData['postId']);
  }

  // Method for getting the number of comments on a post.
  Future<void> getNumberOfComments(String postId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
      numberOfComments = snapshot.docs.length;
    } catch (e) {
      showSnackBar(
        context: context,
        text: e.toString(),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<UserProvider>(context).getUser;

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
                  backgroundImage:
                      NetworkImage(widget.postData['profilePicture']),
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
                          widget.postData['username'],
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
                                  onTap: () {
                                    FirestoreMethods().deletePost(
                                      widget.postData['postId'],
                                    );
                                    Navigator.of(context).pop();
                                  },
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
          GestureDetector(
            onDoubleTap: () {
              // Save the like to Firebase Firestore database.
              FirestoreMethods().likePost(
                widget.postData['postId'],
                user.uid,
                widget.postData['likes'],
              );
              // Start the like animation when a user double-clicks on a post.
              setState(() {
                shouldLikeAnimate = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.postData['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: shouldLikeAnimate ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    shouldAnimate: shouldLikeAnimate,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        shouldLikeAnimate = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Show like, comment and other IconButtons.
          Row(
            children: [
              LikeAnimation(
                shouldAnimate: widget.postData['likes'].contains(user.uid),
                likeButtonHasBeenClicked: true,
                child: IconButton(
                  onPressed: () {
                    // Save the like to Firebase Firestore database.
                    FirestoreMethods().likePost(
                      widget.postData['postId'],
                      user.uid,
                      widget.postData['likes'],
                    );
                  },
                  icon: widget.postData['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_outline),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postData: widget.postData,
                    ),
                  ),
                ),
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
                    '${widget.postData['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                widget.postData['description'] != ''
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: widget.postData['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' ${widget.postData['description']}',
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postData: widget.postData,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: numberOfComments > 0
                        ? Text(
                            numberOfComments != 1
                                ? 'View all $numberOfComments comments'
                                : 'View $numberOfComments comment',
                            style: const TextStyle(
                              color: secondaryColor,
                            ),
                          )
                        : Container(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Text(
                    // Convert Timestamp object to human-readable date.
                    DateFormat.yMMMd().format(
                      widget.postData['datePublished'].toDate(),
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
