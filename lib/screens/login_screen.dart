import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:instagram_clone/theme.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              // Login button.
              InkWell(
                onTap: () {},
                child: Container(
                  child: const Text('Log In'),
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
                    child: const Text("Don't have an account?"),
                  ),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Sign Up',
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
