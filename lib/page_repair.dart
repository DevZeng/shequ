import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class RepairPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _repairPage();
  }
}

class _repairPage extends State<RepairPage>{
  int type = 1;
  List<Asset> images = List<Asset>();
//  List<Asset> images = List<Asset>();
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
                  Container(
                    child: Text('类型：'),
                    width: MediaQuery.of(context).size.width*0.2-32,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    padding: EdgeInsets.fromLTRB(8, 0 , 8, 0),
                    child: RaisedButton(
                      onPressed: (){setState(() {
                        type = 1;
                      });},
                      child: Text('管道'),
                      color: type==1?Colors.yellow:Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    padding: EdgeInsets.fromLTRB(8, 0 , 8, 0),
                    child: RaisedButton(
                      onPressed: (){setState(() {
                        type = 2;
                      });},
                      child: Text('电器'),
                      color: type==2?Colors.yellow:Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    padding: EdgeInsets.fromLTRB(8, 0 , 8, 0),
                    child: RaisedButton(
                      onPressed: (){setState(() {
                        type = 3;
                      });},
                      child: Text('物业',style: TextStyle(color: type==3?Colors.white:Colors.black),),
                      color: type==3?Colors.yellow:Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    padding: EdgeInsets.fromLTRB(8, 0 , 8, 0),
                    child: RaisedButton(
                      onPressed: (){setState(() {
                        type = 4;
                      });},
                      child: Text('其他'),
                      color: type==4?Colors.yellow:Colors.white,
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
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            Container(
              color:Colors.white,
                child: ListTile(
                  leading: Text('预约时间'),
                  trailing: Text('请选择>'),
                ),),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            Container(
              color:Colors.white,
              child: ListTile(
                leading: Text('住户地址'),
                title:TextField(),
              ),),

          ],
        ),
      ),
      floatingActionButton: Container(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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

    setState(() {
      if(resultList!=null){
        images = resultList;
      }

    });
  }
}