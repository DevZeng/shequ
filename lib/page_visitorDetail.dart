import 'package:flutter/material.dart';
import 'model.dart';
import 'api.dart';
import 'package:dio/dio.dart';

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
  @override
  Widget build(BuildContext context) {
    if(id==0){
      id = ModalRoute.of(context).settings.arguments;
      getLists(1);
//    getProducts(1);
    print(id);
    }
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('访客详情'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: lists.length,
          itemBuilder: (context,index){
        return ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(lists[index]['visitorHead']),),title: Text('${lists[index]['visitorName']}   ${lists[index]['visitorPhone']}'),trailing: RaisedButton(onPressed: (){
          Dio().delete(api.delHVisitorRoom+"/${lists[index]['visitorId']}").then((response){
            var data = response.data;
            print(data);
            if(data['code']==200){
              setState(() {
                lists.removeAt(index);
              });
            }
          });
        },color: Colors.red,child: Text('删除',style: TextStyle(color: Colors.white),),),);
      }),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 40.0  ,
        child: new RaisedButton(onPressed: (){
//          print(lists);
                    Navigator.of(context).pushNamed('addVisitorList',arguments: id);
//          print(detailController.text);
        },color: Color.fromRGBO(243, 200, 70, 1),
          child: new Text("添加",style: TextStyle(color: Colors.white,)),
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
      Dio().get(api.getUserHVisitorRoom+"?token=${val}&page=${page}&roomId=${id}&length=10").then((response){
        var data = response.data;
        if(data['code']==200){
          setState(() {
            lists = data['data']['listVisitor'];
          });
        }
      });
    });
  }
}
