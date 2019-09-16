import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api.dart';
import 'model.dart';
import 'page_web.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'page_login.dart';


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
        print('1');
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
            child: SingleChildScrollView(
//      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: GestureDetector(
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
                          .width - 20,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.search),
                          Text('搜索周边服务')
                        ],
                      ),
//                    child: TextField(
//                      decoration: InputDecoration(
//                          contentPadding: new EdgeInsets.only(left: 0.0),
//                          border: InputBorder.none,
//                          icon: Icon(Icons.search),
//                          hintText: "搜索周边服务",
//                          hintStyle: new TextStyle(
//                              fontSize: 14, color: Colors.grey)),
//                      style: new TextStyle(fontSize: 14, color: Colors.grey),
//                    ),
                    ),
                    onTap: (){
                      checkLogin();
                      Navigator.of(context).pushNamed('search');
                    },
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
                          return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
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
                              switch(url['rotationType']){
                                case 2:
                                  if(url['rotationLink']!=null&&url['rotationLink'].length!=0){
                                    checkLogin();
                                    Navigator.of(context).pushNamed('outsellerDetail',arguments: int.parse(url['rotationLink']));
                                  }
                                  break;
                                case 3:
                                  if(url['rotationLink']!=null&&url['rotationLink'].length!=0){
                                    checkLogin();
                                    Navigator.of(context).pushNamed("lifeStore", arguments: int.parse(url['rotationLink']));
                                  }

                                  break;
                                case 4:
                                  if(url['rotationLink']!=null&&url['rotationLink'].length!=0){
                                    checkLogin();
                                    Navigator.of(context).pushNamed('stayDetail',arguments: {
                                      'id':int.parse(url['rotationLink']),
                                      'indate':DateTime.now(),
                                      'outdate':DateTime.now().add(new Duration(days: 1)),
                                    });
                                  }

                                  break;
                              }
                            },
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
                                  checkLogin();
                                  Navigator.pushNamed(context, "outseller",arguments: {
                                    'lat':_loc==null?0:_loc.latitude,
                                    'lon':_loc==null?0:_loc.longitude
                                  });
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
                                  checkLogin();
                                  Navigator.pushNamed(context, "life",arguments: {
                                    'lat':_loc==null?0:_loc.latitude,
                                    'lon':_loc==null?0:_loc.longitude
                                  });
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
                                  checkLogin();
                                  Navigator.pushNamed(context, "stayPage",arguments: {
                                    'lat':_loc==null?0:_loc.latitude,
                                    'lon':_loc==null?0:_loc.longitude
                                  });
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
                  Wrap(
                    spacing: 8.0, // 主轴(水平)方向间距
                    runSpacing: 8.0, // 纵轴（垂直）方向间距
                    alignment: WrapAlignment.start,
                    children: lists.map((item){
                      return GestureDetector(child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          width: 120,
                          height: 165,
//          color: Colors.red,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                decoration: BoxDecoration(

                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(image: NetworkImage(item['shopThumbnail']),fit: BoxFit.cover)),
                              ),),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                                alignment: Alignment.center,
                                child: Text(item['shopName'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
//                alignment: Alignment.center,
//                              color: Colors.red,
                                child: Row(
                                  children: <Widget>[
                                    Container(child: Icon(Icons.location_on,color: Color.fromRGBO(243, 200, 70, 1),size: 12,)),
                                    Container(child: Text(getDistance(item['shopDistance']),style: TextStyle(color: Colors.grey),))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),),onTap: (){
                        switch(item['shopType']){
                          case 1:
                            checkLogin();
                            Navigator.of(context).pushNamed('outsellerDetail',arguments: item['shopId']);
                            break;
                          case 2:
                            checkLogin();
                            Navigator.of(context).pushNamed("lifeStore", arguments: item['shopId']);
                            break;
                          case 3:
                            checkLogin();
                            Navigator.of(context).pushNamed('stayDetail',arguments: {
                              'id':item['shopId'],
                              'indate':DateTime.now(),
                              'outdate':DateTime.now().add(new Duration(days: 1)),
                            });
                            break;
                        }
//                        print('dafa');
                      },);
                    }).toList(),
                  ),
//                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
//                  Container(
//                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                    height: 180,
//                    child: lists==null?null:ListView.builder(
//                      scrollDirection: Axis.horizontal,
//                      itemCount: lists.length,
//                        itemBuilder: (context,index){
//                      return ;
//                    }),
//                  )
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
    Dio().request(api.getHRotation + '?type=1').then((response) {
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
      print(val);
      Dio()
          .get(api.appRegisterController +
          "?token=${val}")
          .then((response) {
        var data = response.data;
        print(data);
        if (data['code'] == 200) {
          print(data['data']);
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) {
                return new NewsWebPage(
                    data['data'].toString(), '医院挂号'); //link,title为需要传递的参数
              },
              ));
        }else{
          Fluttertoast.showToast(
              msg: data['msg'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.of(context)
              .pushNamed('userInfo');
        }
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
  checkLogin() {
    getUser().then((val){
      if(val==null){
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new LoginPage()
            ), (route) => route == null);
        return;
      }
      print('da');
      var fromData = {'token':val};
      Dio().post(api.testingToken,data: fromData).then((response){
        if(response.statusCode==200){
          var data = response.data;
          if(data['code']==200){
            saveMember(data['data']['userMsgType']);
            print('test');
            return;
          }else{
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new LoginPage()
                ), (route) => route == null);
          }
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => new LoginPage()
              ), (route) => route == null);
        }
      }).catchError((error){Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new LoginPage()
          ), (route) => route == null);});
    });
  }
}