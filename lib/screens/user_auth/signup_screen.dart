import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/services/auth_methods.dart';
import 'package:instagram_clone/services/utils.dart';
import 'package:instagram_clone/theme.dart';
import 'package:instagram_clone/screens/user_auth/login_screen.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // TextEditingController class helps us handle changes to a text field.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Create a global key that uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  // Methods for authenticating users on Firebase.
  final _authMethods = AuthMethods();

  // User's profile picture, to be updated when the user selects a picture.
  Uint8List? _profilePicture;

  // Whether or not to show loading animation.
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _profilePicture = image;
    });
  }

  void signUpUserWithEmail() async {
    // Show loading animation.
    setState(() {
      _isLoading = true;
    });
    // Check if user information are acceptable (e.g. email address is valid,
    // password is strong, username is not too long, etc.).
    if (_formKey.currentState!.validate()) {
      // Sign up user and upload information to database.
      _authMethods
          .signUpWithEmail(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        bio: _bioController.text,
        profilePicture: _profilePicture,
      )
          .then((user) async {
        // Stop loading animation.
        setState(() {
          _isLoading = false;
        });
        if (user.runtimeType == User) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              ),
            ),
          );
        } else if (user.runtimeType == String) {
          // If an error occurs, we show a snack bar.
          showSnackBar(
            context: context,
            content: 'Something went wrong.',
            label: 'Dismiss',
            backgroundColor: secondaryColor,
            textColor: primaryColor,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When the user clicks outside a text field, the app should dismiss
        // mobile keyboard and stop focusing on the text field..
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  width: double.infinity, // full width of the device
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                      // SVG Instagram logo.
                      SvgPicture.asset(
                        'assets/instagram_icon.svg',
                        color: primaryColor,
                        height: 64.0,
                      ),
                      const SizedBox(height: 64.0),
                      Stack(
                        children: [
                          _profilePicture != null
                              ? CircleAvatar(
                                  radius: 64.0,
                                  backgroundImage:
                                      MemoryImage(_profilePicture!),
                                )
                              : const CircleAvatar(
                                  radius: 64.0,
                                  backgroundImage: AssetImage(
                                      'assets/default_profile_picture.jpeg'),
                                ),
                          Positioned(
                            bottom: -10.0,
                            left: 80.0,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Text input field for username.
                            TextFieldInput(
                              textEditingController: _usernameController,
                              hintText: 'Enter your username',
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.length < 2) {
                                  return 'This username is too short.';
                                } else if (value.length > 30) {
                                  return 'This username is too long.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 24.0),
                            // Text input field for email.
                            TextFieldInput(
                              textEditingController: _emailController,
                              hintText: 'Enter your email',
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
                                  r"@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                ).hasMatch(value!)) {
                                  return null;
                                } else if (value.trim().isEmpty) {
                                  return 'Please enter an email';
                                } else {
                                  return 'This is not a valid email';
                                }
                              },
                            ),
                            const SizedBox(height: 24.0),
                            // Text input field for password.
                            TextFieldInput(
                              textEditingController: _passwordController,
                              isPassword: true,
                              hintText: 'Enter your password',
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.contains(' ')) {
                                  return 'Password must not contain spaces';
                                } else if (value.length < 6) {
                                  return 'Password must be longer than 6 '
                                      'characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 24.0),
                            // Text input field for bio.
                            TextFieldInput(
                              textEditingController: _bioController,
                              hintText: 'Enter your bio',
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.length > 150) {
                                  return 'This bio is too long.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 24.0),
                          ],
                        ),
                      ),
                      // Login button.
                      InkWell(
                        onTap: signUpUserWithEmail,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                            color: blueColor,
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                      // Transitioning to sign up screen.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Text('Already have an account?'),
                          ),
                          const SizedBox(width: 4.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: blueColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
