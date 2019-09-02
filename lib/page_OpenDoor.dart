import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenDoorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Page();
  }
}

class Page extends State<OpenDoorPage> {
  var _imageUrls = [] ;
  Api api = new Api();
  var lists = [] ;
  var colors = [
    Color.fromRGBO(230,33,24 ,100),
    Color.fromRGBO(23,116,193,100),
    Color.fromRGBO(242,199,68,100),
  ];

  Page(){
    getHold().then((val){
      Dio().get(api.getUserOnekeyDoor+'?holdId=${val}').then((response){
        if(response.statusCode==200){
          var data  = response.data;
          if(data['code']==200){
            setState(() {
              lists = data['data'];
            });
          }
        }
      });
    });
  }

  int _current = 0;
  void getR() {
    Dio().request(api.getHRotation + '?rotationType=1').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content['data']);
        setState(() {
          _imageUrls = content['data'];
        });
      }
    });
  }

  var types = [
    [
      {'icon': 'images/weather.png', 'title': '1'},
      {'icon': 'images/weather.png', 'title': '2'},
      {'icon': 'images/weather.png', 'title': '3'},
      {'icon': 'images/weather.png', 'title': '4'}
    ],
    [
      {'icon': 'images/weather.png', 'title': '5'},
      {'icon': 'images/weather.png', 'title': '6'},
      {'icon': 'images/weather.png', 'title': '7'},
    ],
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  List<Widget> getIcons(List list) {
    List<Widget> icons = [];
    for (var i = 0; i < list.length; i++) {
      icons.add(Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 120,
          child: Column(
            children: <Widget>[
              IconButton(
                  icon: Image.asset(list[i]['icon']),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('listAddress')),
              Text(list[i]['title'])
            ],
          )));
    }

    return icons;
  }
  @override
  Widget build(BuildContext context) {
    return layout(context);
  }


  Widget layout(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('一键开门'),
          centerTitle: true, elevation: 0),
      body: ListView.builder(
        itemCount: lists.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
        return Container(
          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.14, 0, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage(
//                  'images/open_door_background.png'),
//              fit: BoxFit.fitWidth,
//              alignment: Alignment.topCenter,
//            ),
//          ),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width*0.8,
//              height: MediaQuery.of(context).size.height*0.6,

//              color: Colors.black,
//            decoration: BoxShadow(color: Color(0xffff0000), offset: Offset(3.0, 3.0),blurRadius: 2,spreadRadius: 5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height*0.135,
                      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.1, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      color: colors[index%3],
                      child: Column(
                        children: <Widget>[
                          Text(lists[index]['doorName'],style: TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.w600),),
//                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text('点击开门后请耐心等待系统反应哟！',style: TextStyle(color: Colors.white),),

                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height*0.4,

                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.05, 0, 0)),
                          Container(
                            width: MediaQuery.of(context).size.width*0.25,
                            height: MediaQuery.of(context).size.height*0.2,
                            child:Image.asset('images/door.png'),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          lists[index]['doorEnterNumber'].length==0?Container():Container(
                            //修饰黑色背景与圆角
                            decoration: new BoxDecoration(
                              color: Color.fromRGBO(243, 200, 70, 1),
                              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                            ),
                            height: MediaQuery.of(context).size.height*0.04,
                            width: MediaQuery.of(context).size.width*0.45,
                            child: FlatButton(onPressed: (){
                              openDoor(lists[index]['doorEnterNumber']);
//                              show
//                              showMenu(context: context, position: RelativeRect.fill, items: null)
                              print(MediaQuery.of(context).size.aspectRatio);
                            }, child: Text('立即开门(进)',style: TextStyle(color: Colors.white),)),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          lists[index]['doorOutNumber'].length==0?Container():Container(
                            //修饰黑色背景与圆角
                            decoration: new BoxDecoration(
                              color: Color.fromRGBO(243, 200, 70, 1),
                              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                            ),
                            height: MediaQuery.of(context).size.height*0.04,
                            width: MediaQuery.of(context).size.width*0.45,
                            child: FlatButton(onPressed: (){
                              openDoor(lists[index]['doorOutNumber']);
//                              show
//                              showMenu(context: context, position: RelativeRect.fill, items: null)
                              print(MediaQuery.of(context).size.aspectRatio);
                            }, child: Text('立即开门(出)',style: TextStyle(color: Colors.white),)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
  openDoor(number){
    getUser().then((val){
      Dio().get(api.OpenDoor+"?token=${val}&DriveNumber=${number}").then((response){
        print(response);
        if(response.statusCode==200){
          var data = response.data;
          if(data['code']==200){
            Fluttertoast.showToast(
                msg: "开门成功，请耐心等待设备响应！",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
          }else{
            Fluttertoast.showToast(
                msg: data['msg'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        }
      });
    });
  }
}