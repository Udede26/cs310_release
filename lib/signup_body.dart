import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login_screen.dart';
import 'package:flutter_app/signup_background.dart';
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

import 'bottom_navy_bar.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

class User {
  String email;
  String password;
  String name;
  String surname;
  String phone_number;
  String username;
  String address;
  User(this.email, this.password,this.name,this.surname,this.phone_number,this.address,this.username);
}

class Body extends StatelessWidget {

  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  User user= User('','','','','','','');


  String pass_again;

  @override
  Widget build(BuildContext context) {
    final ref = referenceDb.reference();
    Size size = MediaQuery.of(context).size;
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {user.email=value;},
            ),
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
            RoundedPasswordField(
              onChanged: (value) {user.password=value;},
            ),
            RoundedPasswordFieldAgain(
              onChanged: (value) {pass_again=value;},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {

                var rng = new Random();
                var uid = rng.nextInt(1000000);
                String fullname = user.name + " " + user.surname;

                if(user.email != '' && user.name != '' && user.surname != '' && user.email != '' && user.password != '' && pass_again != ""  && user.password == pass_again) {

                  ref.child('users').child(uid.toString())
                      .child('name')
                      .set(fullname)
                      .asStream();

                  ref.child('users').child(uid.toString())
                      .child('username')
                      .set(user.username)
                      .asStream();

                  ref.child('users').child(uid.toString())
                      .child('password')
                      .set(user.password)
                      .asStream();

                  ref.child('users').child(uid.toString())
                      .child('email')
                      .set(user.email)
                      .asStream();

                  ref.child('users').child(uid.toString()).child(
                      'follower_count').set(0).asStream();

                  ref.child('users').child(uid.toString()).child(
                      'follower_list').child("ids").push().set("dummy").asStream();

                  ref.child('users').child(uid.toString()).child(
                      'follower_list').child("ids").push().set("dummy2").asStream();

                  ref.child('users').child(uid.toString())
                      .child('posts')
                      .set(0)
                      .asStream();

                  ref.child('users').child(uid.toString()).child(
                      'following_count').set(0).asStream();


                  ref.child('users').child(uid.toString()).child(
                      'following_list').child("ids").push().set("dummy").asStream();

                  ref.child('users').child(uid.toString()).child(
                      'following_list').child("ids").push().set("dummy2").asStream();


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProvidedStylesExample();
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}