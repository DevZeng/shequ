import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api.dart';
import 'model.dart';
import 'page_web.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';


class ServicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Page();
  }
}

class Page extends State<ServicePage> {
  AMapLocation _loc;
  Api api = new Api();
  var lists = [];

  Page() {
    getR();
    AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters))
        .catchError((error) {
      print(error);
    });
    _checkPersmission().then((val){

      if(_loc!=null){
        Dio().get(api.getSearchHShopMsg+"?log=${_loc.longitude}&lat=${_loc.latitude}").then((response){
          setState(() {
            lists = response.data['data'];
          });
        });
      }
    });
  }


  var _imageUrls = [];



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
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    //修饰黑色背景与圆角
                    decoration: new BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(50.0)),
                    ),
                    alignment: Alignment.center,
                    height: 30,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 30,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.only(left: 0.0),
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                          hintText: "搜索周边服务",
                          hintStyle: new TextStyle(
                              fontSize: 14, color: Colors.grey)),
                      style: new TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),),
                  Container(
                    child: _imageUrls.length == 0
                        ? null
                        : CarouselSlider(
                      viewportFraction: 1.0,
                      aspectRatio: 2.0,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.25,
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
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width) / 4,
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
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width) / 4,
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
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width) / 4,
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
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width) / 4,
//                  height: MediaQuery.of(context).size.height*0.06,
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  getLink();
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
                  ),
                  Container(child: Text('附近推荐',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),width: MediaQuery.of(context).size.width,padding: EdgeInsets.fromLTRB(15, 15, 15, 0),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: lists.length,
                        itemBuilder: (context,index){
                      return GestureDetector(child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          width: 120,
                          height: 160,
//          color: Colors.red,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1,color: Colors.grey[200]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[100],
//                    blurRadius: 2.0,
//                    spreadRadius: 1.0,
                                offset: Offset(-1.0, 1.0),
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),child: Container(
                                width: 80,
                                height: 80,
//                              color: Colors.blueGrey,
                                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(lists[index]['shopThumbnail']),fit: BoxFit.cover)),
                              ),),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                alignment: Alignment.center,
                                child: Text(lists[index]['shopName'],style: TextStyle(fontSize: 18),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
//                alignment: Alignment.center,
//                              color: Colors.red,
                                child: Row(
                                  children: <Widget>[
                                    Container(child: Icon(Icons.location_on,size: 12,)),
                                    Container(child: Text('${lists[index]['shopDistance']}m'))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),),onTap: (){
                        switch(lists[index]['shopType']){
                          case 1:
                            Navigator.of(context).pushNamed('outsellerDetail',arguments: lists[index]['shopId']);
                            break;
                          case 2:
                            Navigator.of(context).pushNamed("lifeStore", arguments: lists[index]['shopId']);
                            break;
                          case 3:
                            Navigator.of(context).pushNamed('stayDetail',arguments: {
                              'id':lists[index]['shopId'],
                              'indate':DateTime.now(),
                              'outdate':DateTime.now().add(new Duration(days: 1)),
                            });
                            break;
                        }
//                        print('dafa');
                      },);
                    }),
                  )
                ],
              ),
            )),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print(lists);
      }),
    );
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

  void getLink() async {
    String url = '';
    getUser().then((val) {
      Dio().get(api.getUserInfo + "?token=$val").then((response) {
        var data = response.data;
        print(data);
        if (data['code'] == 200) {
          Dio()
              .get(api.appRegisterController +
              "?idcard=${data['data']['userMsgIdcard']}&&mobile=${data['data']['userMsgPhone']}&&patientName=${data['data']['userMsgName']}&&uid=${data['data']['userMsgId']}")
              .then((response) {
            data = response.data;
            print(data);
            if (data['code'] == 200) {
              print(data['data']);
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) {
                    return new NewsWebPage(
                        data['data'].toString(), '医院挂号'); //link,title为需要传递的参数
                  },
                  ));
            }
          });
        }
        print(response);
      });
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
}