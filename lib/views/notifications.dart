import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/data.dart';
import 'package:flutter_app/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/styles.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class userbutton extends StatelessWidget {
  final String url;
  final String text;
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  final Color color, textColor;
  const userbutton({
    Key key,
    this.text,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.url
  }) : super(key: key);
  accept () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ref = referenceDb.reference();
    String myid = prefs.getString('uid');



    ref.child("users").child(myid).child("request_list").once().then((DataSnapshot data) async {
      Map <dynamic,dynamic> values = data.value;
      print("hellos");
      print(data.value);
      values.forEach((key,values) {
        print("hello guys");
        if(values  == url)
          {
            ref.child("users").child(myid).child("request_list").child(key).remove();
            print("zaxd");
          }
      });
    });



      ref.child('users').child(myid).child('follower_list').child("id").push().set(url).asStream();
      ref.child('users').child(url).child('following_list').child("id").push().set(myid).asStream();
      print("this is my url");
      print(url);
  }
  reject () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ref = referenceDb.reference();
    String myid = prefs.getString('uid');



    ref.child("users").child(myid).child("request_list").once().then((DataSnapshot data) async {
      Map <dynamic,dynamic> values = data.value;
      print("hellos");
      print(data.value);
      values.forEach((key,values) {
        print("hello guys");
        if(values  == url)
        {
          ref.child("users").child(myid).child("request_list").child(key).remove();
          print("zaxd");
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),

      width: size.width *0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: AppColors.buttonColor,
          child: Row(
            children: [
              Text(
             text,
                style: styles.WelcomeButtonTextStyle,
              ),
              SizedBox(width: 20,),
              FlatButton(onPressed: (){
                  accept();
              }, child: Icon(Icons.check)),
              FlatButton(onPressed: (){
                reject();
              }, child: Icon(Icons.clear_rounded))
            ],
          ),
        ),
      ),
    );
  }
}




class _NotificationsState extends State<Notifications> {
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  List<String> results = [];

  var names = new Map();

  getnames () async  {
    final ref = referenceDb.reference();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      ref.child("users").child(prefs.getString('uid')).child("request_list").once().then((DataSnapshot data) async {
        List < String> tmp_results = [];
        Map <dynamic,dynamic> values = data.value;

        if(values != null){


        values.forEach((key,values) {
          if(!results.contains(values)) {
            setState(() {
              results.add(values);
            });
          }
          print(values);

        });

        results.forEach((key) {
          ref.child("users").child(key).once().then((
              DataSnapshot data) async {
            setState(() {
              names[key]  = data.value["username"];
            });
            print(data.value['username']);
          });
          print('hey');
          print(names[key]);
        });
        }
        else{
          setState(() {
            results = [];
          });
        }
      });

    }
    catch(yes){

    }

  }







  @override
  Widget build(BuildContext context) {
    getnames();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Notifications",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
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
                ),
              )).toList(),
            ),
          )
        ],
      ),
    );
  }
}