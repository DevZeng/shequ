import 'package:flutter/material.dart';
import 'model.dart';

//import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class addFamily extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<addFamily> {
  List<String> types = ['家庭成员', '户主', '管理人员', '租客'];
  TextEditingController nameController = new TextEditingController();
  TextEditingController idController = new TextEditingController();
//  HouseInfo houseInfo = new HouseInfo();
  Api api = new Api();
  String imageUrl = '';
  String sex = '请选择';
  int type = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('住户信息'),
        centerTitle: true,
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
                          color: Color.fromRGBO(243, 200, 70, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover)),
                      child: imageUrl.length!=0?Container():Icon(Icons.add,size: 50,color: Colors.white,),
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
                            sex,
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
                                        sex='男';
                                        Navigator.of(context).pop();
                                      });
                                    },),
                                    ListTile(title: Text('女'),onTap: (){setState(() {
                                      sex='女';
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
                          child: Text(types[type]),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(types[0]),
                                        onTap: () {
                                          type = 0;
                                          Navigator.of(context).pop(0);
                                        },
                                      ),
                                      ListTile(
                                        title: Text(types[3]),
                                        onTap: () {
                                          type = 3;
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
            saveInfo();
//            print(info);
          },
          color: Color.fromRGBO(243, 200, 70, 1),
          child: new Text('提交',
              style: TextStyle(
                color: Colors.white,
              )),
          shape: new StadiumBorder(
              side: new BorderSide(
                style: BorderStyle.solid,
                color: Color.fromRGBO(243, 200, 70, 1),
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
    print('upload');
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData =
    new FormData.from({"file": new UploadFileInfo(new File(path), name)});
    Dio().post(api.uploadT, data: formData).then((response) {
      var data = response.data;
      print(data);
      if (data['code'] == 200) {
//        String url = ;
        setState(() {
          imageUrl = data['data'];
//          houseInfo.imageAddress = url;
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
    }).catchError((error) {
      print(error);
    });
  }

  Future getImage() async {
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        children: <Widget>[
          ListTile(title:Text('拍照'),onTap: (){Navigator.of(context).pop(1);},),
          ListTile(title:Text('相册'),onTap: (){Navigator.of(context).pop(2);}),
        ],
      );
    }).then((val){
      if(val==null){
        return ;
      }
      if(val==1){
        ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 60).then((image){
          print('select');
//          _upLoadImage(image);
          FlutterImageCompress.compressAndGetFile(image.path,image.path).then((newImage){
            print('compress');
            _upLoadImage(newImage);
          });

        });

      }
      if(val==2){
        ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 60).then((image){
          _upLoadImage(image);
        });
      }
    });

  }

  saveInfo() {
    getUser().then((token){
      getHold().then((hold){
        var fromData = {
          "token":token,
          "familyHoldId":hold,
          "familyName":nameController.text,
          "familyImage":imageUrl,
          "familySex":sex,
          "familyIdcard":idController.text,
          "familyIdentity":type,
        };
        Dio().post(api.postHHouseUserFamily,data: fromData).then((response){
          if(response.statusCode==200){
            print(response);
            var data = response.data;
            if(data['code']==200){
              Fluttertoast.showToast(
                  msg: "添加成功！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
              Navigator.of(context).pop();
            }
          }
        });
      });
    });
  }
}
