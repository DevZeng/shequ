import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'api.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepairPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _repairPage();
  }
}

class _repairPage extends State<RepairPage>{
  int type = 0;
  List<Asset> images = List<Asset>();
  DateTime time ;
  TimeOfDay day;
  var types = [];
  Api api = new Api();
  String typeName = '';
  int holdId = 0 ;
  List<String> imgUrls = [];
  TextEditingController titleController = new TextEditingController();
  TextEditingController detailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTypes();
    getAddress().then((val){
      setState(() {
        addressController.text = val;
      });
    });
    getHold().then((val){
      if(val!=null){
        setState(() {
          holdId=val;
        });
      }
    });
  }
  getHold() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int holdId = prefs.getInt('holdId');
    return holdId;
  }
//  List<Asset> images = List<Asset>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('报修预约'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: () {
            Navigator.of(context).pushNamed('repairList');
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    Expanded(child: ListView.builder(
                        itemCount: types.length,
                        scrollDirection: Axis.horizontal,
//                      itemExtent: 25,
                        itemBuilder: (context,index){
                          return Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,10),child: Container(
                            width: MediaQuery.of(context).size.width*0.16,
                            child: RaisedButton(
                              onPressed: (){setState(() {
                                type = types[index]['repairTypeId'];
                                typeName = types[index]['repairTypeName'];
                              });},
                              child: Text(types[index]['repairTypeName'],
                              style: TextStyle(
                                color: type==types[index]['repairTypeId']?Colors.white:Colors.black
                              ),),
                              color: type==types[index]['repairTypeId']?Color.fromRGBO(243, 200, 70, 1):Colors.white,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                            ),
                            height: 25,
                          ),);
                        }))
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
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none, hintText: "请输入主题"),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    TextField(
                      controller: detailController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "请输入描述内容..."),
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
                  trailing: GestureDetector(
                    child: Text(time==null?'请选择 >':"${time.year}-${time.month}-${time.day} ${day==null?'':day.hour.toString()+':'+day.minute.toString()}",style: TextStyle(color: Colors.grey),),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: new DateTime.now().add(new Duration(days: 1)),
                        firstDate: new DateTime.now(),
                        // 减 30 天
                        lastDate: new DateTime.now()
                            .add(new Duration(days: 30)),
                      ).then((val) {
                        if (val != null) {
                          time = val;
                          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((val){
                            if(val!=null){
                              day = val;
                            }
                            setState(() {});
                          });
                        }
                        setState(() {});
                      });
                    },
                  ),
                ),),
              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                height: 50,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Text('住户地址'),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "请输入地址"),
                          )),
                    )
                  ],
                ),),
              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                height: 50,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Text('联系电话'),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "请输入联系电话"),
                          )),
                    )
                  ],
                ),),
              Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),child: Container(
                child: RaisedButton(
                  onPressed: (){
//                    print(imgUrls.join(','));
                    submitRepair();
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
              ),)
            ],
          ),
        ),
      ),
    );
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
          child: IconButton(icon: Icon(Icons.camera_alt,color: Colors.grey[300],), onPressed: loadAssets),
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
        child: IconButton(icon: Icon(Icons.camera_alt), onPressed: loadAssets),
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
  getTypes() {
    getHold().then((val){
      Dio().get(api.getAllHRepairType+'holdId=${val}').then((response){
        if(response.statusCode==200){
          var data = response.data;
          if(data['code']==200){
            setState(() {
              types = data['data'];
            });
          }
        }
      });
    });

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
      print(data);
      if(data['code']==200){
        setState(() {
          imgUrls.add(data['data']);
        });
      }
    }catch (error){
      print(error);
    }
  }

  submitRepair() {
    print('up');
    getUser().then((val){
      print(val);
      var fromData = {
        "token":val,
        "repairTitle":titleController.text,
        "repairPicture":imgUrls.length==0?'':imgUrls.join(','),
        "repairAddress":addressController.text,
        "repairMakeTime":"${time.year}-${time.month}-${time.day} ${day.hour}:${day.minute}",
        "repairUserPhone":phoneController.text,
        "repairTypeName":typeName,
        "repairHoldId":holdId
      };
      print(fromData);
      Dio().post(api.postHRepair,data: fromData).then((response){
        if(response.statusCode==200){
          var data = response.data;
          print(data);
          if(data['code']==200){

          }
        }
      });
    });
  }
}