import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/postimage.dart';
import 'package:flutter_app/rounded_button.dart';
import 'package:flutter_app/zoom_profile_picture.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'followers.dart';
import 'postCard.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'styles.dart';
import 'colors.dart';
import 'edit_profile.dart';
import 'dart:math';


Random random = Random();

class ProfileView extends StatefulWidget {

  bool hidebar;
  ProfileView(this.hidebar);
  @override
  _ProfileViewState createState() => _ProfileViewState();

}


class _ProfileViewState extends State<ProfileView>{
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
  String name;
  String username;
  String profile_picture;
  int postcount;
  String theurl = '';
  imageget() async {
    final ref = referenceDb.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('post_count');

    String id = prefs.getString('uid');

     ref.child("users").child(prefs.getString('uid')).child('posts').child('count').once().then((DataSnapshot data) async {
      int count = data.value;
      List<Post> posts_temp = [

      ];
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
    });

    ref.child("users").child(prefs.getString('uid')).once().then((DataSnapshot data) async {
      setState(() {
        name = data.value["name"];
        username =  data.value["username"];
        postcount = data.value["posts"]["count"];

      });

      try{
        String myurl = await FirebaseStorage.instance.ref().child("profile_pictures/$id").getDownloadURL();
        setState(() {
          theurl = myurl;
        });
      }
      catch(yakala){

      }

      });

    print('yesssss');
  }

  @override
  Widget build(BuildContext context) {



    imageget();
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

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context,rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return zoom(theurl);
                          },
                        ),
                      );
                   },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(theurl),
                      radius: 44.0,
                    ),
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
                      IconButton(
                        icon: Icon(Icons.settings_rounded ),
                        color: AppColors.mainTexts,
                        onPressed: () {Navigator.of(context,rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return editprofile();
                            },
                          ),
                        );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_to_photos_outlined),
                        color: AppColors.mainTexts,
                        onPressed: () async {

                          _imgFromGallery();

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String id = prefs.getString('uid');

                          ref.child("users").child(id).child('posts').child('count').once().then((DataSnapshot data) async {

                          ref.child('users').child(id).child('posts').child(data.value.toString()).child('description').set("Cok guzel gunbatimi").asStream();
                          ref.child('users').child(id).child('posts').child(data.value.toString()).child('likes').push().set('dummy').asStream();
                          ref.child('users').child(id).child('posts').child(data.value.toString()).child('comments').child('comment').child('id').set('user').asStream();
                          ref.child('users').child(id).child('posts').child(data.value.toString()).child('comments').child('comment').child('content').set('Gercekten cok guzel').asStream();
                          ref.child('users').child(id).child('posts').child(data.value.toString()).child('repost').push().set('dummy').asStream();
                          ref.child('users').child(id).child('posts').child(data.value.toString()).child('date').set('1.2.3').asStream();
                          });
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
                        postcount.toString(),
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
                      Container(
                        width: 150,
                        height:20,
                        child: FlatButton(
                          child: Text("Followers",style: TextStyle(
                            fontFamily: 'BrandonText',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subTexts,
                          ),),
                          onPressed: (){
                            Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return follower();
                                },
                              ),
                            );
                          },
                        )
                      ),

                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                          width: 150,
                          height:20,
                          child: FlatButton(
                            child: Text("Following",style: TextStyle(
                              fontFamily: 'BrandonText',
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: AppColors.subTexts,
                            ),),
                            onPressed: (){
                              Navigator.of(context,rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return follower();
                                  },
                                ),
                              );
                            },
                          )
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

