import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'api.dart';
import 'package:dio/dio.dart' ;
import 'package:path_provider/path_provider.dart';
import 'model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<ReportPage> {
  List<Asset> images = List<Asset>();
  String radioValue = 'First';
  TextEditingController contentController = new TextEditingController();
  int type = 1 ;
  Api api = new Api();
  List<String> imgUrls = [];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('投诉建议'),
        elevation: 0,
      ),
      body: Container(
//        padding: EdgeInsets.fromLTRB(15, 0 , 15, 0),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
            Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              height: 50,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Text('类型：'),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 0 , 25, 0),
                    child: RaisedButton(
                      onPressed: (){setState(() {
                        type = 1;
                      });},
                      child: Text('投诉',style: TextStyle(
                        color: type==1?Colors.white:Colors.black
                      ),),
                      color: type==1?Color.fromRGBO(243, 200, 70, 1):Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    height: 25,
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: (){setState(() {
                        type = 2;
                      });},
                      child: Text('建议',style: TextStyle(
                          color: type==2?Colors.white:Colors.black
                      )),
                      color: type==2?Color.fromRGBO(243, 200, 70, 1):Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    height: 25,
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Text('主题:'),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "请输入主题"),
                        ))
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "请输入反馈描述..."),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Wrap(
                spacing: 8.0, // 主轴(水平)方向间距
                runSpacing: 4.0, // 纵轴（垂直）方向间距
                alignment: WrapAlignment.start,
                children: loadAssetWidgets(),
              ),
            ),
            Container(
                child: null, height: MediaQuery.of(context).size.height * 0.12),
            Container(
              child: RaisedButton(
                onPressed: (){
                  submit();
                },
                color: Color.fromRGBO(240, 190, 60, 1),
                disabledColor: Color.fromRGBO(240, 190, 60, 1),
                child: new Text("提交",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                shape: new StadiumBorder(
                    side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(243, 200, 70, 1),
                )),
              ),
              width: MediaQuery.of(context).size.width * 0.6,
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if(resultList!=null){
      print('dd');
      resultList.forEach((result){
        getImageFileFromAssets(result).then((val){
          upLoadImage(val);
        });
      });
    }

  }

  List<Widget> loadAssetWidgets() {
    List<Widget> widgets = [];
    if (imgUrls.length == 0) {
      widgets = [
        Container(
          width: 70,
          height: 70,
//                    color: Colors.yellow,
          decoration: BoxDecoration(
              border: Border.all(
            //添加边框
            width: 1, //边框宽度
            color: Colors.grey[100], //边框颜色
          )),
          child: IconButton(icon: Icon(Icons.camera_alt,color: Colors.grey,), onPressed: loadAssets),
        ),
      ];
    } else {
      widgets.add(Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            border: Border.all(
          //添加边框
          width: 1, //边框宽度
          color: Colors.grey[100], //边框颜色
        )),
        child: IconButton(icon: Icon(Icons.camera_alt,color: Colors.grey,), onPressed: loadAssets),
      ));
      for (var i = 0; i < imgUrls.length; i++) {
        widgets.add(Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                border: Border.all(
              //添加边框
              width: 1, //边框宽度
              color: Colors.grey[100], //边框颜色
            )),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image:NetworkImage(imgUrls[i]),fit: BoxFit.fill)
                ),
                width: 60,
                height: 60,
              ),
              onTap: () {
                imgUrls.removeAt(i);
                setState(() {
                  imgUrls = imgUrls;
                });
              },
            )));
      }
    }
    return widgets;
  }
  Future<File> getImageFileFromAssets(Asset image) async {
    print('makefile');
    final byteData = await image.getByteData();
    final file = File('${(await getTemporaryDirectory()).path}/${image.name}');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
  upLoadImage(File image) async {

    String path = image.path;
    print(path);
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(image, name)
    });
    Dio dio = new Dio();
    try{
      print('uppload');
      var response = await dio.post(api.upload, data: formData);
      var data = response.data;
      if(data['code']==200){
        setState(() {
          imgUrls.add(data['data']);
        });
      }
    }catch (error){
      print(error);
    }
  }
  void submit() async {
    getUser().then((val){
      var formData = {"token": val, "complaintContent": contentController.text, "complaintPicture":imgUrls.join(','),"complaintType":type};
      Dio().post(api.postHComplaint,data: formData).then((response){
        var data = response.data;
        if(data['code']==200){
          Fluttertoast.showToast(
              msg: "提交成功！",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      });
    });
  }
}
