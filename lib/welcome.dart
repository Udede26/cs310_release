import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/welcome_body.dart';
import 'package:flutter_app/WalkThrough.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key, this.analytics, this.observer}) : super(key: key);



  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Body createState()=> Body();

}