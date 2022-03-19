import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
        child: Text(user.username),
      ),
    );
  }
}
