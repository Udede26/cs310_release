import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/rounded_button.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navy_bar.dart';
import 'postCard.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'styles.dart';
import 'colors.dart';
import 'edit_profile.dart';
import 'dart:math';


Random random = Random();

class postimageview extends StatefulWidget {
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  bool hidebar;
  PickedFile path;
  postimageview(this.hidebar,this.path);
  @override
  postimagestate createState() => postimagestate();

}



class postimagestate extends State<postimageview>{
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;


  PickedFile _image;


  String description;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = widget.path.path;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('uid');


    ref.child("users").child(id).child('posts').child('count').once().then((DataSnapshot data) async {
      int count = data.value;

      FirebaseStorage.instance.ref().child('$id/$count').putFile(File(widget.path.path));
      ref.child('users').child(prefs.getString('uid')).child('posts').child('count').set(data.value + 1).asStream();
      count = data.value;
      prefs.setInt('post_count',count);
    });



  }

  @override
  final ref = referenceDb.reference();
  Widget build(BuildContext context) {
    final ref = referenceDb.reference();
    return Scaffold(
        backgroundColor: AppColors.bodyColor,
        appBar: AppBar(
          title: Text(
            'Post',
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
        body: Center(
          child: Column(
            children: [
              FittedBox(child: Image.asset(widget.path.path),fit:BoxFit.cover,),
              TextFormField(

                keyboardType: TextInputType.multiline,
                maxLines: null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                  ],
                onChanged: (text) {
                  description = text;
                },
              ),
              RoundedButton(
                text: "Publish",
                press: () async {
                  uploadImageToFirebase(context);

                  Navigator.of(context,rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProvidedStylesExample();
                      },
                    ),
                  );

                },
              ),
            ],
          ),

        )
    );
  }
}

