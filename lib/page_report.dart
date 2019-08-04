import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'api.dart';
import 'package:dio/dio.dart' ;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


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
  int type = 1 ;
  Api api = new Api();
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
                      child: Text('投诉'),
                      color: type==1?Colors.yellow:Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    height: 25,
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: (){setState(() {
                        type = 2;
                      });},
                      child: Text('建议'),
                      color: type==2?Colors.yellow:Colors.white,
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
                onPressed: null,
                color: Color.fromRGBO(240, 190, 60, 1),
                disabledColor: Color.fromRGBO(240, 190, 60, 1),
                child: new Text("提交",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                shape: new StadiumBorder(
                    side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(240, 190, 60, 1),
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
      );
    } on Exception catch (e) {
      error = e.toString();
    }


    getImageFileFromAssets(resultList[0]).then((file){
      upLoadImage(file);
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  List<Widget> loadAssetWidgets() {
    List<Widget> widgets = [];
    if (images.length == 0) {
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
          child: IconButton(icon: Icon(Icons.ac_unit), onPressed: loadAssets),
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
        child: IconButton(icon: Icon(Icons.ac_unit), onPressed: loadAssets),
      ));
      for (var i = 0; i < images.length; i++) {
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
              child: AssetThumb(
                asset: images[i],
                width: 60,
                height: 60,
              ),
              onTap: () {
                images.removeAt(i);
                setState(() {
                  images = images;
                });
              },
            )));
      }
    }
    return widgets;
  }
  Future<File> getImageFileFromAssets(Asset image) async {
    final byteData = await image.requestOriginal();

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
    var response = await dio.post(api.upload, data: formData);
    print(response);
  }
}
