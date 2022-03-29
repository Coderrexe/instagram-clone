import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

// Methods for uploading data to Firebase Storage.
class StorageMethods {
  // Entry point to the Firebase Storage SDK.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Entry point to the Firebase Authentication SDK.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add image to Firebase storage.
  Future<String> uploadImageToStorage(
    String folderName,
    Uint8List image,
    bool isPost,
  ) async {
    // File system for profile pictures:
    // gs://app-name.appspot.com/profilePictures/UID
    Reference reference =
        _storage.ref().child(folderName).child(_auth.currentUser!.uid);
    // File system for posts:
    // gs://app-name.appspot.com/posts/UID/postID
    if (isPost) {
      String postId = const Uuid().v1();
      reference = reference.child(postId);
    }
    UploadTask uploadTask = reference.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
