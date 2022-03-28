import 'package:cloud_firestore/cloud_firestore.dart';

// Model of a post, to be reused within the codebase.
class Post {
  const Post({
    required this.uid,
    required this.postId,
    required this.description,
    required this.username,
    required this.likes,
    required this.datePublished,
    required this.postUrl,
    required this.profilePicture,
  });

  final String uid;
  final String postId;
  final String description;
  final String username;
  final List likes;
  final DateTime datePublished;
  final String postUrl;
  final String profilePicture;

  // Function for converting Post model to JSON information, to be stored
  // in Firebase database.
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'postId': postId,
        'description': description,
        'username': username,
        'likes': likes,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profilePicture': profilePicture,
      };

  // Function for converting post information in DocumentSnapshot to Post model.
  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Post(
      uid: snapshotData['uid'],
      postId: snapshotData['postId'],
      description: snapshotData['description'],
      username: snapshotData['username'],
      likes: snapshotData['likes'],
      datePublished: snapshotData['datePublished'],
      postUrl: snapshotData['postUrl'],
      profilePicture: snapshotData['profilePicture'],
    );
  }
}
