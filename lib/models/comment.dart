import 'package:cloud_firestore/cloud_firestore.dart';

// Model of a comment, to be reused within the codebase.
class Comment {
  const Comment({
    required this.uid,
    required this.commentId,
    required this.text,
    required this.username,
    required this.likes,
    required this.datePublished,
    required this.profilePictureUrl,
  });

  final String uid;
  final String commentId;
  final String text;
  final String username;
  final List likes;
  final DateTime datePublished;
  final String profilePictureUrl;

  // Function for converting Post model to JSON information, to be stored
  // in Firebase database.
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'postId': commentId,
    'text': text,
    'username': username,
    'likes': likes,
    'datePublished': datePublished,
    'profilePictureUrl': profilePictureUrl,
  };

  // Function for converting post information in DocumentSnapshot to Post model.
  static Comment fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Comment(
      uid: snapshotData['uid'],
      commentId: snapshotData['commentId'],
      text: snapshotData['text'],
      username: snapshotData['username'],
      likes: snapshotData['likes'],
      datePublished: snapshotData['datePublished'],
      profilePictureUrl: snapshotData['profilePictureUrl'],
    );
  }
}
