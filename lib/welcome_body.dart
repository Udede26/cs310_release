import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/login_screen.dart';
import 'package:flutter_app/signup_screen.dart';
import 'package:flutter_app/welcome.dart';
import 'package:flutter_app/welcome_background.dart';
import 'package:flutter_app/rounded_button.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/styles.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

class Body extends State<WelcomeScreen> {




  Future <void>_setCurrentScreen() async {
    await analytics.setCurrentScreen(screenName: ' Welcome');
  }
  Future <void>_setCurrentScreen2() async {
    await analytics.setCurrentScreen(screenName: ' Login');
  }
  Future <void>_setCurrentScreen3() async {
    await analytics.setCurrentScreen(screenName: ' Sign up');
  }

  @override
  void initState() {
    _setCurrentScreen().then((value){
      print('Async done');
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Scaffold(
     body: Background(
      child: SingleChildScrollView(
        child: Container(
          color: AppColors.bodyColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "WELCOME TO SOCIAL MEDIA",
                style: styles.WelcomeTitleTextStyle,
              ),
              SizedBox(height: size.height * 0.05),
              Image.asset(
                "assets/icons/bestcart.jpeg",
                height: size.height * 0.45,
                width: size.width *0.60
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  _setCurrentScreen2();
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
              RoundedButton(
                text: "SIGN UP",
                color: kPrimaryLightColor,
                textColor: Colors.black,
                press: () {
                  _setCurrentScreen3();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}