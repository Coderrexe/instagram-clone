import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/services/storage_methods.dart';

class FirestoreMethods {
  // Entry point to the Firebase Cloud Firestore database.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Methods for uploading data to Firebase Storage.
  final StorageMethods _storageMethods = StorageMethods();

  // Method for uploading a post to the Firebase Firestore database.
  Future<Object> uploadPost(String uid, String description, Uint8List file,
      String username, String profilePictureUrl) async {
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
        profilePictureUrl: profilePictureUrl,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      return post;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  // Method for updating likes of a post to Firebase Firestore.
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        // If user has already liked the post before, we remove the like from
        // database.
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        // If user has not already liked the post, we add the like to database.
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Method for uploading a comment to the Firebase Firestore database.
  Future<void> postComment(
    String postId,
    String uid,
    String text,
    String username,
    String profilePictureUrl,
  ) async {
    try {
      // Generate a time-based version 1 UUID, to use as ID for the comment.
      String commentId = const Uuid().v1();
      Comment comment = Comment(
        uid: uid,
        commentId: commentId,
        text: text,
        username: username,
        likes: [],
        datePublished: DateTime.now(),
        profilePictureUrl: profilePictureUrl,
      );
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
