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

class FamilyDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<FamilyDetail> {
  List<String> types = ['家庭成员', '户主', '管理人员', '租客'];
//  HouseInfo houseInfo = new HouseInfo();
  Api api = new Api();
  var info = null;
  int type ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHoldType().then((val){
      setState(() {
        type = val;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(info==null){
      info = ModalRoute
          .of(context)
          .settings
          .arguments;
      print(info);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('家庭成员信息',),
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
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          image: DecorationImage(
                              image: NetworkImage(info==null?'':info['image']),
                              fit: BoxFit.cover)),
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
                child: ListTile(
                  title: Text(info==null?'':info['name']),
                  leading: Text('姓名'),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ListTile(
                  title: Text(info==null?'':info['sex']),
                  leading: Text('性别'),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ListTile(
                  title: Text(info==null?'':info['idcard']),
                  leading: Text('身份证号码'),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: ListTile(
                    title: Text(info==null?'':types[info['identity']]),
                    leading: Text('与户主关系'),
                  )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: type==1&&info['identity']!=1?Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7,
        height: 40.0,
        child: new RaisedButton(
          onPressed: () {
            saveInfo();
//          print(info);
          },
          color: Color.fromRGBO(243, 200, 70, 1),
          child: new Text(info['status']==0?'审核':'删除',
              style: TextStyle(
                color: Colors.white,
              )),
          shape: new StadiumBorder(
              side: new BorderSide(
                style: BorderStyle.solid,
                color: Color.fromRGBO(243, 200, 70, 1),
              )),
        ),
      ):null,
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
          FlutterImageCompress.compressAndGetFile(image.path,image.path).then((newImage){
            print('compress');
            _upLoadImage(newImage);
          });

        });

      }
      if(val==2){
        ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 60).then((image){
          FlutterImageCompress.compressAndGetFile(image.path,image.path).then((newImage){
            print('compress');
            _upLoadImage(newImage);
          });
        });
      }
    });
  }

  saveInfo() {
    print(info);
//    print(houseInfo.id);
    if (info['status']==0) {
      showModalBottomSheet(context: context, builder: (BuildContext context){
        return Column(
          children: <Widget>[
            ListTile(
              title: Text('通过'),
              onTap: (){
                Navigator.of(context).pop(1);
              },
            ),
            ListTile(
              title: Text('不通过'),
              onTap: (){
                Navigator.of(context).pop(2);
              },
            )
          ],
        );
      }).then((val){
        if(val!=null){
          getUser().then((token) {
            getHold().then((hold){
              var formData = {
                "token":token,
                "familyHoldId":hold,
                "familyId":info['id'],
                "familyType":info['type'],
                "familyStatus":val,
              };
              print(formData);
              Dio().put(api.passUserFamily,data: formData).then((response){
                print(response);
                if(response.statusCode==200){
                  var data = response.data;
                  if(data['code']==200){
                    Fluttertoast.showToast(
                        msg: "审核成功！",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0);
                    setState(() {
                      info['status'] = val;
                    });
                    Navigator.of(context).pop();
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
                }
              });
            });
          });
        }
      });

    } else {
      getUser().then((val) {
        getHold().then((hold){
          Dio().delete(api.delHHouseUserFamily+"/${val}/${hold}/${info['id']}/${info['type']}").then((response){
            if(response.statusCode==200){
              Fluttertoast.showToast(
                  msg: "删除成功！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
              print('delete');
              Navigator.of(context).pop();
            }
          });
        });
        
      });
    }
  }
}
