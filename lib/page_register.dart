import 'package:flutter/material.dart';
import 'api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  String username = '';
  String password = '';
  String code = '';

  void sendCode() {
    if (username.length != 11) {
      Fluttertoast.showToast(
          msg: "不是有效的手机号码！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    var formData = {"userPhone": username, "sUserAccount": username};
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
      }
      ;
    });
  }

  void register() {
    if (username.length == 0 || code.length == 0 || password.length == 0) {
      Fluttertoast.showToast(
          msg: "请检查输入内容！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }else{
      var formData = {"userPhone": username, "userPwd": password, "code": code};
      Dio().post(Api.register, data: formData).then((response) {
        if (response.statusCode == 200) {
          var data = response.data;
          if (data['code'] == 200) {
            Fluttertoast.showToast(
                msg: "注册成功！",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
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
        body: Container(
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
                      hintText: '请输入手机号',
                      suffix: FlatButton(
                          child: Text('获取验证码'), onPressed: sendCode)),
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
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: '请输入短信验证码'),
                  onChanged: (v) {
                    code = v;
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
                  decoration: InputDecoration(
                      hintText: '请输入密码', border: InputBorder.none),
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
        ));
  }
}
