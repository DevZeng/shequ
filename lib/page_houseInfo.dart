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
  List<String> types = ['家庭成员', '户主', '工人', '租客'];
  String image = '';
  Api api = new Api();
  int _index = 0;
  var info = [
    {'a': 'aa', 'b': 'bb', 'c': 'cc'},
    {'a': 'qq', 'b': 'ww', 'c': 'ee'},
    {'a': 'rr', 'b': 'tt', 'c': 'yy'}
  ];
  Page(){
    getInfos();
  }
  getInfos() {
    getUser().then((val){
      Dio().get(api.getHHouseUserHold+'?token=$val').then((response){
        var data = response.data;
        if(data['code']==200){
          print(data['data']);
          image = data['data']['imageAddress']==null?'':data['data']['imageAddress'];
          var listMsg = data['data']['listMsg'];
          if(listMsg!=null){
            listMsg.forEach((list){
//              print(list);
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
              houseInfos.add(houseInfo);
            });
          }
          setState(() {
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
        elevation: 0,
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('addHouseInfo', arguments: new HouseInfo());
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
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          )
                  ):Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image: NetworkImage(
                                image),
                            fit: BoxFit.fill)),
                  )),
              Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
              Container(
                child: CarouselSlider(
                  height: 230,
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
              houseInfos.length<=1?Container():Padding(padding: EdgeInsets.fromLTRB(15, 20, 15, 0),child:Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40.0,
                child: new RaisedButton(
                  onPressed: () {
                    saveHold(houseInfos[_index].id);
                    saveXq(houseInfos[_index].holdXqId);
                    Fluttertoast.showToast(
                        msg: "切换成功！",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  },
                  color: Colors.orange,
                  child: new Text("切换",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  shape: new StadiumBorder(
                      side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xffFF7F24),
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
                    Navigator.of(context).pushNamed('addHouseInfo',arguments: houseInfos[_index]);
//          print(detailController.text);
//          print(index);
                  },
                  color: Colors.orange,
                  child: new Text("修改",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  shape: new StadiumBorder(
                      side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xffFF7F24),
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
}
