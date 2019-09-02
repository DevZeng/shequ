import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:dio/dio.dart';
import 'api.dart';


class CommentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _commentPage();
  }
}

class _commentPage extends State<CommentPage> {
  double a = 4.1;
  int id = 0;
  Api api = new Api();
  var lists = [];
  var info = null;
  var images = [
    'http://hongyuan-1258763596.cos.ap-guangzhou.myqcloud.com/hy/2019/156463976334501.jpg',
    'http://hongyuan-1258763596.cos.ap-guangzhou.myqcloud.com/hy/2019/156463976334501.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    if(id==0){
      id = ModalRoute.of(context).settings.arguments;
      getComments(1);
//    getProducts(1);
      print(id);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('全部评论'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0, 1, 0, 0)),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
//              color: Colors.red,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200], width: 1)),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
//                          color: Colors.white,
                        border: Border.all(color: Colors.grey[200], width: 1)),
                    child: Center(
                      child: Text(info==null?'':'${info['comprehensiveScore']}分',style: TextStyle(color: Colors.red),),
                    ),
                  ),
                  Expanded(child: Wrap(
                    spacing: 8.0, // 主轴(水平)方向间距
                    runSpacing: 10.0, // 纵轴（垂直）方向间距
                    alignment: WrapAlignment.start, //沿主轴方向居中
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width*0.5-50,
//                        color: Colors.red,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Padding(padding: EdgeInsets.fromLTRB(15, 0, 20, 0),child: Text('位置'),),
                            ),
                            Container(color: Colors.grey,
                              height: 4,width: MediaQuery.of(context).size.width*0.14,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    color: Colors.yellow,
                                    height: 4,
                                    width: MediaQuery.of(context).size.width*0.14*(info==null?0:info['tcommentWd']/5),
                                  )
                                ],
                              ),),
                            Container(
                              child: Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0),child: Text(info==null?"0":'${info['tcommentWd']}',style: TextStyle(color: Colors.grey),),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width*0.5-50,
//                        color: Colors.red,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Padding(padding: EdgeInsets.fromLTRB(15, 0, 20, 0),child: Text('服务'),),
                            ),
                            Container(color: Colors.grey,
                              height: 4,width: MediaQuery.of(context).size.width*0.14,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    color: Colors.yellow,
                                    height: 4,
                                    width: MediaQuery.of(context).size.width*0.14*(info==null?0:info['tcommentBz']/5),
                                  )
                                ],
                              ),),
                            Container(
                              child: Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0),child: Text(info==null?"0":info['tcommentBz'].toString(),style: TextStyle(color: Colors.grey),),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width*0.5-50,
//                        color: Colors.red,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Padding(padding: EdgeInsets.fromLTRB(15, 0, 20, 0),child: Text('卫生'),),
                            ),
                            Container(color: Colors.grey,
                              height: 4,width: MediaQuery.of(context).size.width*0.14,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    color: Colors.yellow,
                                    height: 4,
                                    width: info==null?0:MediaQuery.of(context).size.width*0.14*info['tcommentPs']/5,
                                  )
                                ],
                              ),),
                            Container(
                              child: Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0),child: Text(info==null?"0":"${info['tcommentPs']}",style: TextStyle(color: Colors.grey),),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),)
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: lists.length==0?Container():ListView.builder(
                  itemCount: lists.length,
                  itemBuilder: (context,index){
                    return Container(
                      color: Colors.white,
                      child: Padding(padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                        child: Container(
//                color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5),child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(lists[index]['userMsgHead']),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width-90,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 30,
                                            alignment: Alignment.bottomLeft,
                                            width: MediaQuery.of(context).size.width-90,
                                            child: Text(lists[index]['userMsgNike'],style: TextStyle(fontSize: 20),),
                                          ),
                                          Container(
                                            height: 30,
                                            width: MediaQuery.of(context).size.width-90,
                                            child: SmoothStarRating(
                                                allowHalfRating: false,
                                                starCount: 5,
                                                rating: (lists[index]['tcommentWd']+lists[index]['tcommentBz']+lists[index]['tcommentPs'])/3,
                                                size: 14.0,
                                                color: Colors.yellow,
                                                borderColor: Colors.yellow,
                                                spacing:0.0
                                            )
                                            ,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(lists[index]['tcommentContent']),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5),child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(lists[index]['createTime'],style: TextStyle(color: Colors.grey),),
                              ),),
                              Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: lists[index]['tcommentPicture'].split(',').length,
                                    itemBuilder: (context,index){
                                      return Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(lists[index]['tcommentPicture'].split(',')[index]))
                                        ),
//                        child: ,
                                      ),);
                                    }),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Divider(height: 1,),)
                            ],
                          ),
                        ),),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
  getComments(page) {
    Dio().get(api.getShopComment+'?tCommentShopId=${id}&start=${page}&length=10&tCommentType=2').then((response){
      var data = response.data;
      if(data['code']==200){
//        var images = data['data']['list'];
        setState(() {
          info = data['data'];
         lists = data['data']['list'];

        });
      }
    });
  }
}
