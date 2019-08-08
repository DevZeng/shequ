import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

class addPageInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<addPageInfo> {
  File _image;
  bool modify = false;
  Api api = new Api();
  var info;
  TextEditingController nickController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController idController = new TextEditingController();

  String token;

  Page() {
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('基本信息'),
        elevation: 0,
      ),
      body: info == null
          ? null
          : Container(
              color: Colors.grey[100],
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    color: Colors.white,
                    child: GestureDetector(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      info['userMsgHead'] == null
                                          ? ''
                                          : info['userMsgHead']),
                                ),
                                height: 80,
                                width: 80,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              ),
                              Text(
                                '点击更改头像',
                                style: TextStyle(color: Colors.grey[500]),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        getImage();
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                  modify == false
                      ? Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Text('昵称'),
                                trailing: Text(info['userMsgNike'] == null
                                    ? ''
                                    : info['userMsgNike']),
                              ),
                              ListTile(
                                leading: Text('姓名'),
                                trailing: Text(info['userMsgName'] == null
                                    ? ''
                                    : info['userMsgName']),
                              ),
                              ListTile(
                                leading: Text('性别'),
                                trailing: Text(info['userMsgSex'] == null
                                    ? ''
                                    : info['userMsgSex']),
                              ),
                              ListTile(
                                leading: Text('手机号'),
                                trailing: Text(info['userMsgPhone'] == null
                                    ? ''
                                    : info['userMsgPhone']),
                              ),
                              ListTile(
                                  leading: Text('身份证号码'),
                                  trailing: Text(info['userMsgIdcard'] == null
                                      ? ''
                                      : info['userMsgIdcard'])),
                            ],
                          ),
                        )
                      : Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                          '昵称',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                    Expanded(
                                        child: TextField(
                                      autofocus: false,
                                      controller: nickController,
                                      decoration: InputDecoration(
                                          hintText: "请输入昵称",
                                          border: InputBorder.none),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                          '姓名',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                    Expanded(
                                        child: TextField(
                                      autofocus: false,
                          controller: nameController,
                                      decoration: InputDecoration(
                                          hintText: "请输入姓名",
                                          border: InputBorder.none),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                          '性别',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                    Expanded(
                                        child: GestureDetector(
                                          child: Text(
                                            info['userMsgSex']==null?'请选择':info['userMsgSex'],
                                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                          ),
                                          onTap: () {
                                            showModalBottomSheet(context: context, builder: (BuildContext context){
                                              return Container(
                                                height: 150,
                                                child: Column(
                                                  children: <Widget>[
                                                    ListTile(leading: null,title: Text('男'),onTap: (){
                                                      setState(() {
                                                        info['userMsgSex']='男';
                                                        Navigator.of(context).pop();
                                                      });
                                                    },),
                                                    ListTile(title: Text('女'),onTap: (){setState(() {
                                                      info['userMsgSex']='女';
                                                      Navigator.of(context).pop();
                                                    });},)
                                                  ],
                                                ),
                                              );
                                            });
                                          },
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                          '手机号',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                    Expanded(
                                        child: TextField(
                                      autofocus: false,
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                                      decoration: InputDecoration(
                                          hintText: "请输入手机号",
                                          border: InputBorder.none),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                          '身份证号码',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                    Expanded(
                                        child: TextField(
                                      autofocus: false,
                          controller: idController,
                                      decoration: InputDecoration(
                                          hintText: "请输入身份证号",
                                          border: InputBorder.none),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
      floatingActionButton: new Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 40.0,
        child: new RaisedButton(
          onPressed: () {
//          print(detailController.text);
//        print(modify);
//            print(info);
            doUpdate();
          },
          color: Colors.orange,
          child: modify == true
              ? new Text("保存",
                  style: TextStyle(
                    color: Colors.white,
                  ))
              : new Text("修改",
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upLoadImage(image);
    setState(() {
      _image = image;
    });
  }

  _upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(new File(path), name,
          contentType: ContentType.parse("image/$suffix"))
    });
//    print(formData);
    Dio().post(api.upload, data: formData).then((response) {
      var data = response.data;
      if (data['code'] == 200) {
        String url = data['data'];
        var formData =
            '{"token": "$token", "userMsgHead": "$url", "userMsgId":"${info['userMsgId']}"}';
        print(formData);
        Dio().put(api.setUserInfo, data: formData).then((response) {
          var data = response.data;
          if (data['code'] == 200) {
            print('ff');
            Fluttertoast.showToast(
                msg: "头像上传成功",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
            setState(() {
              info['userMsgHead'] = url;
            });
          }
        }).catchError((error) {
          print(error);
        });
      }
    });
//      data = data['data'];
//      var formData =
//          '{"token": "$token", "userMsgHead": "$data['data']", "userMsgId":"${info['userMsgId']}"}';
//      print(formData);
//      Fluttertoast.showToast(
//
  }

  void doUpdate() {
    if(modify==true){
//      print(info['userMsgSex']);
      var formData =
          '{"token": "$token", "userMsgNike": "${nickController.text}", "userMsgSex":"${info['userMsgSex']}", "userMsgId":${info['userMsgId']}, "userMsgName":"${nameController.text}", "userMsgPhone":"${phoneController.text}", "userMsgIdcard":"${idController.text}"}';
      print(formData);
      Dio().put(api.setUserInfo,data: formData).then((response){
        var data = response.data;
        if(data['code']==200){
          Fluttertoast.showToast(
              msg: "保存成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          setState(() {
            info['userMsgNike'] = nickController.text;
            info['userMsgName'] = nameController.text;
            info['userMsgIdcard'] = idController.text;
            info['userMsgPhone'] = phoneController.text;
          });
        }
      }).catchError((error){
        print(error);
      });
    }
    setState(() {
      modify = !modify;
    });
  }

  void getUserInfo() async {
    getUser().then((val) {
      print(val);

      Dio().request(api.getUserInfo + '?token=$val').then((response) {
        var data = response.data;
        if (data['code'] == 200) {
          setState(() {
            info = data['data'];
            nickController.text = data['data']['userMsgNike'] == null
                ? ''
                : data['data']['userMsgNike'];
            nameController.text = data['data']['userMsgName'] == null ? ''  : data['data']['userMsgName'];
            phoneController.text = data['data']['userMsgPhone'] == null ? ''  : data['data']['userMsgPhone'];
            idController.text = data['data']['userMsgIdcard'] == null ? '' : data['data']['userMsgIdcard'];
            token = val;
          });
        }
      });
    });
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
//    print(user);
    return user;
  }
}
