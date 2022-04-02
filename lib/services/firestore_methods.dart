import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/services/storage_methods.dart';

class FirestoreMethods {
  // Entry point to the Firebase Cloud Firestore database.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Methods for uploading data to Firebase Storage.
  final StorageMethods _storageMethods = StorageMethods();

  Future<Object> uploadPost(String uid, String description, Uint8List file,
      String username, String profilePicture) async {
    try {
      String postUrl =
          await _storageMethods.uploadImageToStorage('posts', file, true);
      // Generate a time-based version 1 UUID, to use as ID for the post.
      String postId = const Uuid().v1();

      Post post = Post(
        uid: uid,
        postId: postId,
        description: description,
        username: username,
        likes: [],
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profilePicture: profilePicture,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      return post;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
