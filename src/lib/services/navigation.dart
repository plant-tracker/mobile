import 'package:flutter/material.dart';
import 'package:plant_tracker/pages/welcome.dart';
import 'package:plant_tracker/pages/home.dart';

class NavigationService {
  static Map<String, Widget Function(BuildContext)> routes =   {
    '/' : (context) => WelcomePage(),
    '/home'  : (context) => HomePage(title: "Plant Tracker")
  };
}
