import 'package:flutter/material.dart';

class StayPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<StayPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('酒店住宿'),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Container(
//              height: MediaQuery.of(context).size.height*0.3,
//              width: MediaQuery.of(context).size.width*0.9,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    //修饰黑色背景与圆角
                    decoration: new BoxDecoration(
//                      color: Colors.grey[100],
                      borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                    ),
                    alignment: Alignment.center,
//                    height: 30,
//                    width: MediaQuery.of(context).size.width - 30,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.only(left: 0.0),
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                          hintText: "搜索酒店名称",
                          hintStyle: new TextStyle(fontSize: 14, color: Colors.grey)),
                      style: new TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 40.0,
                    child: new RaisedButton(
                      onPressed: null,
                      color: Color.fromRGBO(240, 190, 60, 1),
                      disabledColor: Color.fromRGBO(240, 190, 60, 1),
                      child: new Text("搜索酒店",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      shape: new StadiumBorder(
                          side: new BorderSide(
                            style: BorderStyle.solid,
                            color: Color.fromRGBO(240, 190, 60, 1),
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}