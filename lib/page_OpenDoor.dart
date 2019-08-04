import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'api.dart';

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

  Page(){
    getR();
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
      appBar: AppBar(title: Text('一键开门'), elevation: 0),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.14, 0, 0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/open_door_background.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
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
                    color: Color.fromARGB(180,245, 211,104),
                    child: Column(
                      children: <Widget>[
                        Text('正门1',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.w600),),
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
                        Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.05, 0, 0)),
                        Container(
                          //修饰黑色背景与圆角
                          decoration: new BoxDecoration(
                            color: Colors.amber,
                            borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                          ),
                          height: MediaQuery.of(context).size.height*0.04,
                          width: MediaQuery.of(context).size.width*0.45,
                          child: FlatButton(onPressed: (){
                            print(MediaQuery.of(context).size.aspectRatio);
                          }, child: Text('立即开门',style: TextStyle(color: Colors.white),)),
                        ),
                      ],
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