import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/welcome_body.dart';
import 'package:flutter_app/signup_screen.dart';
import 'package:flutter_app/welcome.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/styles.dart';
import 'welcome.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MaterialApp(
    home: WalkThrough(),
  ));
}

class WalkThrough extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const WalkThrough({Key key, this.analytics, this.observer}) : super(key: key);

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<int> _counter;

  Future <void>_setCurrentScreen4() async {
    await analytics.setCurrentScreen(screenName: ' Walkthrough');
  }



  int current_page= 1;
  int total_page = 4;
  List<String> img_url = [
    "https://www.searchenginejournal.com/wp-content/uploads/2020/09/outstanding-social-media-campaigns-5f60d3e4bb13b-1520x800.png",
    "https://images.unsplash.com/photo-1554177255-61502b352de3?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c29jaWFsJTIwbWVkaWF8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
    "https://turuncumedya.com/img/search-12.png",
    "https://monoloop.com/wp-content/uploads/2017/08/photo-1511367461989-f85a21fda167.jpg"
  ];
  List<String> app_titles = ["MAIN","DISCOVER","SEARCH","PROFILE"];
  List<String> page_titles = [
    "You can see your feed",
    "See what is happening",
    "Are you looking for someone?",
    "The best person in the world"];
  List<String> captions = [
    "Too boring...",
    "The world is discovering...",
    "Baam, we found it...",
    "Such a mysterious guy..."];

  void nextPage() {
    if(current_page == 4){
      setState(() {
        current_page = 4;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WelcomeScreen();
            },
          ),
        );
      });

    }
    else{
      setState(() {
        current_page +=1;
      });

    }
  }

  void prevPage() {
    if(current_page == 1)
      {
        setState(() {
          current_page = 1;
        });

      }
    else{
      setState(() {
        current_page -=1;
      });

    }
  }

  _incrementCounter() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen5') ?? false);
    if (seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new WelcomeScreen()));
    } else {
      prefs.setBool('seen5', true);
    }
  }
  @override
  void initState() {
    super.initState();
    _setCurrentScreen4().then((value){
      print('Async done');
    });
      _incrementCounter();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text(
          app_titles[current_page-1],
          style: styles.BarTitleTextStyle
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
    body: Container(
      color: AppColors.bodyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Text(
           page_titles[current_page-1],
           style: styles.HeadingTitleTextStyle
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(img_url[current_page-1]),
            radius: 200.0,
          ),
          Text(
            captions[current_page-1],
            style: styles.minorTextStyle
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              FlatButton(
                onPressed: prevPage,
                  color: AppColors.buttonColor,

                  child: Text('Prev',
                  style: TextStyle(
                    color:AppColors.mainTexts,
                  ),
                  ),
              ),
              Text(
                '$current_page'+'/'+'$total_page',
                style:TextStyle(
                  color:AppColors.subTexts,
                ),
              ),
              FlatButton(
                onPressed: nextPage,

                color:AppColors.buttonColor,

                child: Text('Next',
                  style: TextStyle(
                    color:AppColors.mainTexts,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}