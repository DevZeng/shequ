import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class addVisitorListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _addVisitorListPage();
  }
}
class _addVisitorListPage extends State<addVisitorListPage>{
  int id = 0;
  String imageUrl = '';
  Api api = new Api();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController idController = new TextEditingController();
  TextEditingController reasonController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(id==0){
      id = ModalRoute.of(context).settings.arguments;
//    getProducts(1);
      print(id);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
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
                                imageUrl),
                            fit: BoxFit.fill)),
                  ),
                  onTap: (){
                    getImage();
                  },
                )),
            Divider(height: 1,),
            Container(
              child: ListTile(leading:Text('访客名称*'),title: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '请输入访客名称'),
              ),),
              color: Colors.white,
            ),
            Divider(height: 1,),
            Container(
              child: ListTile(leading:Text('身份证'),title: TextField(
                controller: idController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '请输入身份证'),
              ),),
              color: Colors.white,
            ),
            Divider(height: 1,),
            Container(
              child: ListTile(leading:Text('电话号码'),title: TextField(
                controller: phoneController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '请输入电话号码'),
              ),),
              color: Colors.white,
            ),
            Divider(height: 1,),
            Container(
              child: ListTile(leading:Text('理由'),title: TextField(
                controller: reasonController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '请输入理由'),
              ),),
              color: Colors.white,
            ),
            Divider(height: 1,),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),child: Container(
              width: MediaQuery.of(context).size.width*0.7,
              height: 40.0  ,
              child: new RaisedButton(onPressed: (){
                submitVisitor();
//          print(detailController.text);
              },color: Color.fromRGBO(243, 200, 70, 1),
                child: new Text("添加",style: TextStyle(color: Colors.white,)),
                shape: new StadiumBorder(side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(243, 200, 70, 1),
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