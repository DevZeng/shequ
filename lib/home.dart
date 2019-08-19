import 'package:flutter/material.dart';
//import 'package:simple_slider/simple_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api.dart';
import 'package:dio/dio.dart';
import 'page_news.dart';
import 'page_service.dart';
import 'page_OpenDoor.dart';
import 'page_personal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Api api = new Api();
  var _imageUrls = [];

  var _icons = [];
  var news = [];
  var _pageList;
  int _current = 0;
  String user;

  _MyHomePageState() {
    getUser();
    _pageList = [
      new NewsPage(),
      new ServicePage(),
      new OpenDoorPage(),
      new PersonalPage(),
    ];
  }
  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    // TODO: implement didUpdateWidget
    print('update');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pageList[_current],
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('兴宁头条')),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('生活服务')),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/open.png')),
              activeIcon: ImageIcon(AssetImage('images/open_click.png')),
              title: Text('一键开门')),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('个人中心')),
        ],
        selectedItemColor: Colors.orange,
        onTap: (index) => {
              setState(() {
                _current = index;
              })
            },
        currentIndex: _current,
      ),
    );
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    setState(() {
      user = user;
    });
  }
}
