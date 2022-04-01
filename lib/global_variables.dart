import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/create_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';

// Widths of screens, used for creating responsive design.
const webScreenSize = 600;

// List of pages in home page navigation bar.
const homeScreenItems = [
  FeedScreen(),
  Center(child: Text('Search')),
  CreatePostScreen(),
  Center(child: Text('Notification')),
  Center(child: Text('Profile')),
];
