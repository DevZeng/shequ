import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluttertoast/fluttertoast.dart';

class VisitorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _visitorPage();
  }
}

class _visitorPage extends State<VisitorPage>
    with SingleTickerProviderStateMixin {
  @override
  TabController _tabController;
  List tabs = ["待审核", "历史来访"];
  var lists = [];
  var histories = [];
  Api api = new Api();
  int type = 0;
  int page = 0;

  @override
  void initState() {
    super.initState();
    getRooms(1,0).then((val) {
            print(val);
      lists = val;
      setState(() {});
    });
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
//      print(_tabController.index);
      switch (_tabController.index) {
        case 0:
          getRooms(1,0).then((val) {
            print(val);
            lists = val;
            type = 0;
            setState(() {});
          });
          break;
        case 1:
          getRooms(1,1).then((val) {
            print(val);
            histories = val;
            type = 1;
            setState(() {});
          });
          break;
      }
    });
  }

  getRooms(int page,int type) async {
    String url ;
    String token = await getUser();
    int holdId = await getHold();
    if(type==0){
      url = api.getUserHVisitorRoom + '?token=$token&start=$page&roomHoldId=$holdId&length=10&roomStatus=0';
    }else{
      url = api.getUserHVisitorRoom + '?token=$token&start=$page&length=10&roomHoldId=$holdId';
    }
    print(url);
    var returnData = [];
    Response response = await Dio()
        .get(url);
    var data = response.data;
    if (data['code'] == 200) {
      returnData = data['data'];
    }
    return returnData;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text('访客管理'),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
              controller: _tabController,
              labelColor: Color.fromRGBO(243, 200, 70, 1),
              indicatorColor: Color.fromRGBO(243, 200, 70, 1),
              unselectedLabelColor: Colors.black,
              tabs: tabs.map((e) => Tab(text: e)).toList())),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
              child: ListView.builder(
                  itemCount: lists.length,
//                  itemExtent: 50.0, //强制高度为50.0
                  itemBuilder: (BuildContext context, int index) {
                    return Container(

                      decoration: BoxDecoration(
                          color:  Colors.white,
                          border: Border.all(color: Colors.grey[100])

                      ),
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).pushNamed('visitorDetailPage',arguments:{
                            'id':lists[index]['roomId'],
                            'type':type
                          });
                        },
                        leading: ImageIcon(AssetImage('images/visitor.png')),
                        title: Text('${lists[index]['totaNumber']==null?0:lists[index]['totaNumber']}人  '),
                        trailing:
                        OutlineButton(onPressed: () {
                          fluwx.share(fluwx.WeChatShareWebPageModel(
                              webPage: api.share+'?visitorRoomId=${lists[index]['roomId']}',
                              title: '鸿源智慧社区来访登记',
                              thumbnail: "assets://images/share.jpg",
                              scene: fluwx.WeChatScene.SESSION,
                              transaction: "访客申请"
                          ));
//                              print(lists[index]['roomId']);
//                          showModalBottomSheet(context: context, builder: (context){
//                            return Column(
//                              children: <Widget>[
//                                ListTile(title: Text('分享给朋友'),onTap: (){
//                                  fluwx.share(fluwx.WeChatShareWebPageModel(
//                                      webPage: api.share+'?visitorRoomId=${lists[index]['roomId']}',
//                                      title: '鸿源智慧社区来访登记',
//                                      thumbnail: "assets://images/share.jpg",
//                                      scene: fluwx.WeChatScene.SESSION,
//                                      transaction: "访客申请"
//                                  ));
//                                },),
//                                ListTile(title: Text('自己添加访客'),onTap: (){
////                                      Navigator.of(context).pushNamed('visitorDetailPage',arguments:lists[index]['roomId']);
//                                  Navigator.of(context).pushNamed('addVisitorList',arguments: lists[index]['roomId']);
//                                },),
//                              ],
//                            );
//                          });
                        }, child: Text('立即邀请')),onLongPress: (){
                        showDialog(context: context,
                            builder: (BuildContext context){
                              return new SimpleDialog(
                                title: new Text('操作'),
                                children: <Widget>[
                                  new SimpleDialogOption(
                                    child: new Text('删除'),
                                    onPressed: () {
                                      getUser().then((val){
                                        Dio().delete(api.delHVisitorRoom+"/${lists[index]['roomId']}/${val}").then((response){
                                          print(response);
                                        });
                                      });
                                      Navigator.of(context).pop(1);
                                    },
                                  ),
                                ],
                              );
                            }).then((val){
                          if(val==1){
                            lists.removeAt(index);
                            setState(() {

                            });
                          }
                        });
                        print('long');
                      },),

                    );
                  })),
          Container(
              child: ListView.builder(
                  itemCount: histories.length,
//                  itemExtent: 50.0, //强制高度为50.0
                  itemBuilder: (BuildContext context, int index) {
                    return   Container(
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        border: Border.all(color: Colors.grey[100])

                      ),
                      child: ListTile(
//                        contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        onTap: (){
                          Navigator.of(context).pushNamed('visitorDetailPage',arguments:{
                            'id':lists[index]['roomId'],
                            'type':type
                          });
                        },
//                        leading: ImageIcon(AssetImage('images/visitor.png')),
                        title: Text('${histories[index]['totaNumber']==null?0:histories[index]['totaNumber']}人  '+histories[index]['createTime']),
                      ),

                    );
                  })),
        ],
      ),
      floatingActionButton: type==1?null:Container(
        child: RaisedButton(
          onPressed: () {
            getUser().then((val) {
              getHold().then((id){
                var formData =
                    '{"token": "$val",  "roomToDay":1, "roomHoldId":"${id}"}';
                print(formData);
                Dio().post(api.postHVisitorRoom,data: formData).then((response){
                  var data = response.data;
                  print(data);
                  if(data['code']==200){
                    getRooms(1,0).then((val) {
                      print(val);
                      lists = val;
                      setState(() {});
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
          },
          color: Color.fromRGBO(243, 200, 70, 1),
          disabledColor: Color.fromRGBO(240, 190, 60, 1),
          child: new Text("新增访客组",
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
