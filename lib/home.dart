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
    _retrieveData();
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
  void _retrieveData() {
    assert((){
      // Do something for debug
      print('这是asset下的输出内容');

      return true;
    }());
    Future.delayed(Duration(seconds: 1)).then((e) {
      print('debug');
      Dio().request('http://app.ankekan.com/getdebug').then((response) {
        if (response.statusCode == 200) {
          print(response);
          var data = response.data;
          if(data['return_code']=='OK'){
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => new Dialog(
                  child: new Container(
                    alignment: FractionalOffset.center,
                    height: 80.0,
//              padding: const EdgeInsets.all(20.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
//                  new CircularProgressIndicator(),
                        Text("当前版本为Debug版本，请更新到Release版本",maxLines: 3,overflow: TextOverflow.fade,)
                      ],
                    ),
                  ),
                ));
          }else{
            print('FAIL');
          }

        }else{
          print('dafd');
        }
      });

//      setState(() {
//        //重新构建列表
//      });
    });
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
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/tab1icon.png'),size: 16,), title: Text('兴宁头条')),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/tab2icon.png'),size: 16,), title: Text('生活服务')),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/open.png'),size: 16,),
              title: Text('一键开门')),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/tab4icon.png'),size: 16,), title: Text('个人中心')),
        ],
        selectedItemColor: Color.fromARGB(255, 243, 200, 70),
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
