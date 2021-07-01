import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/search_explore_body.dart';
import 'package:flutter_app/welcome.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/WalkThrough.dart';
import 'package:flutter_app/bottom_navy_bar.dart';
import 'bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp(


));

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

String initial_route ='walkthrough';

class MyApp extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
       FirebaseAnalytics analytics = FirebaseAnalytics();
       FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

      return MaterialApp(
      initialRoute:   initial_route ,
      routes: {
        '/': (BuildContext context) => WelcomeScreen(analytics: analytics,observer: observer,),
        'walkthrough': (BuildContext context) => WalkThrough(analytics: analytics, observer: observer),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}