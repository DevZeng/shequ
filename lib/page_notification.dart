import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'model.dart';
import 'api.dart';

class NotificationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}
class Page extends State<NotificationPage>{
  Api api = new Api();
  var news = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXq().then((val){
      Dio().get(api.getXqHHouseInformation+'?infoHouseId=$val').then((response){
        var data = response.data;
        if(data['code']==200){
          setState(() {
            news = data['data'];
          });
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('社区通知'),centerTitle: true,elevation: 0,),
      body: SingleChildScrollView(
        child: Column(
          children: news.map((info){
            return Container(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
//            color: Colors.white,
              width: MediaQuery.of(context).size.width-30,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[100],
//                    blurRadius: 2.0,
//                    spreadRadius: 1.0,
                      offset: Offset(-1.0, 1.0),
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(info['infoTitle'],overflow: TextOverflow
                        .ellipsis,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    child: Text(info['infoDetails'],overflow: TextOverflow
                        .ellipsis,style: TextStyle(fontSize: 18,color: Colors.grey[400]),),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(child: Text(info['createTime'],style: TextStyle(fontSize: 18,color: Colors.grey[400]),),
                          width: MediaQuery.of(context).size.width*0.6-60,),
                        Container(child: Text(info['infoAuthor'],style: TextStyle(fontSize: 18,color: Colors.grey[400]),textAlign: TextAlign.right,),
                          width: MediaQuery.of(context).size.width*0.4,),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}