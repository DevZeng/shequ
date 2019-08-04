import 'package:flutter/material.dart';

class PersonalPage extends StatelessWidget {
  var menus = [
    {
      'icon':'images/info.png',
      'title':'住户信息'
    },
    {
      'icon':'images/info.png',
      'title':'我的地址'
    },
    {
      'icon':'images/info.png',
      'title':'缴费服务'
    },
    {
      'icon':'images/info.png',
      'title':'保修预约'
    },
    {
      'icon':'images/info.png',
      'title':'社区通知'
    },
    {
      'icon':'images/info.png',
      'title':'投诉建议'
    }
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      backgroundColor: Colors.yellow,
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: Column(
          children: <Widget>[
            Expanded(child: ListView.separated(
              itemCount: menus.length,
              //列表项构造器
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(child: Row(children: <Widget>[
                  Container(
                    child: ImageIcon(AssetImage(menus[index]['icon'])),
                    width: MediaQuery.of(context).size.width*0.1-15,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(menus[index]['title']),
                    width: MediaQuery.of(context).size.width*0.8-15,
                  ),
                  Container(
                    child: Text('>',textAlign: TextAlign.end,),
                    width: MediaQuery.of(context).size.width*0.1-15,
                  ),
                ],),onTap: (){
                  switch (index){
                    case 0:
                      Navigator.pushNamed(context, "listAddress");
                      break;
                    case 4:
                      Navigator.pushNamed(context, "notifications");
                      break;
                    case 5:
                      Navigator.pushNamed(context, "report");
                      break;
                  }
                });
              },
              //分割器构造器
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.grey[300]);
              },
            ))
          ],
        ),
      ),
    );
  }

}