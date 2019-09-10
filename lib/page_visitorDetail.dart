import 'package:flutter/material.dart';
import 'model.dart';
import 'api.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisitorDetailPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _visitorDetailPage();
  }
}

class _visitorDetailPage extends State<VisitorDetailPage>{
  int id = 0;
  var lists = [];
  Api api = new Api();
  var args ;
  int type = 0;
  @override
  Widget build(BuildContext context) {
    if(id==0){
       args = ModalRoute.of(context).settings.arguments;
      id = args['id'];
      type = args['type'];
      getLists(1);
//    getProducts(1);
    print(id);
    }
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('访客详情'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: buildList(),
        ),
      ),
      floatingActionButton: type==1?null:Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 40.0  ,
        child: new RaisedButton(onPressed: (){
          Dio().post(api.passVisitorRoom,data: {'roomId':id,'roomStatus':1}).then((response){
            if(response.statusCode==200){
              var data = response.data;
              if(data['code']==200){
                Fluttertoast.showToast(
                    msg: '审核通过！',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16.0);
                Navigator.of(context).pop();
//                setState(() {
//                  type == 1;
//                });
              }
            }
          });
//          print(lists);
//                    Navigator.of(context).pushNamed('addVisitorList',arguments: id);
//          print(detailController.text);
        },color: Color.fromRGBO(243, 200, 70, 1),
          child: new Text("审核",style: TextStyle(color: Colors.white,)),
          shape: new StadiumBorder(side: new BorderSide(
            style: BorderStyle.solid,
            color: Color.fromRGBO(243, 200, 70, 1),
          )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  getLists(page){
    getUser().then((val){
      Dio().get(api.getHVisitor+"?roomId=${id}").then((response){
        var data = response.data;
        print(data);
        if(data['code']==200){
          setState(() {
            lists = data['data'];
          });
        }
      });
    });
  }
  buildList()
  {
    List<Widget> returnWidgets = [];
    print(lists);
    for(int i=0;i<lists.length;i++){
      returnWidgets.add(ListTile(onTap: (){
        Navigator.of(context).pushNamed('showVisitorList',arguments:{'info':lists[i],'type':type} ).then((val){
          getLists(1);
        });
      },title: Text('${lists[i]['visitorName']}  ${lists[i]['visitorPhone']}'),trailing: type==1?null:RaisedButton(onPressed: (){
        Dio().delete(api.delHVisitorRoom+"/${lists[i]['visitorId']}").then((response){
          var data = response.data;
          print(data);
          if(data['code']==200){
            setState(() {
              lists.removeAt(i);
            });
          }
        });
      },color: Colors.red,child: Text('删除',style: TextStyle(color: Colors.white),),),));
    }
    returnWidgets.add( type==1?Container():Container(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 40.0  ,
        child: new RaisedButton(onPressed: (){
//          print(lists);
          Navigator.of(context).pushNamed('addVisitorList',arguments: id).then((val){
            getLists(1);
          });
//          print(detailController.text);
        },color: Color.fromRGBO(243, 200, 70, 1),
          child: new Text("添加",style: TextStyle(color: Colors.white,)),
          shape: new StadiumBorder(side: new BorderSide(
            style: BorderStyle.solid,
            color: Color.fromRGBO(243, 200, 70, 1),
          )),
        ),
      ),
    ));
    return returnWidgets;
  }
}
