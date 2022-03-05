import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/services/auth_methods.dart';
import 'package:instagram_clone/services/utils.dart';
import 'package:instagram_clone/theme.dart';
import 'package:instagram_clone/screens/user_auth/signup_screen.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController class helps us handle changes to a text field.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Create a global key that uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  // Methods for authenticating users on Firebase.
  final _authMethods = AuthMethods();

  // Whether or not to show loading animation.
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUserWithEmail() {
    // Show loading animation.
    setState(() {
      _isLoading = true;
    });
    // Check if user information are acceptable (e.g. email address is valid).
    if (_formKey.currentState!.validate()) {
      // Login user.
      _authMethods
          .loginWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                          ],
                        ),
                      ),
                      // Login button.
                      InkWell(
                        onTap: loginUserWithEmail,
                        child: Container(
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : const Text('Log In'),
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
                            child: const Text("Don't have an account?"),
                          ),
                          const SizedBox(width: 4.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: const Text(
                                'Sign Up',
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
