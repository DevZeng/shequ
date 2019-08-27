import 'package:flutter/material.dart';
import 'model.dart';

//import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class addHouseInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<addHouseInfo> {
  List<String> types = ['家庭成员', '户主', '工人', '租客'];
  HouseInfo houseInfo = new HouseInfo();
  Api api = new Api();

  @override
  Widget build(BuildContext context) {
    houseInfo = ModalRoute
        .of(context)
        .settings
        .arguments;
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
                              image: NetworkImage(houseInfo.imageAddress),
                              fit: BoxFit.fill)),
                    ),
                    onTap: () {
                      print('tap');
                      getImage();
                    },
                  )),
              Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Text('身份类型'),
                      trailing: GestureDetector(
                        child: Text(types[houseInfo.holdIdentity]),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(types[0]),
                                      onTap: () {
                                        houseInfo.holdIdentity = 0;
                                        Navigator.of(context).pop(0);
                                      },
                                    ),
                                    ListTile(
                                      title: Text(types[1]),
                                      onTap: () {
                                        houseInfo.holdIdentity = 1;
                                        Navigator.of(context).pop(1);
                                      },
                                    ),
                                    ListTile(
                                      title: Text(types[2]),
                                      onTap: () {
                                        houseInfo.holdIdentity = 2;
                                        Navigator.of(context).pop(2);
                                      },
                                    ),
                                    ListTile(
                                      title: Text(types[3]),
                                      onTap: () {
                                        houseInfo.holdIdentity = 3;
                                        Navigator.of(context).pop(3);
                                      },
                                    ),
                                  ],
                                );
                              }).then((val) {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      leading: Text('小区名'),
                      trailing: GestureDetector(
                        child: Text(houseInfo.holdXq),
                        onTap: () {
                          getInfo(0).then((val) {
                            showModalBottomSheet(
                                context: (context),
                                builder: (context) {
                                  List lists = val;
                                  return ListView.builder(
                                    itemCount: lists.length,
                                      itemBuilder: (context,index){
                                    return ListTile(
                                        title: Text(lists[index]['houseName']),
                                        onTap: () {
                                          houseInfo.holdXqId =
                                          lists[index]['houseId'];
                                          houseInfo.holdXq =
                                          lists[index]['houseName'];
                                          houseInfo.holdLdId = 0;
                                          houseInfo.holdLd = '请选择';
                                          houseInfo.holdDy = '请选择';
                                          houseInfo.holdDyId = 0;
                                          Navigator.of(context).pop();
                                        });
                                  });
                                }).then((val) {
                              setState(() {});
                            });
                          });
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      leading: Text('楼栋号'),
                      trailing: GestureDetector(
                        child: Text(houseInfo.holdLd),
                        onTap: () {
                          getInfo(houseInfo.holdXqId).then((val) {
                            showModalBottomSheet(
                                context: (context),
                                builder: (context) {
                                  List lists = val;
                                  return ListView.builder(
                                    itemCount: lists.length,
                                      itemBuilder: (context,index){
                                    return ListTile(
                                        title: Text(lists[index]['houseName']),
                                        onTap: () {
                                          houseInfo.holdLdId =
                                          lists[index]['houseId'];
                                          houseInfo.holdLd =
                                          lists[index]['houseName'];
                                          houseInfo.holdDy = '请选择';
                                          houseInfo.holdDyId = 0;
                                          Navigator.of(context).pop();
                                        });
                                  });
                                }).then((val) {
                              setState(() {});
                            });
                          });
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      leading: Text('单元号'),
                      trailing: GestureDetector(
                        child: Text(houseInfo.holdDy),
                        onTap: () {
                          getInfo(houseInfo.holdLdId).then((val) {
                            showModalBottomSheet(
                                context: (context),
                                builder: (context) {
                                  List lists = val;
                                  return ListView.builder(
                                    itemCount: lists.length,
                                      itemBuilder: (context,index){
                                    return ListTile(
                                        title: Text(lists[index]['houseName']),
                                        onTap: () {
                                          houseInfo.holdDyId =
                                          lists[index]['houseId'];
                                          houseInfo.holdDy =
                                          lists[index]['houseName'];
                                          Navigator.of(context).pop();
                                        });
                                  });
                                }).then((val) {
                              setState(() {});
                            });
                          });
                        },
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              )
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
            saveInfo();
//          print(houseInfo.id);
          },
          color: Colors.orange,
          child: new Text("保存住宅",
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
      print(data);
      if (data['code'] == 200) {
        String url = data['data'];
        setState(() {
          houseInfo.imageAddress = url;
        });
      }else{
        Fluttertoast.showToast(
            msg: data['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0).then((val){
//              Navigator.of(context).pop();
        });
      }
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: '人脸照片错误',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0).then((val){
//              Navigator.of(context).pop();
      });
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upLoadImage(image);
  }

  saveInfo() {
    print(houseInfo.id);
    if (houseInfo.id == 0) {
      getUser().then((val) {
        var formData =
            '{"token": "$val", "holdIdentity": "${houseInfo.holdIdentity}", "holdXqId":"${houseInfo.holdXqId}", "holdLdId":"${houseInfo.holdLdId}", "holdDyId":"${houseInfo.holdDyId}", "imageAddress":"${houseInfo.imageAddress}"}';
        Dio().post(api.postHHouseUserHold,data: formData).then((response){
          var data = response.data;
          print(data);
          if(data['code']==200){
            Fluttertoast.showToast(
                msg: "保存成功",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0).then((val){
                  Navigator.of(context).pop();
            });
          }else{
            Fluttertoast.showToast(
                msg: data['msg'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0).then((val){
//              Navigator.of(context).pop();
            });
          }
        });
      });
    } else {
      getUser().then((val) {
        var formData =
            '{"token": "$val", "holdId": "${houseInfo.id}","holdIdentity": "${houseInfo.holdIdentity}", "holdXqId":"${houseInfo.holdXqId}", "holdLdId":"${houseInfo.holdLdId}", "holdDyId":"${houseInfo.holdDyId}", "imageAddress":"${houseInfo.imageAddress}"}';
        Dio().put(api.putHHouseUserHold,data: formData).then((response){
          var data = response.data;
//          print(data);
          if(data['code']==200){
//            print('suss');
            Fluttertoast.showToast(
                msg: "保存成功",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0).then((val){
              Navigator.of(context).pop();
            });
          }
        });
      });
    }
  }
}
