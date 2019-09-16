import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'api.dart';
import 'package:dio/dio.dart';

class ReadingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<ReadingPage>{
  Api api = new Api();
  int infoId = 0;
  var news;
  @override
  Widget build(BuildContext context) {
    infoId = ModalRoute.of(context).settings.arguments;
    if(news==null){
      getNews(infoId);
    }
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('新闻详情'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: news==null?null:Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0 , 10, 0, 10),
                width: MediaQuery.of(context).size.width,
                child: Text(news['inforTitle'],style: TextStyle(fontSize: 18,fontWeight:FontWeight.w700 ),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0 , 0, 0, 10),
                width: MediaQuery.of(context).size.width,
                child: Text(news['createTime'],style: TextStyle(fontSize: 12 ),),
              ),
              Html(data: news['inforContent']==null?'':news['inforContent'])
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print(news);
      }),
    );
  }
  getNews(int id) {
    print('get');
    var url = api.informationOne + '?inforId=$infoId';
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
//        print(content['data']);
        setState(() {
          news = content['data'];
        });
//        return
      }
    });
  }
}