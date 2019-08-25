import 'package:flutter/material.dart';
import 'api.dart';
import 'model.dart';
import 'package:dio/dio.dart';

class RepairList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _repairList();
  }
}

class _repairList extends State<RepairList>{
  var repairs = [];
  Api api = new Api();
  List<String> status = [
    '预约中','预约成功','预约失败'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('预约列表'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: repairs.length,
          itemBuilder: (context,index){
        return Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Container(

            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.7-30,
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Text('预约类型： ',style: TextStyle(color: Colors.grey),),
                            Text(repairs[index]['repairTypeName'],style: TextStyle(fontSize: 18),)
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Text('上门时间： ',style: TextStyle(color: Colors.grey),),
                              Text(repairs[index]['repairMakeTime'],style: TextStyle(fontSize: 18))
                            ],
                          )
                      )
                    ],
                  ),
                ),
                Container(
//              color: Colors.red,
                  height: 100,
                  width: MediaQuery.of(context).size.width*0.3,
                  child: Center(child: Text(status[repairs[index]['repairStatus']],style: TextStyle(fontSize: 18,color: Colors.red)),),
                ),
              ],
            ),
          ),);
      }),
    );
  }
  getLists() {
    getUser().then((Val){
      Dio().get(api.getUserHRepair+"?token=${Val}").then((response){
        if(response.statusCode==200){
          var data = response.data;
          if(data['code']==200){
            setState(() {
              repairs = data['data'];
              print(repairs);
            });
          }
        }
      });
    });
  }
}