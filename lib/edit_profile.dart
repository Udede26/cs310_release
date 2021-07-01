import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login_background.dart';
import 'package:flutter_app/postimage.dart';
import 'package:flutter_app/signup_screen.dart';
import 'package:flutter_app/already_have_an_account_acheck.dart';
import 'package:flutter_app/rounded_button.dart';
import 'package:flutter_app/rounded_input_field.dart';
import 'package:flutter_app/rounded_password_field.dart';
import 'package:flutter_app/styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/welcome.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_app/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class editprofile extends StatefulWidget {
  @override
  edit_profile_view createState() => new edit_profile_view();
}


class edit_profile_view extends State<editprofile>{
  @override
  void initState() {
    super.initState();
  }
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  bool check=false;
  getval () async {
    final ref = referenceDb.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.child("users").child(prefs.getString('uid')).once().then((DataSnapshot data) async {
      setState(() {
        check = data.value["private"];
      });


    });
  }

  Future uploadImageToFirebase(BuildContext context,PickedFile path) async {
    String fileName = path.path;
    final ref = referenceDb.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('uid');
    print("yuklemece");
    FirebaseStorage.instance.ref().child('profile_pictures/$id').putFile(File(path.path));
  }

  _aimgFromGallery() async {
    PickedFile image = await  ImagePicker().getImage(source: ImageSource.gallery);



  uploadImageToFirebase(context, image);


  }
  String myurl ="";

  agetpp () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('uid');
      print("test");
      print("id");
      print(id);
    String temp;
    print("ZAAAAA");

    try{
      print("ben burdayim");
      String temp = await FirebaseStorage.instance.ref().child(
          "profile_pictures/$id").getDownloadURL();
      print('hayir burdayim');
      if(temp != null){
        setState(() {
          myurl = temp;
        });
      }
      else{
        setState(() {
          myurl = "";
        });
      }
    }
   catch(za){
      print("add");
        print(za);
   }

    print("ZAAAAA");
    print(temp);





  }
  @override
  Widget build(BuildContext context){
    agetpp();
    getval ();
    return new Scaffold(
      appBar: AppBar(
        title:Text('Edit profile'),
        backgroundColor: AppColors.mainColor,
      ),
      body: SingleChildScrollView(

    child: Padding(
      padding: const EdgeInsets.fromLTRB(0,50,0,0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(myurl),
            radius: 44.0,
          ),
          RaisedButton(
            child: Text('Change Profile Picture'),
            color: AppColors.buttonColor,
            onPressed: () {
              _aimgFromGallery();
            },
          ),
          SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Name',style:TextStyle(fontSize:25)),
              SizedBox(width: 10),
              SizedBox(
                width: 200,
                child: TextFormField(
                  initialValue: "Name",
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Username',style:TextStyle(fontSize:25)),
              SizedBox(
                width: 200,
                child: TextFormField(
                  initialValue: "Username",
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Bio',style:TextStyle(fontSize:25)),
              SizedBox(width: 70),
              SizedBox(
                width: 200,
                child: TextFormField(
                  initialValue: "Bio",
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Change password',style:TextStyle(fontSize:15)),
              SizedBox(width: 70),
              SizedBox(
                width: 200,
                child: TextFormField(
                  initialValue: "Password",
                  onChanged: (value) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final ref = referenceDb.reference();
                    String id = prefs.getString('uid');
                    ref.child('users').child(id)
                      .child('password')
                      .set(value)
                      .asStream();},
                ),
              ),
            ],
          ),
          SizedBox(height: 50,),
          Container(
            height: 40,
            child: FlatButton(
              child: Text("Delete Account"),
              onPressed: () async {  final ref = referenceDb.reference();

              SharedPreferences prefs = await SharedPreferences.getInstance();
              ref.child("users").child(prefs.getString('uid')).remove();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context)
                    => WelcomeScreen()),
                    (Route<dynamic> route) => false,
              ); },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Set Profile Private"),
              Checkbox(
                value: check,
                onChanged: (bool newValue) async {
                  final ref = referenceDb.reference();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    check = newValue;
                  });
                  ref.child("users").child(prefs.getString("uid")).child('private').set(newValue).asStream();
                },
              ),
            ],
          ),
          SizedBox(height: 30,),
          RoundedButton(
            text: "SAVE CHANGES",
            press: () async {
            },
          ),

          SizedBox(height: 0.03),
        ],
      ),
    ),
    ),
    );
  }
}