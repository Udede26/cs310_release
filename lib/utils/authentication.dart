import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../bottom_navy_bar.dart';

class Authentication {
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  static SnackBar customSnackBar({ String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
     BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;


    return firebaseApp;
  }

  static Future<User> signInWithGoogle({ BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    final ref = referenceDb.reference();


    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
      
      


          ref.child("users").child(userCredential.user.uid).once().then((DataSnapshot data) async {




            if (data.value== null) {
              ref.child('users').child(userCredential.user.uid)
                  .child('email')
                  .set(userCredential.user.email)
                  .asStream();
              ref.child('users').child(userCredential.user.uid).child(
                  'follower_count').set(0).asStream();

              ref.child('users').child(userCredential.user.uid).child(
                  'follower_list').child("ids").push().set("dummy").asStream();


               ref.child('users').child(userCredential.user.uid).child(
                   'follower_list').child("ids").push().set("dummy2").asStream();


              ref.child('users').child(userCredential.user.uid)
                  .child('posts')
                  .set(0)
                  .asStream();

              ref.child('users').child(userCredential.user.uid).child(
                  'following_count').set(0).asStream();


              ref.child('users').child(userCredential.user.uid).child(
                  'following_list').child("ids").push().set("dummy").asStream();

             ref.child('users').child(userCredential.user.uid).child(
                 'following_list').child("ids").push().set("dummy2").asStream();
             ref.child('users').child(userCredential.user.uid)
                  .child('name')
                  .set('')
                  .asStream();
              ref.child('users').child(userCredential.user.uid).child(
                  'username').set('').asStream();
              ref.child('users').child(userCredential.user.uid)
                  .child('bio')
                  .set('')
                  .asStream();
              ref.child('users').child(userCredential.user.uid).child(
                  'firsttime').set(0).asStream();
              ref.child('users').child(userCredential.user.uid).child(
                  'pp_url').set('').asStream();

              ref.child("users").child(userCredential.user.uid).child('private').set(false).asStream();

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('uid', userCredential.user.uid);
            }
            else{
              print("else");
              SharedPreferences prefs = await SharedPreferences.getInstance();

              List<String> followers = [];
                    List<String> following = [];

              data.value["follower_list"]["ids"].values.forEach((value) {
                  followers.add(value);
                });


                   data.value["following_list"]["ids"].values.forEach((value) {
                       following.add(value);
                     });

               print(followers);
               print(following);
              prefs.setString('uid', userCredential.user.uid);
              prefs.setString('name', data.value["name"]);
              prefs.setString('username', data.value["username"]);
              prefs.setString('pp_url', data.value["pp_url"]);
              prefs.setString('bio', data.value["bio"]);
              prefs.setInt('follower_count', data.value["follower_count"]);
              prefs.setStringList('follower_list', followers);
              prefs.setStringList('following_list', following);
              prefs.setInt('following_count', data.value["following_count"]);
              prefs.setInt('post_count', data.value["post_count"]);
            }
          });

        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({ BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}