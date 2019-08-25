import 'package:flutter/material.dart';
import 'model.dart';

//import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class FamilyDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<FamilyDetail> {
  List<String> types = ['家庭成员', '户主', '工人', '租客'];
  TextEditingController nameController = new TextEditingController();
  TextEditingController idController = new TextEditingController();
//  HouseInfo houseInfo = new HouseInfo();
  Api api = new Api();
  var info = null;

  @override
  Widget build(BuildContext context) {
    if(info==null){
      info = ModalRoute
          .of(context)
          .settings
          .arguments;
      nameController.text = info['name'];
      idController.text = info['idcard'];
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('住户信息'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.2,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          image: DecorationImage(
                              image: NetworkImage(info==null?'':info['image']),
                              fit: BoxFit.fill)),
                    ),
                    onTap: () {
                      print('tap');
                      getImage();
                    },
                  )),
              Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
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
                            info==null?'请选择':info['sex'],
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
//                                        info['userMsgSex']='男';
                                        Navigator.of(context).pop();
                                      });
                                    },),
                                    ListTile(title: Text('女'),onTap: (){setState(() {
//                                      info['userMsgSex']='女';
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
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Row(
                  children: <Widget>[
                    Container(
                        child: Text(
                          '与户主关系',
                          style: TextStyle(fontSize: 14),
                        ),
                        padding:
                        EdgeInsets.fromLTRB(15, 0, 15, 0),
                        width:
                        MediaQuery.of(context).size.width *
                            0.3),
                    Expanded(
                        child: GestureDetector(
                          child: Text(info==null?'请选择':types[info['identity']]),
                          onTap: () {
                            if(info['identity']==2||info['identity']==1){
                              return ;
                            }
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(types[0]),
                                        onTap: () {
                                          info['identity'] = 0;
                                          Navigator.of(context).pop(0);
                                        },
                                      ),
                                      ListTile(
                                        title: Text(types[3]),
                                        onTap: () {
                                        info['identity'] = 3;
                                          Navigator.of(context).pop(3);
                                        },
                                      ),
                                    ],
                                  );
                                }).then((val) {
                              setState(() {});
                            });
                          },
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7,
        height: 40.0,
        child: new RaisedButton(
          onPressed: () {
//            saveInfo();
          print(info);
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

  getInfo(int id) async {
    var returndata = [];
    Response response = await Dio().get(api.getHHouseMsg + '?housePid=$id');
    var data = response.data;
    if (data['code'] == 200) {
      if (data['data'].length != 0) {
        returndata = data['data'];
      }
    }
    return returndata;
  }

  _upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData =
    new FormData.from({"file": new UploadFileInfo(new File(path), name)});
    Dio().post(api.uploadT, data: formData).then((response) {
      var data = response.data;
      if (data['code'] == 200) {
        String url = data['data'];
        setState(() {
//          houseInfo.imageAddress = url;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upLoadImage(image);
  }

  saveInfo() {
//    print(houseInfo.id);
    if (0 == 0) {
      getUser().then((val) {
//        var formData =
//            '{"token": "$val", "holdIdentity": "${houseInfo.holdIdentity}", "holdXqId":"${houseInfo.holdXqId}", "holdLdId":"${houseInfo.holdLdId}", "holdDyId":"${houseInfo.holdDyId}", "imageAddress":"${houseInfo.imageAddress}"}';
//        Dio().post(api.postHHouseUserHold,data: formData).then((response){
//          var data = response.data;
//          print(data);
//          if(data['code']==200){
//            Fluttertoast.showToast(
//                msg: "保存成功",
//                toastLength: Toast.LENGTH_SHORT,
//                gravity: ToastGravity.BOTTOM,
//                timeInSecForIos: 1,
//                backgroundColor: Colors.white,
//                textColor: Colors.black,
//                fontSize: 16.0).then((val){
//              Navigator.of(context).pop();
//            });
//          }else{
//            Fluttertoast.showToast(
//                msg: data['msg'],
//                toastLength: Toast.LENGTH_SHORT,
//                gravity: ToastGravity.BOTTOM,
//                timeInSecForIos: 1,
//                backgroundColor: Colors.white,
//                textColor: Colors.black,
//                fontSize: 16.0).then((val){
////              Navigator.of(context).pop();
//            });
//          }
//        });
      });
    } else {
      getUser().then((val) {
//        var formData =
//            '{"token": "$val", "holdId": "${houseInfo.id}","holdIdentity": "${houseInfo.holdIdentity}", "holdXqId":"${houseInfo.holdXqId}", "holdLdId":"${houseInfo.holdLdId}", "holdDyId":"${houseInfo.holdDyId}", "imageAddress":"${houseInfo.imageAddress}"}';
//        Dio().put(api.putHHouseUserHold,data: formData).then((response){
//          var data = response.data;
////          print(data);
//          if(data['code']==200){
////            print('suss');
//            Fluttertoast.showToast(
//                msg: "保存成功",
//                toastLength: Toast.LENGTH_SHORT,
//                gravity: ToastGravity.BOTTOM,
//                timeInSecForIos: 1,
//                backgroundColor: Colors.white,
//                textColor: Colors.black,
//                fontSize: 16.0).then((val){
//              Navigator.of(context).pop();
//            });
//          }
//        });
      });
    }
  }
}
