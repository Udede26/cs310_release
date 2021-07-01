import 'package:firebase_analytics/observer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'another_user_profile.dart';
import 'bottom_navy_bar.dart';
import 'colors.dart';
import 'package:flutter_app/post.dart';
import 'package:flutter_app/postcard.dart';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/styles.dart';

Random random = Random();


List<Post> posts = [

];

class results extends StatefulWidget{

  String src;


  results(this.src);

  @override
  _results createState() => _results();
}


class userbutton extends StatelessWidget {
  final String url;
  final String text;
  final Function press;
  final Color color, textColor;
  const userbutton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),

      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: AppColors.buttonColor,
          onPressed: press,
          child: Text(
            text,
            style: styles.WelcomeButtonTextStyle,
          ),
        ),
      ),
    );
  }
}

class _results extends State<results> {
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;

  List<String> results = [];

  var names = new Map();

  getnames (String keyword) async  {
    final ref = referenceDb.reference();
    ref.child("users").once().then((DataSnapshot data) async {
    List < String> tmp_results = [];
      Map <dynamic,dynamic> values = data.value;
      values.forEach((key,values) {
       if(values["username"].contains(widget.src) && !results.contains(key) )
       {
          setState(() {
            results.add(key);
            names[key] = values["username"];
          });
          print(key);
       }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getnames(widget.src);
    print(names);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        elevation: 0.0,
      ),
      body:  Column(
        children: <Widget>[
          Container(
            height: 800,
            child: GridView.count(
              padding: EdgeInsets.all(5.0),
              crossAxisCount: 1,
              childAspectRatio: 5,
              shrinkWrap:true,
              children: results.map((post) => Container(
                height: 10,
                child: userbutton(
                    url: post,
                  text: names[post],
                  press: () {
                    Navigator.of(context,rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return     AnotherProfileView(true,post);
                        },
                      ),
                    );

                      },
                ),
              )).toList(),
            ),
          )
        ],
      ),
    );
  }




}
