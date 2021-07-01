import 'package:flutter_app/utils/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';


class PostItem extends StatefulWidget{
  final String dp;
  final String name;
  final String time;
  final String img;


  PostItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img

}) : super(key:key);
  @override
  _PostItemState createState() => _PostItemState();

}

class _PostItemState extends State<PostItem> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:5),
      child:InkWell(
        child: Column(
          children:<Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.dp}",
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title:Text(
                "${widget.name}",
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Image.asset(
              "${widget.img}",
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(height:8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite_outline_rounded,
                      size:22.0,
                    ),
                    SizedBox(width:4.0),
                    Text(
                      "${random.nextInt(100)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(width:16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.comment_outlined ,
                      size: 22.0,
                    ),

                    SizedBox(width:4.0),
                    Text(
                      "${random.nextInt(50)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        onTap:(){},
      ),
    );
  }
}
