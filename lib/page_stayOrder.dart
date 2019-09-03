import 'package:flutter/material.dart';
import 'model.dart';
import 'api.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluttertoast/fluttertoast.dart';

class StayOrder extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StayOrder();
  }
}

class _StayOrder extends State<StayOrder>{
  int number = 1;
  var names = [];
  var parms = null;
  Api api = new Api();
  int member = 0;
  TextEditingController phoneController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(parms==null){
      parms = ModalRoute.of(context).settings.arguments;
      print(parms);
    }
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('填写订单'),
        centerTitle: true,elevation: 0,),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Column(
                children: <Widget>[
                  Container(child: Text(parms['name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),width: MediaQuery.of(context).size.width,),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Divider(height: 1,),),
                ],
              ),
            ),),
            Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                child: Column(
                  children: <Widget>[
                    Container(child: Text('入住信息',style: TextStyle(fontWeight: FontWeight.w700),),width: MediaQuery.of(context).size.width,),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Divider(height: 1,),),
                    Container(child: Row(
                      children: <Widget>[
                        Container(
                    width: MediaQuery.of(context).size.width*0.3,
                          child: Text('房间数'),
                        ),
                        GestureDetector(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text('${number}间',style: TextStyle(fontWeight: FontWeight.w700),),
                                Text('  每间最多住${parms['livenum']}人',style: TextStyle(color: Colors.grey[400]),)
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              number = 4;
                            });
                          },
                        )
                      ],
                    ),width: MediaQuery.of(context).size.width,height: 40,),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Divider(height: 1,),),
                    Column(
                      children: setNumber(),
                    ),
                    Container(child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text('手机号'),
                        ),
                        Container(
                          child: Expanded(child: TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: '请输入手机号', border: InputBorder.none,),
                          )),
                        )
                      ],
                    ),width: MediaQuery.of(context).size.width,height: 40,),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Divider(height: 1,),),
                    Container(child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text('到店时间'),
                        ),
                        Container(
                          child: Text('14:00后办理入住',style: TextStyle(fontWeight: FontWeight.w700),),
                        )
                      ],
                    ),width: MediaQuery.of(context).size.width,height: 40,),
//                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Divider(height: 1,),),

                  ],
                ),
              ),)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width*0.7,
              color: Colors.white,
              height: 60,
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child: Text('¥${member==1?parms['memberPrice']*number:parms['price']*number}',style: TextStyle(fontSize: 20,color: Colors.red),),),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.3,
              color: Colors.red,
              height: 60,
              child: FlatButton(onPressed: (){
                payOrder();
              }, child: Text('立即支付',style: TextStyle(fontSize: 20,color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
  setNumber()
  {
    List<Widget> widgets = [];
    for(int i=0;i<number;i++){
      print(i);
      widgets.add(Column(
        children: <Widget>[
          Container(child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width*0.3,
                child: Text('房间${i+1}入住人'),
              ),
              Container(
                child: Expanded(child: TextField(onChanged: (val){
                  setName(i+1, val);
                },decoration: InputDecoration(
                    border: InputBorder.none, hintText: "请输入入住人姓名")),),
              )
            ],
          ),width: MediaQuery.of(context).size.width,height: 40,),
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Divider(height: 1,),),
        ],
      ));
    }
    return widgets;
  }
  setName(id,name){
    if(names.length==0){
      names.add({'id':id,'name':name});
    }else{
      if(names.length==number){
        names.forEach((item){
          if(item['id']==id){
            item['name'] = name;
          }
        });
      }else{
        bool check = false;
        names.forEach((item){
          if(item['id']==id){
            item['name'] = name;
            check = true;
          }
        });
        if(!check){
          names.add({'id':id,'name':name});
        }
      }
    }
  }
  payOrder(){
    if(phoneController.text.length!=11||names.length!=number){
      Fluttertoast.showToast(
          msg: "请检查输入内容！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    }
    getUser().then((val){
      String name = '';
      names.forEach((item){
        if(item['id']==number-1){
          name += item['name'];
        }else{
          name += '${item['name']},';
        }
      });
      var formData = {"token": val, "hotelOrderInTime": '${parms['indate'].year}-${parms['indate'].month}-${parms['indate'].day}'
        , "hotelOrderOutTime":'${parms['outdate'].year}-${parms['outdate'].month}-${parms['outdate'].day}'
        ,"hotelOrderShopId":'${parms['id']}',"hotelId":'${parms['roomid']}',"hotelOrderUserPhone":'${phoneController.text}',"hotelOrderUserName":'${name}',
        'hotelOrderNum':number
      };
      print(formData);
      Dio().post(api.postHShopHotelOrder,data: formData).then((response){
        var data = response.data;
        if(data['code']==200){
          var formData = {
            'token':val,
            'orderid':data['data'],
            'orderType':3
          };
          Dio().post(api.wxpay,data: formData).then((response){
            var data = response.data;
            if(data['code']==200){
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
                print(val);
              }).catchError((error) {
                print(error);
              });
            }else{
              Fluttertoast.showToast(
                  msg: data['msg'],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
            }
          });
        }
      });
    });
  }
}