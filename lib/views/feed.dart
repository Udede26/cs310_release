import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/postimage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../postCard.dart';
import 'package:flutter/material.dart';
import '../post.dart';
import '../styles.dart';
import '../colors.dart';
import '../edit_profile.dart';
import 'dart:math';



void main() => runApp(MaterialApp(
  home: Feed(),
));

class Feed extends StatefulWidget {
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<Feed> {
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;
  List<Post> myposts = [

  ];


  imageget() async {
    final ref = referenceDb.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('post_count');

    String id = prefs.getString('uid');

    ref.child("users").child(prefs.getString('uid')).child('following_list').child('id').once().then((DataSnapshot data) async {

      List<Post> posts_temp = [

      ];

      try{
         await data.value.forEach((key,val)
        async {
          for(int i = 0;i < 10;i++) {
            try {
              print(i);
              String myurl = await FirebaseStorage.instance.ref().child(
                  "$val/$i").getDownloadURL();

              print(myurl);
                print("dans");
              posts_temp.add(Post(address: myurl,
                  date: 'this',
                  likes: 0,
                  comments: 0,
                  description: ""));
              print("naber");
              print(posts_temp);
            }
            catch(hello){
              print("error");
              print("uploads/$i");
            }
          }
        });
        setState(() {
          myposts = posts_temp;
          print(posts_temp);
          print('degistirdim');
          print(myposts[0].address);
        });
      }
     catch(za){

     }


    });

  }



  @override
  Widget build(BuildContext context) {
    imageget();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title:Text("Feed"),
        centerTitle:true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 1000,
              width: 500,
              child: Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(5.0),
                  crossAxisCount: 1,
                  childAspectRatio: 1,
                  shrinkWrap:true,
                  children: myposts.map((post) => PostCard(
                      post: post,
                  )).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
