import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model.dart';
import 'api.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HouseInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<HouseInfoPage> {
  List<HouseInfo> houseInfos = [];
  List<String> types = ['家庭成员', '户主', '管理人员', '租客'];
  List<String> status = ['待审核', '已通过', '不通过', '租客'];
  String image = '';
  Api api = new Api();
  int _index = 0;
  int defaultHold;
  var info = [
    {'a': 'aa', 'b': 'bb', 'c': 'cc'},
    {'a': 'qq', 'b': 'ww', 'c': 'ee'},
    {'a': 'rr', 'b': 'tt', 'c': 'yy'}
  ];
  Page(){
    getInfos();
    getHold().then((val){
      setState(() {
        defaultHold = val;
      });
    });
//    getHold().then((val){
//      if(val==null){
//        if(houseInfos.length!=0){
//          saveHold(houseInfos[0].id);
//        }
//      }
//    });
  }
  getInfos() {
    List<HouseInfo> infos = [];
    getUser().then((val){
      Dio().get(api.getHHouseUserHold+'?token=$val').then((response){
        var data = response.data;
        if(data['code']==200){
          print(data['data']);
          image = data['data']['imageAddress']==null?'':data['data']['imageAddress'];
          var listMsg = data['data']['listMsg'];
          if(listMsg!=null){
            listMsg.forEach((list){
              print(list);
              HouseInfo houseInfo = new HouseInfo();
              houseInfo.imageAddress = image;
              houseInfo.holdIdentity = list['holdIdentity'];
              houseInfo.holdXqId = list['holdXqId'];
              houseInfo.holdXq = list['holdXqName'];
              houseInfo.holdLd = list['holdLdName'];
              houseInfo.holdLdId = list['holdLdId'];
              houseInfo.holdDy = list['holdDyName'];
              houseInfo.holdDyId = list['holdDyId'];
              houseInfo.id = list['holdId'];
              houseInfo.state = list['holdStatus'];
              infos.add(houseInfo);
            });
          }
          setState(() {
            houseInfos = infos;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('住户信息'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('addHouseInfo', arguments: new HouseInfo()).then((val){
                  getInfos();
                });
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
//          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: houseInfos.length==0?Container(
                    width: 120,
                    height: 120,
//                    color: Colors.red,
                    child:IconButton(icon: Icon(Icons.add,size: 50,), onPressed: (){
                      Navigator.of(context)
                          .pushNamed('addHouseInfo', arguments: new HouseInfo()).then((val){
                            getInfos();
                      });
                    }),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 200, 70, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          )
                  ):Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 200, 70, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image: NetworkImage(
                                image),
                            fit: BoxFit.cover)),
                  )),
              Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
              Container(
                child: CarouselSlider(
                  height: 290,
                  viewportFraction: 1.0,
                  aspectRatio: 2.0,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  reverse: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (index){
                    setState(() {
                      _index = index;
                    });
                  },
                  items: map<Widget>(houseInfos,(index,houseInfo){
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Text('身份类型'),
                            trailing: Text(types[houseInfo.holdIdentity]),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Text('小区名'),
                            trailing: Text(houseInfo.holdXq),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Text('楼栋号'),
                            trailing: Text(houseInfo.holdLd),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Text('单元号'),
                            trailing: Text(houseInfo.holdDy),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Text('状态'),
                            trailing: Text(status[houseInfo.state]),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    );
                  }),
                ),
              ),
              houseInfos.length<=1&&defaultHold!=null?Container():Padding(padding: EdgeInsets.fromLTRB(15, 20, 15, 0),child:Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40.0,
                child: new RaisedButton(
                  onPressed: () {
                    switchHold(houseInfos[_index]);
                  },
                  color: Color.fromRGBO(243, 200, 70, 1),
                  child: new Text("切换",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  shape: new StadiumBorder(
                      side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Color.fromRGBO(243, 200, 70, 1),
                      )),
                ),
              ),),
              houseInfos.length==0?Container():Padding(padding: EdgeInsets.fromLTRB(15, 20, 15, 0),child:Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40.0,
                child: new RaisedButton(
                  onPressed: () {
//                    print(_index);
//                    print(houseInfos[_index].id);
                    Navigator.of(context).pushNamed('addHouseInfo',arguments: houseInfos[_index]).then((val){
                      setState(() {
                        houseInfos[_index].state = 0;
                      });
                    });
//          print(detailController.text);
//          print(index);
                  },
                  color: Color.fromRGBO(243, 200, 70, 1),
                  child: new Text("修改",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  shape: new StadiumBorder(
                      side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Color.fromRGBO(243, 200, 70, 1),
                      )),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
  switchHold(HouseInfo info){
    if(info.state==1){
      saveHold(info.id);
      saveXq(info.holdXqId);
      print(info.holdIdentity);
      saveHoldType(info.holdIdentity);
      saveAddress("${info.holdXq}${info.holdLd}${info.holdDy}");
      Dio().put(api.putHoldDefault,data: {'holdId':info.id}).then((response){
        print(response);
      });
      Fluttertoast.showToast(
          msg: "切换成功！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      setState(() {
        defaultHold = info.id;
      });
    }else{
      Fluttertoast.showToast(
          msg: "该状态不允许切换！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }

  }
}
