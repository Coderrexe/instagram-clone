import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Widgets to help build responsive design.
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
// App theme colors, to be reused within the codebase.
import 'package:instagram_clone/theme.dart';

void main() async {
  // We have to load Flutter widgets before initializing Firebase app.
  // There would be an error if we don't do this step.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase app.
  if (kIsWeb) {
    // Flutter web requires different Firebase initialization from mobile.
    // FirebaseOptions parameters are provided when we register the web app in
    // the Firebase project console.
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDq8h9bvAW08q954GPiRT5gC_epWA_eJBs',
        appId: '1:786269460373:web:61b11215b8f430f73d489c',
        messagingSenderId: '786269460373',
        projectId: 'instagram-clone-d5a12',
        storageBucket: 'instagram-clone-d5a12.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: SignupScreen(),
    );
  }
}
