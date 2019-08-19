import 'package:flutter/material.dart';
import 'model.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluttertoast/fluttertoast.dart';
class listAddressPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<listAddressPage> {
  int radio = 1;
  Api api = new Api();
  List<Address> addresses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }
  getAddress(){
    getUser().then((val){
      Dio().get(api.getHUserAddress+'?token=$val').then((response){
        var data = response.data;
        if(data['code']==200){
          data['data'].forEach((address){
            addresses.add(Address(address['addressId'], address['addressUserName'], address['addressUserPhone'], address['addressAreas'],
                address['addressName'], address['addressIfDefult']));
          });
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('我的地址'),elevation:0,),
      body: SingleChildScrollView(child: Column(
        children: addresses.map((address){
          return Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(child: Row(
                        children: <Widget>[
                          Container(child: Text(address.name,style: TextStyle(fontSize: 20),),width: MediaQuery.of(context).size.width*0.3,),
                          Container(child: Text(address.phone,style: TextStyle(fontSize: 20),),width: MediaQuery.of(context).size.width*0.7-50,)
                        ],
                      ),padding: EdgeInsets.fromLTRB(15, 10, 15, 0),),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(address.area+address.detail,style: TextStyle(fontSize: 20,color: Colors.grey,),textAlign: TextAlign.left,),padding: EdgeInsets.fromLTRB(15, 0, 15, 0),),
                      Container(
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(1.0),
                            child: new Divider()
                        ),
                      ),
                      Container(
                        child:Row(
                          children: <Widget>[
                            Container(child: Row(
                              children: <Widget>[
                                Expanded(child: RadioListTile(value: 1, groupValue: address.is_default, onChanged: (val){
                                  print('click');
                                  setState(() {
                                    address.is_default = val;
                                  });
                                },title: Text('设为默认'),))
                              ],
                            ),width: MediaQuery.of(context).size.width*0.55,
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),),
                            FlatButton(onPressed: (){
                              Navigator.of(context).pushNamed('addAddress',arguments: address);
                            }, child: Row(children: <Widget>[Icon(Icons.edit),Text('编辑')],),),
                            FlatButton(onPressed: (){
//                              setState(() {
//                                addresses.remove(address);
//                              });
                              getUser().then((val){
                                delAddress(val, address.id);
                                setState(() {
                                  addresses.remove(address);
                                });
                              });
                            }, child: Row(children: <Widget>[Icon(Icons.delete),Text('删除')],),),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),),
      floatingActionButton: new Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 40.0  ,
        child: new RaisedButton(onPressed: (){
//          print(addresses);
          Navigator.of(context).pushNamed('addAddress').then((val){
            getAddress();
          });
        },color: Colors.orange,
          child: new Text("新增地址",style: TextStyle(color: Colors.white,)),
          shape: new StadiumBorder(side: new BorderSide(
            style: BorderStyle.solid,
            color: Color(0xffFF7F24),
          )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  delAddress(String token,int id) async {
    Dio().delete(api.delAddress+'/$id/$token').then((response){
      var data = response.data;
      if(data['code']==200){
        Fluttertoast.showToast(msg: '删除成功');
      }
    });
  }
}