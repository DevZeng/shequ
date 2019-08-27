import 'package:flutter/material.dart';
import 'api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  String username = '';
  String password = '';
  String code = '';
  var countdownTime = 0;
  Timer _timer;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
  void sendCode() {
    if(countdownTime==0){
      startCountdown();
    }else{
      Fluttertoast.showToast(
          msg: "验证码已发送！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return ;
    }
    if (usernameController.text.length != 11) {
      Fluttertoast.showToast(
          msg: "不是有效的手机号码！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    var formData = {"userPhone": usernameController.text, "sUserAccount": usernameController.text};
    print(formData);
    Dio().post(Api.sendMessage, data: formData).then((response) {
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "发送成功！",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      };
    });
  }

  void register() {
    if (usernameController.text.length == 0 || codeController.text.length == 0 || passwordController.text.length == 0) {
      Fluttertoast.showToast(
          msg: "请检查输入内容！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }else{
      var formData = {"userPhone": usernameController.text, "userPwd": passwordController.text, "code": codeController.text};
      Dio().post(Api.register, data: formData).then((response) {
        if (response.statusCode == 200) {
          var data = response.data;
          print('1');
          print(data);
          if (data['code'] == 200) {
            var formData = {"userPhone": usernameController.text, "userPwd": passwordController.text, "loginType":1,"code":""};
            Dio().post(Api.login, data: formData).then((response) {
              print('2');
              print(response);
              if (response.statusCode == 200) {
                var data = response.data;
                if (data['code'] == 200) {

                  saveUser(data['data']['token']);
                  var houses = data['data']['householdAllMsg'];
                  if(houses!=null){
                    var lists = houses['listMsg'];
                    if(lists!=null&&lists.length!=0){
                      saveXq(lists[0]['holdXqId']);
                      saveHold(lists[0]['holdId']);
                    }
                  }
                  print(houses);
                  Fluttertoast.showToast(
                      msg: "注册成功！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                  Navigator.pushNamed(context, "home");
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '手机注册',
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
                    controller: usernameController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入手机号',
                        suffix: FlatButton(
                            child: Text(
                              countdownTime > 0 ? '$countdownTime后重新获取' : '获取验证码',
                              style: TextStyle(
                                fontSize: 14,
                                color: countdownTime > 0
                                    ? Color.fromARGB(255, 183, 184, 195)
                                    : Color.fromARGB(255, 17, 132, 255),
                              ),
                            ), onPressed: sendCode))
                ),
                decoration: BoxDecoration(
                  // 下滑线浅灰色，宽度1像素
                    border: Border(
                        bottom:
                        BorderSide(color: Colors.grey[200], width: 1.0))),
              ),
              Container(
                child: TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: '请输入短信验证码'),
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
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: '请输入密码', border: InputBorder.none),
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
                    onPressed: register,
                    color: Color.fromRGBO(240, 190, 60, 1),
                    child: new Text("注册",
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
                      '密码登录',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                    onPressed: (){
                      Navigator.pushNamed(context, "login");
                    },
                  ))
            ],
          ),
        ),));
  }
  startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
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
