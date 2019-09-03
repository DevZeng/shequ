import 'package:flutter/material.dart';
import 'api.dart';
import 'model.dart';
import 'package:dio/dio.dart';
import 'page_login.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  String login = '请登录';
  int state = 0;
  Api api = new Api();
  int member = 0;
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
                  height: 165,
                  color: Color.fromRGBO(243, 200, 70, 1),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 160,
                        child: Row(
                          children: <Widget>[
                            Container(
//                              padding: EdgeInsets.fromLTRB(40, 20, 0, 0),
                              width:
                              MediaQuery.of(context).size.width * 0.3,
//                              color: Colors.green,
                              height: 100,
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(imgUrl),child: Text(login),backgroundColor: Colors.white,foregroundColor: Colors.grey,),
                                  width: 80,
                                  height: 80,
                                ),
                                onTap: () {
                                  checkLogin();
//                                  print()
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
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        ImageIcon(AssetImage('images/card.png'),color: Colors.white,size: 16,),
                                        Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Text(state==0?'未完善信息':'已完善信息',style: TextStyle(color: Colors.white),),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                              width:
                              MediaQuery.of(context).size.width * 0.3,
//                              color: Colors.green,
                              height: 100,
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 35,

                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                  shape: BoxShape.rectangle,
borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft:Radius.circular(50) )
//                                  border: B
                                ),
                                child: FlatButton.icon(onPressed: null, icon: ImageIcon(AssetImage('images/member.png'),color: Colors.white,), label: Text(member==1?'会员':'非会员',style: TextStyle(color: Colors.white),)),
                              ),
                            )
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
                                  checkLogin();
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
                                  checkLogin();
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
                                  checkLogin();
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
                                      checkLogin();
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
                                      checkLogin();
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
                                      checkLogin();
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
                        child: ImageIcon(AssetImage('images/info.png'),color: Color.fromRGBO(243, 200, 70, 1),),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        checkLogin();
                        Navigator.pushNamed(context, "listHouseInfo");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('我的地址'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/address.png'),color: Color.fromRGBO(243, 200, 70, 1),),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        checkLogin();
                        Navigator.pushNamed(context, "listAddress");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('缴费服务'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/needpay.png'),color: Color.fromRGBO(243, 200, 70, 1),),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        checkLogin();
                        Navigator.pushNamed(context, "needPay");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('报修预约'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/repair.png'),color: Color.fromRGBO(243, 200, 70, 1),),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        checkLogin();
                        Navigator.pushNamed(context, "repairPage");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('社区通知'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/notify.png'),color: Color.fromRGBO(243, 200, 70, 1),),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        checkLogin();
                        Navigator.pushNamed(context, "notifications");
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('投诉建议'),
                      leading: Container(
                        child: ImageIcon(AssetImage('images/report.png'),color: Color.fromRGBO(243, 200, 70, 1),),
                        width: MediaQuery.of(context).size.width * 0.1 - 15,
                      ),
                      trailing: Text(
                        '>',
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        checkLogin();
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
//        Navigator.of(context).pushNamed('login');
        return;
      }
      Dio().request(api.getUserInfo + '?token=$val').then((response) {
        var data = response.data;
        print(data);
        if (data['code'] == 200) {
          saveMember(data['data']['userMsgType']);
          setState(() {
            imgUrl = data['data']['userMsgHead'];
            userName = data['data']['userMsgNike'];
            state = data['data']['userMsgStatus'];
            login = '';
            member = data['data']['userMsgType'];

          });
        }else if(data['code'] == 0){
          Fluttertoast.showToast(
              msg:data['msg'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
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
