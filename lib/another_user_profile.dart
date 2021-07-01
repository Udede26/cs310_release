import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/postimage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'postCard.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'styles.dart';
import 'colors.dart';
import 'edit_profile.dart';
import 'dart:math';


Random random = Random();

class AnotherProfileView extends StatefulWidget {

  bool hidebar;
  String id;
  AnotherProfileView(this.hidebar,this.id);
  @override
  _AnotherProfileViewState createState() => _AnotherProfileViewState();

}


class _AnotherProfileViewState extends State<AnotherProfileView>{
  static FirebaseDatabase referenceDb = FirebaseDatabase.instance;

  List<Post> posts = [

  ];


  _imgFromGallery() async {
    PickedFile image = await  ImagePicker().getImage(source: ImageSource.gallery);



    Navigator.of(context,rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) {
          return postimageview(  false , image);
        },
      ),
    );


  }

  imageget() async {
    final ref = referenceDb.reference();

    String id =widget.id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.child("users").child(id).child('posts').child('count').once().then((DataSnapshot data) async {

      ref.child("users").child(id).once().then((DataSnapshot dat) async {


      int count = data.value;
      List<Post> posts_temp = [

      ];
      if(dat.value['private'] == false || dat.value['follower_list']['id']['-Mbw1HNh5yitoQTAddb7']==prefs.getString('uid')){
        print("yeap");
      for(int i = 0;i < count;i++) {
        try {
          print(i);
          String myurl = await FirebaseStorage.instance.ref().child(
              "$id/$i").getDownloadURL();
          print(count);
          print(myurl);

          posts_temp.add(Post(address: myurl,
              date: 'this',
              likes: 0,
              comments: 0,
              description: ""));
        }

        catch(hello){
          print("error");
          print("uploads/$i");
        }
      }
      setState(() {
        posts = posts_temp;
      });
          }
      });

    });
    print('yesssss');
  }
  String buttontext = "Follow";
  List <String> thelist =[];
  double opac = 1;
  String name;
  String username;
  String theurl = "";
  getreq () async {
    final ref = referenceDb.reference();
    ref.child("users").child(widget.id).child('request_list').once().then((DataSnapshot data) async {
    try{
      data.value.values.forEach((value) {
        if(!thelist.contains(value))
        {
          thelist.add(value);
        }
      });
    }
     catch(asdf){

     }
    });



    SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.child("users").child(widget.id).child('follower_list').child("id").once().then((DataSnapshot data) async {

      print(prefs.getString("uid"));
      bool check = true;
      try{
        data.value.values.forEach((value){

          if(value == prefs.getString("uid")){
            check = false;
            setState(() {
              buttontext = "Unfollow";
            });
          }


        });
      }
      catch(asdf){

      }
      if(check)
        {
          setState(() {
            buttontext="Follow";
          });
        }

    });

    ref.child("users").child(widget.id).once().then((DataSnapshot data) async {
      setState(() {
        name = data.value["name"];
        username =  data.value["username"];
      });
      String theid = widget.id;
      String myurl = await FirebaseStorage.instance.ref().child("profile_pictures/$theid").getDownloadURL();
      setState(() {
        theurl = myurl;
        print("benim urlm");
        print(theurl);
      });

    });
  }

  @override
  Widget build(BuildContext context) {


    imageget();
    getreq();



    print('amount:');
    print(posts.length);
    final ref = referenceDb.reference();


    return Scaffold(
        backgroundColor: AppColors.bodyColor,
        appBar: AppBar(
          title: Text(
            'Profile',
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
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  CircleAvatar(
                    backgroundImage: NetworkImage(theurl),
                    radius: 44.0,
                  ),

                  SizedBox(width: 8,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 28.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mainTexts,
                        ),
                      ),

                      SizedBox(height: 10.0,),

                      Text(
                        '@'+username,
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subTexts,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RaisedButton(
                          child: Text(buttontext),
                          color: AppColors.buttonColor,
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if (!thelist.contains(prefs.getString('uid')))
                            {
                              ref.child('users').child(widget.id).child('request_list').push().set(prefs.getString('uid')).asStream();
                            }


                              if (buttontext == "Unfollow"){
                                ref.child("users").child(widget.id).child('follower_list').child("id").once().then((DataSnapshot data) async {

                                  Map <dynamic,dynamic> values = data.value;

                                  values.forEach((key,values) {
                                         if(values == prefs.getString('uid'))
                                              {
                                              ref.child("users").child(widget.id).child("follower_list").child("id").child(key).remove();
                                              }
                                      });
                                      });

                                ref.child("users").child(prefs.getString('uid')).child('following_list').child("id").once().then((DataSnapshot data) async {

                                  Map <dynamic,dynamic> values = data.value;

                                  values.forEach((key,values) {
                                    if(values == widget.id)
                                    {
                                      ref.child("users").child(prefs.getString('uid')).child("following_list").child("id").child(key).remove();

                                    }
                                  });
                                });

                                }
                          },
                        ),
                    ],
                  ),

                ],
              ),


              Divider(
                color: AppColors.bodyColor,
                height: 20,
                thickness: 0.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Posts',
                        style: TextStyle(
                          color: AppColors.subTexts,
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        '0',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.subTexts,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subTexts,
                        ),
                      ),

                      Text(
                        '189',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.subTexts,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Following',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subTexts,
                        ),
                      ),

                      Text(
                        '1290',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.subTexts,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                color: AppColors.bodyColor,
                height: 20,
                thickness: 0.0,
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: 500,
                    child: GridView.count(
                      padding: EdgeInsets.all(5.0),
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      shrinkWrap:true,
                      children: posts.map((post) => PostCard(
                          post: post,
                          delete: () {
                            setState(() {
                              posts.remove(post);
                            });
                          }
                      )).toList(),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}

