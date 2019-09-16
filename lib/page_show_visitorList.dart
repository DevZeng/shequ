import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class showVisitorListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _showVisitorListPage();
  }
}
class _showVisitorListPage extends State<showVisitorListPage>{
  int id = 0;
  int type =0;
  String imageUrl = '';
  Api api = new Api();
  var info = null;
  var param = null;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController idController = new TextEditingController();
  TextEditingController reasonController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(info==null){
      param= ModalRoute.of(context).settings.arguments;
      info = param['info'];
      type = param['type'];
//    getProducts(1);
      print(type);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(elevation: 0,),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.2,
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
                            image: NetworkImage(
                                info==null?'':info['visitorHead']),
                            fit: BoxFit.cover)),
                  ),
                  onTap: (){
                    getImage();
                  },
                )),
            Divider(height: 1,),
            Container(
              child: ListTile(leading:Text('访客名称*'),title: Text(info==null?'':info['visitorName']),),
              color: Colors.white,
            ),
            Divider(height: 1,),
            Container(
              child: ListTile(leading:Text('身份证'),title: Text(info==null?'':info['visitorCard']),),
              color: Colors.white,
            ),
            Divider(height: 1,),
            Container(
              child: ListTile(leading:Text('电话号码'),title: Text(info==null?'':info['visitorPhone'].toString()),),
              color: Colors.white,
            ),
//            Divider(height: 1,),
//            Container(
//              child: ListTile(leading:Text('理由'),title: Text(info==null?'':info['visitorReason']),),
//              color: Colors.white,
//            ),
            Divider(height: 1,),
            type==1?Container():Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),child: Container(
              width: MediaQuery.of(context).size.width*0.7,
              height: 40.0  ,
              child: new RaisedButton(onPressed: (){
                Dio().delete(api.delHVisitorRoom+"/${info['visitorId']}").then((response){
                  var data = response.data;
                  print(data);
                  if(data['code']==200){
                    Navigator.of(context).pop();
                  }
                });
//          print(detailController.text);
              },color: Colors.red,
                child: new Text("删除",style: TextStyle(color: Colors.white,)),
                shape: new StadiumBorder(side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.red,
                )),
              ),
            ),)
          ],
        ),
      ),

    );
  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery).catchError((error){
      Fluttertoast.showToast(
          msg: "仅支持JPG格式的图像文件！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    });
    _upLoadImage(image);
  }
  _upLoadImage(File image) async {
    print('start');
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
          imageUrl = url;
        });
      }
    }).catchError((error) {
      print(error.toString());
    });
  }
  submitVisitor() {
    if(imageUrl.length==0||nameController.text.length==0){
      return ;
    }
    getUser().then((val){
      var fromData = {
        "token":val,
        "visitorRoomId":id.toString(),
        "visitorName":nameController.text,
        "visitorHead":imageUrl,
        "visitorCard":idController.text,
        "visitorReason":reasonController.text,
        "visitorPhone":phoneController.text
      };
      print(fromData);
      Dio().post(api.postHVisitor,data: fromData).then((response){
        if(response.statusCode==200){
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
  }
}