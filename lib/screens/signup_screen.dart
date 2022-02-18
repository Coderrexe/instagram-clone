import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:instagram_clone/theme.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  const CircleAvatar(
                    radius: 64.0,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1645095540331-6b05e0d3b5bc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'),
                  ),
                  Positioned(
                    bottom: -10.0,
                    left: 80.0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24.0),
              // Text input field for username.
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24.0),
              // Text input field for email.
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24.0),
              // Text input field for password.
              TextFieldInput(
                textEditingController: _passwordController,
                isPassword: true,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24.0),
              // Text input field for bio.
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24.0),
              // Login button.
              InkWell(
                onTap: () {},
                child: Container(
                  child: const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
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
                    child: const Text('Already have an account?'),
                  ),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
    );
  }
}
