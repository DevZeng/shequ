import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class countPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _countPage();
  }
}

class _countPage extends State<countPage>{
  Api api = new Api();
  List products = [];
  List<Address> addresses = [];
  Store store = new Store(0, ' ', '', [],0,2,0,0,0);
  Address defaultAddress = new Address(0, '', '', '请选择', '', 1);
  int addressId = 0;
  bool take = true;
  int member = 0;
  _countPage(){
    getMember().then((val){
      setState(() {
        member = val;
      });
    });
    fluwx.responseFromPayment.listen((data) {
      if(data.errCode==0){
        Navigator.of(context).pop();
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

    });
    getUserAddress().then((val){
      if(val!=null&&val.length!=0){
        val.forEach((item){
          Address address = new Address(item['addressId'], item['addressUserName'], item['addressUserPhone'], item['addressAreas'], item['addressName'], item['addressIfDefult']);
          if(address.is_default==1){
            defaultAddress = address;
            addressId = address.id;
          }
          addresses.add(address);
          setState(() {
          });
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    if(args!=null){
      store = args;
      print(store);
    }
//    Address info =  ModalRoute.of(context).settings.arguments;
//    if(info!=null&&enter==false){
//      nameController.text = info.name;
//      phoneController.text = info.phone;
//      detailController.text = info.detail;
//      address = info.area;
//      id = info.id;
//      enter = true;
//    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('提交订单'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: <Widget>[
            store.send==0?Container():Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Container(
              child: SwitchListTile(value: take, onChanged: (val){
                setState(() {
                  take = val;
                });
              },title: Text('自提'),activeColor: Color.fromRGBO(243, 200, 70, 1),),
              color: Colors.white,
            ),),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            take==true?Container():GestureDetector(child: Container(
              height: 80,
//              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color:Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.1,
                    child: ImageIcon(AssetImage('images/location.png'),color: Colors.yellow,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.8-30,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child:  Text(defaultAddress.area+defaultAddress.detail),
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.8-30,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(defaultAddress.name),
                              height: 40,
                              padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                            ),
                            Container(
                              child: Text(defaultAddress.phone),
                              height: 40,
                              padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                            )

                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.1,
                    child: Text('>',style: TextStyle(fontSize: 20),),
                  )
                ],
              ),
            ),onTap: (){
              addresses.length==0?Navigator.pushNamed(context, 'addAddress').then((val){
                getUserAddress().then((val){
                  if(val!=null&&val.length!=0){
                    val.forEach((item){
                      Address address = new Address(item['addressId'], item['addressUserName'], item['addressUserPhone'], item['addressAreas'], item['addressName'], item['addressIfDefult']);
                      if(address.is_default==1){
                        defaultAddress = address;
                        addressId = address.id;
                      }
                      addresses.add(address);
                      setState(() {
                      });
                    });
                  }
                });
              }):
              showModalBottomSheet(context: context, builder: (context){
                return ListView.separated(
                    itemCount: addresses.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 1,);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(addresses[index].area+addresses[index].detail),
                                width: MediaQuery.of(context).size.width,
                                height: 25,
                              ),
                              Container(
                                child: Text(addresses[index].name+'   '+addresses[index].phone),
                                width: MediaQuery.of(context).size.width,
                                height: 25,
                              )
                            ],
                          ),
                        ),
                        onTap: (){
                          print('tap');
                          defaultAddress = addresses[index];
                          addressId = addresses[index].id;
                          Navigator.of(context).pop();
                        },
                      );
                    });
              }).then((val){
                setState(() {

                });
              });
            },),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(leading: CircleAvatar(child: Image.network(store.icon),),title: Text(store.name),),
                  Divider(height: 1,),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: store.products.length,
                    itemBuilder: (context,index){
                    return Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 80,
                            width: 120,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          store.products[index].icon),
                                      fit: BoxFit.fill),
                                )
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    store.products[index].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width - 250,
//                             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  height: 40,
                                  child:Text('X${store.products[index].number}',style: TextStyle(color: Colors.grey[500])),
                                  width: MediaQuery.of(context).size.width - 250,
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    '￥ ${member==1?store.products[index].sprice:store.products[index].price}',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  height: 40,
                                  width: 100,
//                             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                ),
//                                Container(
//                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                  height: 40,
//                                  child:Text('${store.products[index].sprice}',style: TextStyle(color: Colors.grey[500],decoration:
//                                  TextDecoration.lineThrough),),
//                                  width: 100,
//                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                    separatorBuilder: (context,index){
                    return Divider(height: 1,);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
//        color: Colors.yellow,
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              color: Colors.white,
              width: MediaQuery.of(context).size.width*0.7,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                      child: Text('合计'),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text('¥',style: TextStyle(color: Colors.red),),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text(take==true?store.price.toStringAsFixed(2):(store.price+store.sendPrice).toStringAsFixed(2),style: TextStyle(color: Colors.red,fontSize: 18),),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              color: Colors.orange,
              width: MediaQuery.of(context).size.width*0.3,
              child: FlatButton(onPressed: (){
                if(!take){
                  if(addressId==0){
                    Fluttertoast.showToast(
                        msg: "配送地址为空！",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  }
                }
                getUser().then((val){
                  if(store.type==2){
                    List products = [];
                    store.products.forEach((item){
                      products.add({
                        'storeId':item.id,
                        'storeNum':item.number
                      });
                    });
                    var formData =
                        '{"token": "$val", "store": "$products", "addressId":${addressId},"storeIdentity":${take==true?2:1},"storeShopId":"${store.id}"}';
                    print(formData);
                    Dio().post(api.postHShopStoreOrder,data: formData).then((response){
                      var data = response.data;
                      print(data);
                      if(data['code']==200){
                        var formData =
                            '{"token": "$val", "orderid": "${data['data']['storeOrderId']}", "orderType":2}';
                        Dio().post(api.wxpay,data: formData).then((response){
                          data = response.data;
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
                          }
                        });
                      }
                    });
                  }else{
                    List products = [];
                    store.products.forEach((item){
                      products.add({
                        'takeOutId':item.id,
                        'takeOutIdNum':item.number
                      });
                    });
                    var formData =
                        '{"token": "$val", "takeout": "$products", "addressId":${addressId},"toOrderIdentity":${take==true?2:1},"toOrderShopId":"${store.id}"}';
                    print(formData);
                    Dio().post(api.postHShopTakeoutOrder,data: formData).then((response){
                      var data = response.data;
                      print(data);
                      if(data['code']==200){
                        var formData =
                            '{"token": "$val", "orderid": "${data['data']}", "orderType":1}';
                        Dio().post(api.wxpay,data: formData).then((response){
                          data = response.data;
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
                          }
                        });
                      }
                    });
                  }

                });
              }, child: Text('支付',style: TextStyle(color: Colors.white),)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print(store.products[0].name);
//        products.add({'storeId':1,'storeNum':3});
//        List store = [];
//        store.add(6);
//        var formData =
//            '{"token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1NjU1MjcyNjIsInVzZXJuYW1lIjoiMTU2MDg0OTc4NDYyMzkzIn0.u2dUcu7rfVqcazNnCbZaUg6KV59XsYshsowEVQRjxp0", "storeId": $store, "store":"$products", "storeIdentity":1, "storeShopId":6, "addressId":"156540640128178"}';
//        print(formData);
      }),
    );
  }
  getUserAddress() async {
    var returndata = [];
    String token = await getUser();
    Response response = await Dio().get(api.getHUserAddress+'?token=$token');
    var data = response.data;
    if(data['code']==200){
      returndata = data['data'];
    }
    return returndata;
  }

}