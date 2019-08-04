import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}
class Page extends State<NotificationPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('社区通知'),centerTitle: true,elevation: 0,),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
            color: Colors.white,
            width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              children: <Widget>[
                Text('ddd')
              ],
            ),
          )
        ],
      ),
    );
  }
}