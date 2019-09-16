import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import "package:english_words/english_words.dart";
import 'timetransfer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

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
  int page = 1;
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];
  Api api = new Api();
  int type = 0;
  int total = 0;
  AMapLocation _loc ;
  String wicon = 'images/weather/999.png';
  String weather = '';

  Page() {
    getR();
    getIconsData();
    getNewsData(1, 0);
    AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters))
        .catchError((error) {
      print(error);
    });
    _checkPersmission().then((val){

      if(_loc!=null){
        print(_loc.city);
        print('1');
        Dio().get(api.getWeatherForecast+"?position=${_loc.city}").then((response){
          if(response.statusCode==200){
            var data = response.data;
            if(data['code']==200){
//              var Htr = data['data'];
              var now = data['data'][0];
              print(now);
              if(now!=null){
                setState(() {
                  weather = '${now['now']['tmp']}℃';
                  wicon = 'images/weather/${now['now']['cond_code']}.png';
                });
              }
            }
          }

        });
      }
    });
  }

  int _current = 0;

  void getR() {
    Dio().request(api.getHRotation + '?rotationType=5').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        setState(() {
          _imageUrls = content['data'];
          print(_imageUrls);
        });
      }
    });
  }
  _checkPersmission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.denied) {
      Map<PermissionGroup,
          PermissionStatus> permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);
      if (permissions[PermissionGroup.location] == PermissionStatus.denied) {

      }
    }
    AMapLocation loc = await AMapLocationClient.getLocation(true);
    setState(() {
      _loc = loc;
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
    print(url);
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content);
        setState(() {
          _news = content['data'];
          total = content['total'];
        });
      }
    });
  }
  getNewsDatas(int page, int type) {
    var url = api.information + '?start=$page&length=10';
    if (type != 0) {
      url = api.information + '?start=$page&inforClassId=$type&length=10';
    }
    print(url);
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content);
        setState(() {
          _news.addAll(content['data']);
//          total = content['total'];
        });
      }
    });
  }

  getNews(int page, int type) {
//    print('dad');
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
          height: 75,
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  type = list[i]['inforClassId'];
                  getNewsData(1, list[i]['inforClassId']);
                },
                disabledColor: Colors.white,
                child: Container(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(list[i]['inforClassPicture']),
                  ),
                  width: 45,
                  height: 45,
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
      appBar: AppBar(title: Text('兴宁头条'),
        centerTitle: true, elevation: 0,actions: <Widget>[
        ImageIcon(AssetImage(wicon),color: Color.fromRGBO(243, 200, 70, 1),size: 30,),
        Center(child: Container(
          child: Text(weather,style: TextStyle(color:Color.fromRGBO(243, 200, 70, 1)),),
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
        ),),
      ],backgroundColor: Colors.white,),
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
                          return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                child: Image.network(
                                  url['rotationPicture'],
                                  fit: BoxFit.cover,
                                  width: 1000.0,
                                ),
                              ),
                            ),
                            onTap: (){
                              if(url['rotationLink']!=null){
                                Navigator.of(context).pushNamed("reading",
                                    arguments: int.parse(url['rotationLink']));
                              }
                            },
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                children: map<Widget>(_icons, (index, type) {
                  return Container(
                    width: _current == index ? 12.0 : 6.0,
                    height: 6.0,
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: _current == index
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(240, 200, 70, 1)
                          : Color.fromRGBO(0, 0, 0, 0.2),
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
                    //强制高度为50.0
                    itemBuilder: (BuildContext context, int index) {
                      if(index==_news.length-1&&_news.length!=total){
                        _retrieveData();
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(strokeWidth: 2.0)
                          ),
                        );
                      }
                      return InkWell(child: GestureDetector(
                        child: Container(
//                          color: Colors.red,
                          height: 110,
                          child: Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(10, 10, 0, 0),child: Container(

                                width: MediaQuery.of(context).size.width-140,
//                    color: Colors.amber,
                                child: Column(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0),child: Container(
//                                      color: Colors.orange,
                                        height: 65,
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(_news[index]['inforTitle']
                                          ,style: TextStyle(fontSize: 18,),maxLines: 2,overflow: TextOverflow.ellipsis,)
                                    ),),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width,
//                          color: Colors.blue,
                                      child: Row(
                                        children: <Widget>[
                                          Container(child: ImageIcon(AssetImage('images/see.png'),size: 10,color: Colors.grey,),width: 30,),
                                          Container(child: Text(_news[index]['count'].toString(),overflow: TextOverflow.clip,style: TextStyle(fontSize: 12,color: Colors.grey),),width: 60,),
                                          Container(
                                            width: MediaQuery.of(context).size.width*0.5-170,
                                            alignment: Alignment.center,
                                            child: Text(_news[index]['inforKey'],style: TextStyle(fontSize: 12,color: Colors.grey),),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width*0.5-80,
                                            alignment: Alignment.centerRight,
                                            child: Text(RelativeDateFormat.format(
                                                DateTime.parse(
                                                    _news[index]['createTime'])),style: TextStyle(fontSize: 12,color: Colors.grey),),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),),
                              Padding(padding: EdgeInsets.fromLTRB(0, 10, 10, 10),child: Container(
                                width: 120,
                                height: 96,
                                decoration: BoxDecoration(
//                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    image: DecorationImage(
                                        image: NetworkImage(_news[index]['image'][0]==null?'':_news[index]['image'][0]),fit: BoxFit.cover)
                                ),
                              ),)
                            ],
                          ),
                        ),

                        onLongPress: (){},
                      ),onTap: () {
                        Navigator.of(context).pushNamed("reading",
                            arguments: _news[index]['inforId']);
                      },);
                    })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print(total);
      }),
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
      getNews(page+1, type);
      setState(() {
        page = page+1;
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
