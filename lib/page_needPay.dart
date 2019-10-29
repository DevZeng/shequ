import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NeedPayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<NeedPayPage>
    with SingleTickerProviderStateMixin{
  TabController _tabController; //需要定义一个Controller
  List tabs = ["物业费", "水费", "停车费"];
  var wuyes = [];
  var shuis = [];
  var cars = [];
  Api api = new Api();
  String token = '';
  int code = 1;
  int type = 0;
  int payid = 0;
  int holdType = 0 ;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getHoldType().then((val){
      setState(() {
        holdType = val;
      });
    });
    fluwx.responseFromPayment.listen((data) {
      loading = false;
      if(data.errCode==0){
        switch(type){
          case 1:
            wuyes[payid]['propertyStatus']=1;
            break;
          case 2:
            shuis[payid]['waterStatus']=1;
            break;
          case 3:
            cars[payid]['parkingStatus']=1;
            break;

        }

      }else{
        Fluttertoast.showToast(
            msg: "取消支付！",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      setState(() {
//        code = data.errCode;
      });
    });
    getUser().then((val) {
      token = val;
      getLists(1);
    });
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener((){
      switch (_tabController.index){
        case 0:
          getLists(1);
          break;
        case 1:
          getLists(2);
          break;
        case 2:
          getLists(3);
          break;
      }
    });
  }
  getLists(int type) async {
    Dio()
        .get(api.getDyHPayProperty + "?token=$token&&type=$type")
        .then((response) {
      var data = response.data;
      if (data['code'] == 200) {
        switch(type){
          case 1:
            wuyes = data['data'];
            break;
          case 2:
            shuis = data['data'];
            break;
          case 3:
            cars = data['data'];
            break;
        }
        setState(() {
        });
      }else if(data['code']==0){
        Navigator.of(context).pushNamed('login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('缴费服务'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: 18),
            controller: _tabController,
            labelColor: Color.fromRGBO(243, 200, 70, 1),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color.fromRGBO(243, 200, 70, 1),
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      body: ModalProgressHUD(inAsyncCall: loading, child: TabBarView(
        controller: _tabController,
        children: [
          //物业费
          ListView.builder(
              itemCount: wuyes.length,
              itemBuilder: (context,index){
                return Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 0),child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[100],
//                    blurRadius: 2.0,
//                    spreadRadius: 1.0,
                          offset: Offset(-1.0, 1.0),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width-30,

                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text('物业管理费',style: TextStyle(fontWeight: FontWeight.w700),),
                              width: MediaQuery.of(context).size.width*0.7-50,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(wuyes[index]['propertyStatus']==0?'未支付':'已支付',style: TextStyle(
                                  color: wuyes[index]['propertyStatus']==0?Colors.red:Colors.grey[300],
                                  fontSize: 12
                              ),),
                              width: MediaQuery.of(context).size.width*0.3,
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('住所：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text(wuyes[index]['propertyHouse'],style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width-160,
                            ),
                            Container(
//                          color: Colors.green,
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  Text('总计：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text('¥ '+wuyes[index]['propertyFee'].toString(),style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20
                                  ),)
                                ],
                              ),
                              width: 110,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('月份：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text(wuyes[index]['propertyMonth'],style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width-130,
                            ),
                            holdType!=1?Container():Container(
                              decoration: BoxDecoration(
                                  color: wuyes[index]['propertyStatus']==0?Color.fromRGBO(243, 200, 70, 1):Colors.grey[100],
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              height: 30,
                              width:80,
                              child: FlatButton(onPressed: (){
                                setState(() {
                                  type=1;
                                  payid = index;
                                });
                                payOrder(1, wuyes[index]['propertyId']);
                              },child: Text(wuyes[index]['propertyStatus']==0?'缴费':'已缴费'
                                ,style: TextStyle(color: wuyes[index]['propertyStatus']==0?Colors.white:Colors.grey[500]),),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),);
              }),
          ListView.builder(
              itemCount: shuis.length,
              itemBuilder: (context,index){
                return Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 0),child: Container(

                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[100],
//                    blurRadius: 2.0,
//                    spreadRadius: 1.0,
                          offset: Offset(-1.0, 1.0),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width-30,

                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text('水费',style: TextStyle(fontWeight: FontWeight.w700),),
                              width: MediaQuery.of(context).size.width*0.7-50,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(shuis[index]['waterStatus']==0?'未支付':'已付款',style: TextStyle(
                                  color: shuis[index]['waterStatus']==0?Colors.red:Colors.grey[300],
                                  fontSize: 12
                              ),),
                              width: MediaQuery.of(context).size.width*0.3,
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('住所：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text(shuis[index]['waterHouse'],style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width-160,
                            ),
                            Container(
//                          color: Colors.green,
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  Text('总计：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text('¥ '+shuis[index]['waterFee'].toString(),style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20
                                  ),)
                                ],
                              ),
                              width: 110,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('月份：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text(shuis[index]['waterMonth'],style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width-130,
                            ),
                            holdType!=1?Container():Container(
                              decoration: BoxDecoration(
                                  color: shuis[index]['waterStatus']==0?Color.fromRGBO(243, 200, 70, 1):Colors.grey[100],
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              height: 30,
                              width:80,
                              child: FlatButton(onPressed: (){
                                setState(() {
                                  type=2;
                                  payid = index;
                                });
                                payOrder(2, shuis[index]['waterId']);
                              },child: Text(shuis[index]['waterStatus']==0?'缴费':'已缴费'
                                ,style: TextStyle(color: shuis[index]['waterStatus']==0?Colors.white:Colors.grey[500]),),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),);
              }),
          ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context,index){
                return Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 0),child: Container(

                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[100],
//                    blurRadius: 2.0,
//                    spreadRadius: 1.0,
                          offset: Offset(-1.0, 1.0),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width-30,

                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(cars[index]['parkingNumber'],style: TextStyle(fontWeight: FontWeight.w700),),
                              width: MediaQuery.of(context).size.width*0.7-50,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(cars[index]['parkingStatus']==0?'未缴费':'已缴费',style: TextStyle(
                                  color: cars[index]['parkingStatus']==0?Colors.red:Colors.grey[300],
                                  fontSize: 12
                              ),),
                              width: MediaQuery.of(context).size.width*0.3,
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('车位：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text(cars[index]['parkingLot'],style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width-160,
                            ),
                            Container(
//                          color: Colors.green,
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  Text('总计：',style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  Text('¥ '+cars[index]['parkingFee'].toString(),style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20
                                  ),)
                                ],
                              ),
                              width: 110,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(cars[index]['parkingTime']),
//                                  Text(shuis[index]['waterMonth'],style: TextStyle(fontSize: 20),),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width-130,
                            ),
                            holdType!=1?Container():Container(
                              decoration: BoxDecoration(
                                  color: cars[index]['parkingStatus']==0?Color.fromRGBO(243, 200, 70, 1):Colors.grey[100],
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              height: 30,
                              width:80,
                              child: FlatButton(onPressed: (){
                                setState(() {
                                  type=3;
                                  payid = index;
                                });
                                payOrder(3, cars[index]['parkingId']);
                              },child: Text(cars[index]['parkingStatus']==0?'缴费':'已缴费'
                                ,style: TextStyle(color: cars[index]['parkingStatus']==0?Colors.white:Colors.grey[500]),),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),);
              }),
        ],
      )),
//      floatingActionButton: FloatingActionButton(onPressed: (){
//        print(cars);
//      }),
    );
  }
  payOrder(int type,int number) {
    var formData = {"token": token, "porderType": type, "proderNumber":number};
    Dio().post(api.postHPayOrder, data: formData).then((response) {
      if (response.statusCode == 200) {
        var data = response.data;
          print(data);
        if (data['code'] == 200) {
          var moId = data['data']['porderId'];
          var formData =
              '{"token": "$token", "orderid": "${moId}","orderType": 5}';
          print(formData);
          Dio()
              .post(api.wxpay, data: formData)
              .then((response) {
//                                  print(response);
            data = response.data;
            print(data);
            if (data['code'] == 200) {
              setState(() {
                loading = true;
              });
              data = jsonDecode(data['data']);
              fluwx
                  .pay(
                  appId: data['appid']
                      .toString(),
                  partnerId: data['partnerid']
                      .toString(),
                  prepayId: data['prepayid']
                      .toString(),
                  packageValue: data['package']
                      .toString(),
                  nonceStr: data['noncestr']
                      .toString(),
                  timeStamp: int.parse(
                      data['timestamp']),
                  sign: data['sign']
                      .toString())
                  .then((val) {
                setState(() {
                  loading = false;
                });
              }).catchError((error) {
                print(error);
              });
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: data['msg'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      }
      ;
    });
  }
}