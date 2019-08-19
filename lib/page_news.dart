import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import "package:english_words/english_words.dart";
import 'timetransfer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Page();
  }
}

class Page extends State<NewsPage> {
  var _imageUrls = [];

  var _icons = [];
  var _news = [];
  int page = 0;
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];
  Api api = new Api();
  int type = 0;

  Page() {
    getR();
    getIconsData();
    getNewsData(1, 0);
  }

  int _current = 0;

  void getR() {
    Dio().request(api.getHRotation + '?rotationType=1').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        setState(() {
          _imageUrls = content['data'];
        });
      }
    });
  }

  void getIconsData() {
    Dio().request(api.informationClass + '?length=4').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        setState(() {
          _icons = content['data'];
        });
      }
    });
  }

  getNewsData(int page, int type) {
    var url = api.information + '?start=$page&length=10';
    if (type != 0) {
      url = api.information + '?start=$page&inforClassId=$type&length=10';
    }
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content);
        setState(() {
          _news = content['data'];
        });
      }
    });
  }

  getNews(int page, int type) {
    print('dad');
    var url = api.information + '?start=$page&length=10';
    if (type != 0) {
      url = api.information + '?start=$page&inforClassId=$type&length=10';
    }
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content);
        setState(() {
          _news.addAll(content['data']);
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
          height: 70,
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  type = list[i]['inforClassId'];
                  getNewsData(1, list[i]['inforClassId']);
                },
                disabledColor: Colors.white,
                child: Image(
                  image: NetworkImage(list[i]['inforClassPicture']),
                  width: 50,
                  height: 50,
                ),
              ),
              Text(list[i]['inforClassName'])
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('兴宁头条'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 15.0),
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
            CarouselSlider(
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              height: 80,
              items: map<Widget>(_icons, (index, icons) {
                return Container(
                  child: Row(
                    children: getIcons(icons).toList(),
                  ),
                );
              }).toList(),
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(types, (index, type) {
                  return Container(
                    width: _current == index ? 12.0 : 6.0,
                    height: 6.0,
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: _current == index
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                      borderRadius:
                          _current == index ? BorderRadius.circular(3.0) : null,
                    ),
                  );
                })),
            Container(
              color: Colors.white,
              child:
                  Padding(padding: EdgeInsets.all(1.0), child: new Divider()),
            ),
            _news.length == 0
                ? Container(
                    child: Text('暂无数据'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _news.length,
                    itemExtent: MediaQuery.of(context).size.height * 0.2,
                    //强制高度为50.0
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 15, 5),
                                child: Text(
                                  _news[index]['inforTitle'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                  child: Row(
                                      children:
                                          buildList(_news[index]['image']))),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Row(
                                        children: <Widget>[
                                          ImageIcon(
                                            AssetImage('images/see.png'),
                                            color: Colors.grey[400],
                                          ),
                                          Text(
                                            ' ' +
                                                _news[index]['count']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.grey[400]),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                              0.6 -
                                          15,
                                      child: Text(
                                        _news[index]['inforKey'] != null
                                            ? _news[index]['inforKey']
                                            : '',
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        RelativeDateFormat.format(
                                            DateTime.parse(
                                                _news[index]['createTime'])),
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed("reading",
                              arguments: _news[index]['inforId']);
                        },
                      );
                    })
          ],
        ),
      ),

    );
  }

  List<Widget> buildList(urls) {
    List<Widget> widgets = [];
    var count = urls.length > 3 ? 3 : urls.length;
    for (var i = 0; i < count; i++) {
      widgets.add(Container(
        width: MediaQuery.of(context).size.width * 1 / 3 - 20,
        height: MediaQuery.of(context).size.height * 0.08,
        child: null,
        margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
        decoration: BoxDecoration(
          image: new DecorationImage(
              image: new NetworkImage(urls[i]), fit: BoxFit.fill),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//          color: Colors.black
        ),
      ));
    }
    return widgets;
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList());
      setState(() {
        //重新构建列表
      });
    });
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('首页'));
  }

  Widget header(BuildContext context) {
    return new Image.network(
      'http://i2.yeyou.itc.cn/2014/huoying/hd_20140925/hyimage06.jpg',
    );
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    return user;
  }
}
