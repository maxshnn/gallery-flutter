import 'package:flutter/material.dart';

const baseUrl = "https://gallery.prod1.webant.ru/";
const photosUrl = 'api/photos/';
const mediaUrl = 'media/';
const userUrl = 'api/users/';

class ThemeApp {
  static final textViewName = TextStyle(
      fontSize: 32,
      color: Colors.deepPurpleAccent[600],
      fontWeight: FontWeight.w500);
  static final textViewUsername =
      TextStyle(fontSize: 28, color: Colors.pink[800]);
  static final textViewDescription = TextStyle(
    fontSize: 18,
    color: Colors.grey[800],
  );
  static final textViewDate = TextStyle(fontSize: 15, color: Colors.grey[300]);
  static final textViewViews = TextStyle(fontSize: 15, color: Colors.grey[300]);
}
