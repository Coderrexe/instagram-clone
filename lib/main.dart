import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/providers/user_provider.dart';

// Widgets to help build responsive design.
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/user_auth/login_screen.dart';

// App theme colors, to be reused within the codebase.
import 'package:instagram_clone/theme.dart';
import 'package:provider/provider.dart';

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
  runApp(const InstagramClone());
}

class InstagramClone extends StatelessWidget {
  const InstagramClone({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // StreamBuilder rebuilds app every time there is a new event from stream.
        home: StreamBuilder(
          // authStateChanges notifies about changes to the user's sign-in state.
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // snapshot.hasData is whether the user has been authenticated.
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            // If user has not been authenticated, we redirect to the log in
            // screen.
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
