import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login_screen.dart';
import 'package:flutter_app/google_signup_background.dart';
import 'package:flutter_app/or_divider.dart';
import 'package:flutter_app/social_icon.dart';
import 'package:flutter_app/already_have_an_account_acheck.dart';
import 'package:flutter_app/rounded_button.dart';
import 'package:flutter_app/rounded_input_field.dart';
import 'package:flutter_app/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/welcome.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navy_bar.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

class User {
  String email;
  String password;
  String name;
  String surname;
  String phone_number;
  String address;
  String username;
  User(this.email, this.password,this.name,this.surname,this.phone_number,this.address,this.username);
}

class Body extends StatelessWidget {

  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  User user= User('','','','','','','');




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ref = referenceDb.reference();
    return Background(
      child: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 150,
              child: Align(
                alignment: Alignment.topLeft,
                child:  RoundedButton(
                  text: "BACK",
                  press: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomeScreen();
                      },
                    ),
                  );},
                ),
              ),
            ),
            Text(
              "Please enter user information",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Name",
              onChanged: (value) {user.name=value;},
            ),
            RoundedInputField(
              hintText: "Surname",
              onChanged: (value) {user.surname=value;},
            ),
            RoundedInputField(
              hintText: "Username",
              onChanged: (value) {user.username=value;},
            ),
            RoundedButton(
              text: "SAVE",
              press: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String fullname = user.name + " " + user.surname;

                print(user.name + user.surname + user.username);

                if(user.name != '' && user.surname != '' && user.username != '')  {
                  ref.child('users').child(prefs.getString("uid"))
                      .child('name')
                      .set(fullname)
                      .asStream();

                  ref.child('users').child(prefs.getString("uid"))
                      .child('username')
                      .set(user.username)
                      .asStream();

                  ref.child('users').child(prefs.getString('uid')).child('posts').child('count').set(0).asStream();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProvidedStylesExample();
                      },
                    ),
                   );
                }


              }
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}