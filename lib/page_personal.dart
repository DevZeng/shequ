import 'package:flutter/material.dart';
import 'api.dart';
import 'model.dart';
import 'package:dio/dio.dart';

class PersonalPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PersonalPage();
  }
}

class _PersonalPage extends State<PersonalPage> {
  String imgUrl = '';
  String userName = '';
  Api api = new Api();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    getInfos();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
        child: Container(
//        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: <Widget>[
              Container(
                  height: 160,
                  color: Colors.yellow,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 160,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(40, 20, 0, 0),
                              width:
                              MediaQuery.of(context).size.width * 0.3,
//                              color: Colors.green,
                              height: 100,
                              child: GestureDetector(
                                child: CircleAvatar(backgroundImage: NetworkImage(imgUrl),),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('userInfo').then((val){
                                    getUserInfo();
                                  });
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                              width:
                              MediaQuery.of(context).size.width * 0.4,
//                              color: Colors.green,
                              height: 100,
//                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(userName,style: TextStyle(color: Colors.white,fontSize: 18),),
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                  )
                                ],
                              ),
                            ),
//                            Container(
//                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                              width:
//                              MediaQuery.of(context).size.width * 0.3,
////                              color: Colors.green,
//                              height: 100,
//                              alignment: Alignment.centerRight,
//                              child: FlatButton.icon(
//                                  onPressed: null,
//                                  icon: Icon(Icons.add),
//                                  label: Text('dd')),
//                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset: Offset(-1.0, 1.0),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
//                color: Colors.white,
                  height: 112,
                  width: MediaQuery.of(context).size.width-20 ,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 1 / 3 -
                              10,
                          height: 72,
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('family');
                                },
                                disabledColor: Colors.white,
                                child: Image(
                                  image: AssetImage(
                                      'images/homemember.png'),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Text('家庭成员')
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 1 / 3 -
                              10,
                          height: 72,
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "visitorePage");
                                },
                                disabledColor: Colors.white,
                                child: Image(
                                  image:
                                  AssetImage('images/visitors.png'),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Text('访客管理')
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 1 / 3 -
                              10,
                          height: 72,
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('money');
                                },
                                disabledColor: Colors.white,
                                child: Image(
                                  image:
                                  AssetImage('images/moneypacket.png'),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Text('钱包')
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                        offset: Offset(-1.0, 1.0),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text(
                        '我的订单',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width:
                              MediaQuery.of(context).size.width * 1 / 3 - 10,
                              height: 72,
                              child: Column(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('outsellerOrderPage');
                                    },
                                    disabledColor: Colors.white,
                                    child: Image(
                                      image: AssetImage(
                                          'images/order_outseller.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  Text('外卖订单')
                                ],
                              )),
                          Container(
                              width:
                              MediaQuery.of(context).size.width * 1 / 3 - 10,
                              height: 72,
                              child: Column(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "lifeOrderPage");
                                    },
                                    disabledColor: Colors.white,
                                    child: Image(
                                      image: AssetImage('images/order_life.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  Text('便利店订单')
                                ],
                              )),
                          Container(
                              width:
                              MediaQuery.of(context).size.width * 1 / 3 - 10,
                              height: 72,
                              child: Column(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('stayOrderPage');
                                    },
                                    disabledColor: Colors.white,
                                    child: Image(
                                      image: AssetImage('images/order_stay.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  Text('酒店订单')
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                      offset: Offset(-1.0, 1.0),
                    )
                  ],
                ),
//              color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('住户信息'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/info.png')),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "listHouseInfo");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('我的地址'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/address.png')),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "listAddress");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('缴费服务'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/needpay.png')),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "needPay");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('报修预约'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/repair.png')),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "repairPage");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('社区通知'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/notify.png')),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "notifications");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('投诉建议'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/report.png')),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "report");
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        getUser().then((val){
          print(val);
        });
      }),
    );
  }
  void getUserInfo() async {
    getUser().then((val) {
      if(val==null){
        Navigator.of(context).pushNamed('login');
        return;
      }
      Dio().request(api.getUserInfo + '?token=$val').then((response) {
        var data = response.data;
        print(data);
        if (data['code'] == 200) {
          setState(() {
            imgUrl = data['data']['userMsgHead'];
            userName = data['data']['userMsgNike'];
          });
        }else if(data['code'] == 0){
          Navigator.of(context).pushNamed('login');
        }
      });
    });
  }
  getInfos() async {
    getHold().then((val){
      if(val==null){
        getUser().then((val){
          Dio().get(api.getHHouseUserHold+'?token=$val').then((response){
            var data = response.data;
            if(data['code']==200){
              print(data['data']);
              var listMsg = data['data']['listMsg'];
              if(listMsg!=null){
                for (var element in listMsg) {
                  print(element['holdId']);
                  if (element['holdStatus']==1){
                    saveXq(element['holdXqId']);
                    saveHold(element['holdId']);
                    saveAddress("${element['holdXqName']}${element['holdLdName']}${element['holdDyName']}");
                    break;
                  }
                }
              }
            }
          });
        });
      }
    });
  }
}
