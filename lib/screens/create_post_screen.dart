import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/services/firestore_methods.dart';
import 'package:instagram_clone/services/utils.dart';
import 'package:instagram_clone/theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // The user's selected photo to be posted.
  Uint8List? _post;

  // Whether to show loading animation for this page.
  bool _isLoading = false;

  // TextEditingController class helps us handle changes to a text field.
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  // Show a pop-up menu for the user to choose how to upload post.
  void _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickImage(ImageSource.camera);
                setState(() {
                  _post = file;
                });
              },
              child: const Text('Take a photo'),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickImage(ImageSource.gallery);
                setState(() {
                  _post = file;
                });
              },
              child: const Text('Choose from gallery'),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void postImage(
    String uid,
    String username,
    String profilePicture,
  ) async {
    // Start loading animation.
    setState(() {
      _isLoading = true;
    });
    await FirestoreMethods()
        .uploadPost(
      uid,
      _descriptionController.text,
      _post!,
      username,
      profilePicture,
    )
        .then((value) {
      if (value.runtimeType == Post) {
        showSnackBar(
          context: context,
          text: 'Posted successfully!',
        );
        setState(() {
          _post = null;
          _isLoading = false;
        });
      } else if (value.runtimeType == String) {
        showSnackBar(
          context: context,
          text: 'Something went wrong!',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the information of the current logged-in user.
    final AppUser user = Provider.of<UserProvider>(context).getUser;

    return _post == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _post = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Create post'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user.uid,
                    user.username,
                    user.profilePictureUrl,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading ? const LinearProgressIndicator() : Container(),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePictureUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_post!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
