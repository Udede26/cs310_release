import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login_background.dart';
import 'package:flutter_app/signup_screen.dart';
import 'package:flutter_app/google_signup_screen.dart';
import 'package:flutter_app/already_have_an_account_acheck.dart';
import 'package:flutter_app/rounded_button.dart';
import 'package:flutter_app/rounded_input_field.dart';
import 'package:flutter_app/rounded_password_field.dart';
import 'package:flutter_app/utils/authentication.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/welcome.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/bottom_navy_bar.dart';
class User1 {
  String email;
  String password;
  User1(this.email, this.password);
}



class Body extends StatelessWidget {
   Body({
    Key key,
  }) : super(key: key);


  User1 user= User1('','');
   static FirebaseAnalytics analytics = FirebaseAnalytics();
   static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
   static FirebaseDatabase referenceDb = FirebaseDatabase.instance;



   _makePostRequest() async {
     // set up POST request arguments
     String email = user.email;
     String password = user.password;
     String url = 'https://jsonplaceholder.typicode.com/posts';
     Map<String, String> headers = {"Content-type": "application/json"};
     String json = '{"email": "$email", "password": "$password"}';
     // make POST request
     Response response = await post(  Uri.parse('http://localhost:3000/login'), headers: headers, body: json);
     // check the status code for the result
     int statusCode = response.statusCode;
     // this API passes back the id of the new item added to the body
     String body = response.body;
     // {
     //   "title": "Hello",
     //   "body": "body text",
     //   "userId": 1,
     //   "id": 101
     // }
   }

  @override
  Widget build(BuildContext context) {

    final ref = referenceDb.reference();

    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Container(
          color: AppColors.bodyColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                "assets/icons/bestcart.jpeg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {user.email = value;},
              ),
              RoundedPasswordField(
                onChanged: (value) {user.password = value;},
              ),
              RoundedButton(
                text: "LOGIN",
                press: () {

                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProvidedStylesExample(analytics: analytics, observer: observer);
                    },
                  ),
                );},
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
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
    );
  }



}

   class GoogleSignInButton extends StatefulWidget {
   @override
   _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
   }

   class _GoogleSignInButtonState extends State<GoogleSignInButton> {
   bool _isSigningIn = false;
   static FirebaseAnalytics analytics = FirebaseAnalytics();
   static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
   static FirebaseDatabase referenceDb = FirebaseDatabase.instance;

   @override
   Widget build(BuildContext context) {
     final ref = referenceDb.reference();
     return Padding(
   padding: const EdgeInsets.only(bottom: 16.0),
   child: _isSigningIn
   ? CircularProgressIndicator(
   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
   )
       : OutlinedButton(
   style: ButtonStyle(
   backgroundColor: MaterialStateProperty.all(Colors.white),
   shape: MaterialStateProperty.all(
   RoundedRectangleBorder(
   borderRadius: BorderRadius.circular(40),
   ),
   ),
   ),

       onPressed: () async {
         setState(() {
           _isSigningIn = true;
         });

         User user =
         await Authentication.signInWithGoogle(context: context);

         setState(() {
           _isSigningIn = false;
         });
          print(user.email);

         ref.child("users").child(user.uid).once().then((DataSnapshot data) async {
           print("uid");

         if (user != null) {
           print("Success");
           if (data.value != null ) {
             Navigator.of(context).pushReplacement(
               MaterialPageRoute(
                 builder: (context) =>
                     ProvidedStylesExample(
                       user: user, analytics: analytics, observer: observer,
                     ),
               ),
             );
           }
           else {
             Navigator.of(context).pushReplacement(
               MaterialPageRoute(
                 builder: (context) =>
                     GoogleSignUpScreen(),
               ),
             );
           }
         }
         });

       },
   child: Padding(
   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
   child: Row(
   mainAxisSize: MainAxisSize.min,
   mainAxisAlignment: MainAxisAlignment.center,
   children: <Widget>[
   Image(
   image: AssetImage("assets/google_logo.png"),
   height: 35.0,
   ),
   Padding(
   padding: const EdgeInsets.only(left: 10),
   child: Text(
   'Sign in with Google',
   style: TextStyle(
   fontSize: 20,
   color: Colors.black54,
   fontWeight: FontWeight.w600,
   ),
   ),
   )
   ],
   ),
   ),
   ),
   );
   }
   }