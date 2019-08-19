import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api.dart';

class ServicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Page();
  }
}

class Page extends State<ServicePage> {
  Page() {
    getR();
  }

  var _imageUrls = [];

  Api api = new Api();

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
        body: SafeArea(
            child: Container(
//      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: <Widget>[
          Container(
            //修饰黑色背景与圆角
            decoration: new BoxDecoration(
              color: Colors.grey[100],
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            ),
            alignment: Alignment.center,
            height: 30,
            width: MediaQuery.of(context).size.width - 30,
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: new EdgeInsets.only(left: 0.0),
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "搜索周边服务",
                  hintStyle: new TextStyle(fontSize: 14, color: Colors.grey)),
              style: new TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Container(
            child: _imageUrls.length == 0
                ? null
                : CarouselSlider(
                    viewportFraction: 1.0,
                    aspectRatio: 2.0,
                    height: MediaQuery.of(context).size.height * 0.25,
                    items: _imageUrls.map(
                      (url) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.network(
                              url['rotationPicture'],
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    autoPlay: true,
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width)/4,
//                  height: MediaQuery.of(context).size.height*0.06,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "outseller");
                        },
                        disabledColor: Colors.white,
                        child: Image(
                          image: AssetImage('images/outseller.png'),
                          width: 50,
                        ),
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text('美食外卖')
                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width)/4,
//                  height: MediaQuery.of(context).size.height*0.06,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "life");
                        },
                        disabledColor: Colors.white,
                        child: Image(
                          image: AssetImage('images/life.png'),
                          width: 50,
                        ),
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text('便利生活')
                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width)/4,
//                  height: MediaQuery.of(context).size.height*0.06,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "stayPage");
                        },
                        disabledColor: Colors.white,
                        child: Image(
                          image: AssetImage('images/house.png'),
                          width: 50,
                        ),
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text('酒店住宿')
                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width)/4,
//                  height: MediaQuery.of(context).size.height*0.06,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          print('click');
                        },
                        disabledColor: Colors.white,
                        child: Image(
                          image: AssetImage('images/outseller.png'),
                          width: 50,
                        ),
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text('医院挂号')
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    )));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('首页'));
  }

  Widget header(BuildContext context) {
    return new Image.network(
      'http://i2.yeyou.itc.cn/2014/huoying/hd_20140925/hyimage06.jpg',
    );
  }

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
}
