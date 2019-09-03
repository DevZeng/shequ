import 'package:flutter/material.dart';
import 'api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'model.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}
class LoginPageState extends State<LoginPage>{
  String username = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '手机登录',
          ),
          elevation: 0,
          centerTitle: false,
        ),
        body: SingleChildScrollView(child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  '手机号',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
              ),
              Container(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入手机号'),
                  onChanged: (v) {
                    username = v;
                  },
                ),
                decoration: BoxDecoration(
                  // 下滑线浅灰色，宽度1像素
                    border: Border(
                        bottom:
                        BorderSide(color: Colors.grey[200], width: 1.0))),
              ),
              Container(
                child: Text(
                  '密码',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
              ),
              Container(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '请输入密码', border: InputBorder.none,),
                  onChanged: (v) {
                    password = v;
                  },
                ),
                decoration: BoxDecoration(
                  // 下滑线浅灰色，宽度1像素
                    border: Border(
                        bottom:
                        BorderSide(color: Colors.grey[200], width: 1.0))),
              ),
//          Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 15),child: new Divider(),),
              Container(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 40.0,
                  child: new RaisedButton(
                    onPressed: login,
                    color: Color.fromRGBO(240, 190, 60, 1),
                    child: new Text("登录",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    shape: new StadiumBorder(
                        side: new BorderSide(
                          style: BorderStyle.solid,
                          color: Color.fromRGBO(240, 190, 60, 1),
                        )),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(15, 20, 0, 15),
              ),
              Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: FlatButton(
                    child: Text(
                      '注册',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                    onPressed: (){
                      Navigator.pushNamed(context, "register");
                    },
                  ))
            ],
          ),
        ),));
  }
  void login() {
    if (username.length == 0 || password.length == 0) {
      Fluttertoast.showToast(
          msg: "请检查输入内容！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }else{
      var formData = {"userPhone": username, "userPwd": password, "loginType":1,"code":""};
      Dio().post(Api.login, data: formData).then((response) {
        if (response.statusCode == 200) {
          var data = response.data;
          print(data);
          if (data['code'] == 200) {

            saveUser(data['data']['token']);
            var houses = data['data']['householdAllMsg'];
            saveMember(data['data']['userMsgType']);
            if(houses!=null){
              var lists = houses['listMsg'];
              if(lists!=null&&lists.length!=0){
                for (var element in lists) {
                  print(element['holdIdentity']);
                  if (element['holdStatus']==1){
                    saveXq(element['holdXqId']);
                    saveHold(element['holdId']);
                    saveHoldType(element['holdIdentity']);
                    saveAddress("${element['holdXqName']}${element['holdLdName']}${element['holdDyName']}");
                    break;
                  }
                }
              }
            }
            print(houses);
            Fluttertoast.showToast(
                msg: "登录成功！",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new MyApp()
                ), (route) => route == null);
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
  void saveUser(user) async
  {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }
  void saveHold(id) async
  {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('holdId', id);
  }
  void saveXq(id) async
  {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xqId', id);
  }
}
