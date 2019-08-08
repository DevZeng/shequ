import 'package:flutter/material.dart';

class NeedPayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<NeedPayPage>
    with SingleTickerProviderStateMixin{
  @override
  TabController _tabController; //需要定义一个Controller
  List tabs = ["物业费", "水费", "停车费"];

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('缴费服务'),
        elevation: 0,
        bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.black,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((e) { //创建3个Tab页
          return Container(
            alignment: Alignment.center,
            child: Text(e, textScaleFactor: 5),
          );
        }).toList(),
      ),
    );
  }
}