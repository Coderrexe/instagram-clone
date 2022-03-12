// Model of a user, to be reused within the codebase.
class AppUser {
  const AppUser({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'email': email,
    'bio': bio,
    'followers': followers,
    'following': following,
    'profilePictureUrl': photoUrl,
  };
}
