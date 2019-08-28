import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';

class SearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _searchPage();
  }
}

class _searchPage extends State<SearchPage>{
  Api api = new Api();
  var lists = [];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      appBar: AppBar(title: Text('搜索结果'),centerTitle: true,elevation: 0,),
      body: SafeArea(child: Container(
//      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Container(
                //修饰黑色背景与圆角
                decoration: new BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(50.0)),
                ),
                alignment: Alignment.center,
                height: 30,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 30,
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.only(left: 0.0),
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: "搜索周边服务",
                      hintStyle: new TextStyle(
                          fontSize: 14, color: Colors.grey)),
                  style: new TextStyle(fontSize: 14, color: Colors.grey),
                  onSubmitted: (val){
                    search(val);
                  },
                ),
              )),
            Expanded(child: ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context,index){
                  return ListTile(title: Text(lists[index]['shopName']),
                  onTap: (){
                    switch(lists[index]['shopType']){
                      case 1:
                        Navigator.of(context).pushNamed('outsellerDetail',arguments: lists[index]['shopId']);
                        break;
                      case 2:
                        Navigator.of(context).pushNamed('lifeStore',arguments: lists[index]['shopId']);
                        break;
                      case 3:

                        Navigator.of(context).pushNamed('stayDetail',arguments: {
                          'id':lists[index]['shopId'],
                          'indate':DateTime.now(),
                          'outdate':DateTime.now().add(new Duration(days: 1)),
                        });
                        break;
                    }
                  },);
                })),
          ],
        ),
      )),
    );
  }
  search(key){
    Dio().get(api.searchShop+'?key=${key}').then((response){
      if(response.statusCode==200){
        var data = response.data;
        if(data['code']==200){
          setState(() {
            lists = data['data'];
          });
        }
      }
    });
  }
}