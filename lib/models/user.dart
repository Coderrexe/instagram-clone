import 'package:cloud_firestore/cloud_firestore.dart';

// Model of a user, to be reused within the codebase.
class AppUser {
  const AppUser({
    required this.email,
    required this.uid,
    required this.profilePictureUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  final String email;
  final String uid;
  final String profilePictureUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  // Function for converting AppUser model to JSON information, to be stored
  // in Firebase database.
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following,
        'profilePictureUrl': profilePictureUrl,
      };

  // Function for converting user information in DocumentSnapshot to
  // AppUser model.
  static AppUser fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return AppUser(
      email: snapshotData['email'],
      uid: snapshotData['uid'],
      profilePictureUrl: snapshotData['profilePictureUrl'],
      username: snapshotData['username'],
      bio: snapshotData['bio'],
      followers: snapshotData['followers'],
      following: snapshotData['following'],
    );
  }
}
