import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';

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
  Api api = new Api();
  @override
  void initState() {
    super.initState();
    getRooms(1).then((val){
//            print(val);
      lists = val;setState(() {

      });});
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener((){
//      print(_tabController.index);
      switch(_tabController.index){
        case 0:
          getRooms(1).then((val){
//            print(val);
            lists = val;setState(() {

          });});
          break;
      }
    });
  }
  getRooms(int page)async{
    var returnData = [];
    String token = await getUser();
    Response response = await Dio().get(api.getUserHVisitorRoom+'?token=$token&start=$page&length=10');
    var data = response.data;
    if(data['code']==200){
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
          elevation: 0,
          bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.yellow,
              unselectedLabelColor: Colors.black,
              tabs: tabs.map((e) => Tab(text: e)).toList())),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(

            child: ListView.builder(
      itemCount: lists.length,
          itemExtent: 50.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return ListTile(leading: ImageIcon(AssetImage('images/visitor.png')),title: Text(lists[index]['roomName']),trailing: FlatButton(onPressed: (){}, child: Text('查看')));
          }
      )),
          Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print(lists);
      }),
    );
  }
}
