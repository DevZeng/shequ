import 'package:flutter/material.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api.dart';
import 'model.dart';
import 'dart:convert';

class addAddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<addAddressPage> {
  String address = '请选择';
  String province = '请选择';
  String city = '请选择';
  String area = '请选择';
  int id = 0;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  String token = '';
  bool enter = false;
  Api api = new Api();

  @override
  Widget build(BuildContext context) {
    Address info =  ModalRoute.of(context).settings.arguments;
    if(info!=null&&enter==false){
      nameController.text = info.name;
      phoneController.text = info.phone;
      detailController.text = info.detail;
      address = info.area;
      id = info.id;
      enter = true;
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('新增地址'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Container(
                    child: Text(
                      '收货人',
                      style: TextStyle(fontSize: 17),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    width: MediaQuery.of(context).size.width * 0.3),
                Expanded(
                    child: TextField(
                  autofocus: false,
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: "请输入收货人姓名", border: InputBorder.none),
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(padding: EdgeInsets.all(1.0), child: new Divider()),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Container(
                    child: Text(
                      '手机号',
                      style: TextStyle(fontSize: 17),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    width: MediaQuery.of(context).size.width * 0.3),
                Expanded(
                    child: TextField(
                  autofocus: false,
                  controller: phoneController,
                  decoration: InputDecoration(
                      hintText: "请输入收货手机号", border: InputBorder.none),
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(padding: EdgeInsets.all(1.0), child: new Divider()),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    '所在地区',
                    style: TextStyle(fontSize: 17),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                Expanded(
                    child: GestureDetector(
                  child: Text(
                    address,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  onTap: () {
                    getCity(context);
                  },
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(padding: EdgeInsets.all(1.0), child: new Divider()),
          ),
          Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                child: TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "请补充详细收货地址，如街道、门牌号、楼层及房间号等。",
                      border: InputBorder.none),
                  controller: detailController,
                ),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              )),
        ],
      ),
      floatingActionButton: new Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 40.0,
        child: new RaisedButton(
          onPressed: () {
//            print(address.detail);
            getUser().then((val) {
              saveAddress(
                  val,
                  detailController.text,
                  nameController.text,
                  phoneController.text,
                  "$province,$city,$area");
            });
          },
          color: Colors.orange,
          child: new Text("保存地址",
              style: TextStyle(
                color: Colors.white,
              )),
          shape: new StadiumBorder(
              side: new BorderSide(
            style: BorderStyle.solid,
            color: Color(0xffFF7F24),
          )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void getCity(BuildContext context) async {
    Result result = await CityPickers.showCityPicker(
        context: context,
        height: 250,
        theme: ThemeData(
          primaryColor: Colors.orange,
        ));
    setState(() {
      address = result.provinceName+','+result.cityName+','+result.areaName;
//      address = result.provinceName +  + ;
      province = result.provinceName;
      city = result.cityName;
      area = result.areaName;
    });
  }

  void saveAddress(String token, String detail, String addressUserName,
      String addressUserPhone, String addressAreas) {
    if (token.length == 0 ||
        detail.length == 0 ||
        addressUserName.length == 0 ||
        addressUserPhone.length == 0 ||
        addressAreas.length == 0) {
      Fluttertoast.showToast(
          msg: "请检查输入内容！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      if(id==0){
        var formData =
            '{"token": "$token", "addressUserName": "$addressUserName", "addressUserPhone":"$addressUserPhone","addressAreas":"$addressAreas","addressName":"$detail"}';
        Dio().post(api.setAddress, data: formData).then((response) {
          if (response.statusCode == 200) {
            var data = response.data;
            print(data);
            if (data['code'] == 200) {
              Fluttertoast.showToast(
                  msg: "添加成功！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
              Navigator.of(context).pop();
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
        }).catchError((error) {
          print(error.toString());
        });
      }else{
        var formData =
            '{"token": "$token","addressId": "$id", "addressUserName": "$addressUserName", "addressUserPhone":"$addressUserPhone","addressAreas":"$address","addressName":"$detail"}';
        print(formData);
        Dio().put(api.modifyAddress, data: formData).then((response) {
          if (response.statusCode == 200) {
            var data = response.data;
            print(data);
            if (data['code'] == 200) {
              Fluttertoast.showToast(
                  msg: "修改成功！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
              Navigator.of(context).pop();
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
        }).catchError((error) {
          print(error.toString());
        });
      }
    }
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    return user;
  }
}
