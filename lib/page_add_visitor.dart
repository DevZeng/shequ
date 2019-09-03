import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class addVisitorPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<addVisitorPage>{
  TextEditingController nameController = new TextEditingController();
  TextEditingController dayController = new TextEditingController();
  String xqname = '请选择';
  int id = 0;
  Api api = new Api();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('新增访客组'),elevation: 0,
        centerTitle: true,),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(leading: Text('组名称：'),title: TextField(controller: nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入组名称（选填）',
              ),
            ),),
            ListTile(leading: Text('天数：'),title: TextField(
              controller: dayController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入天数（必填）',
              ),
            ),),
//            ListTile(leading: Text('住户：'),title: GestureDetector(
//              child: Text(xqname),
//              onTap: (){
//                getInfos().then((val){
//                  showModalBottomSheet(
//                      context: (context),
//                      builder: (context) {
//                        List lists = val;
//                        return Column(
//                            children: lists.map((info) {
//                              return ListTile(
//                                  title: Text(info['holdXqName']),
//                                  onTap: () {
//                                    id = info['holdId'];
//                                    xqname = info['holdXqName'];
//                                    Navigator.of(context).pop();
//                                  });
//                            }).toList());
//                      }).then((val){
//                        setState(() {
//
//                        });
//                  });
//
//                });
//              },
//            ),),
          ],
        ),
        color: Colors.white,
      ),
      floatingActionButton: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7,
        height: 40.0,
        child: new RaisedButton(
          onPressed: () {
            addGroup();
//          print(detailController.text);
          },
          color: Color.fromRGBO(243, 200, 70, 1),
          child: new Text("保存访客组",
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
  getInfos() async {
    var listMsg = [];
    String token = await getUser();
    Response response = await Dio().get(api.getHHouseUserHold+'?token=$token');
    var data = response.data;
    if(data['code']==200){
      listMsg = data['data']['listMsg'];
    }else{

    }
    return listMsg;
  }
  addGroup(){
    getUser().then((val) {
      getHold().then((id){
        var formData =
            '{"token": "$val", "roomName": "${nameController.text}", "roomToDay":"${dayController.text}", "roomHoldId":"${id}"}';
        print(formData);
        Dio().post(api.postHVisitorRoom,data: formData).then((response){
          var data = response.data;
          print(data);
          if(data['code']==200){
            showModalBottomSheet(context: context, builder: (context){
              return Column(
                children: <Widget>[
                  ListTile(title: Text('分享给好友'),onTap: (){
                    Navigator.of(context).pop(1);
                  },)
                ],
              );
            }).then((val){
              if(val==1){
                fluwx.share(fluwx.WeChatShareWebPageModel(
                    webPage: api.share+'?visitorRoomId=${data['data']['roomId']}',
                    title: '鸿源智慧社区来访登记',
                    thumbnail: "assets://images/share.jpg",
                    scene: fluwx.WeChatScene.SESSION,
                    transaction: "访客申请"
                ));
              }
            });
          }else{
            Fluttertoast.showToast(msg: data['msg'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        });
      });
    });
  }
}