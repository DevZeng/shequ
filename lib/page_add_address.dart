import 'package:flutter/material.dart';

class addAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('新增地址'),elevation:0,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Container(child: Text('收货人',style: TextStyle(fontSize: 17),),padding: EdgeInsets.fromLTRB(15, 0, 15, 0),width: MediaQuery.of(context).size.width*0.3),
                Expanded(child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: "请输入收货人姓名",
                    border: InputBorder.none
                  ),
                ))
              ],
            ),
          ),
        Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.all(1.0),
              child: new Divider()
          ),
        ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Container(child: Text('手机号',style: TextStyle(fontSize: 17),),padding: EdgeInsets.fromLTRB(15, 0, 15, 0),width: MediaQuery.of(context).size.width*0.3),
                Expanded(child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "请输入收货手机号",
                      border: InputBorder.none
                  ),
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(1.0),
                child: new Divider()
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Container(child: Text('所在地区',style: TextStyle(fontSize: 17),),padding: EdgeInsets.fromLTRB(15, 0, 15, 0),width: MediaQuery.of(context).size.width*0.3,),
                Expanded(child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "请输入收货人姓名",
                      border: InputBorder.none
                  ),
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(1.0),
                child: new Divider()
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              child: TextField(minLines: 3,maxLines: 5,decoration: InputDecoration(
                  hintText: "请补充详细收货地址，如街道、门牌号、楼层及房间号等。",
                  border: InputBorder.none
              ),),
              padding: EdgeInsets.fromLTRB(20, 0, 20 ,0),
            )
          ),
        ],
      ),
      floatingActionButton: new Container(
      width: MediaQuery.of(context).size.width*0.7,
      height: 40.0  ,
      child: new RaisedButton(onPressed: (){

      },color: Colors.orange,
        child: new Text("保存地址",style: TextStyle(color: Colors.white,)),
        shape: new StadiumBorder(side: new BorderSide(
          style: BorderStyle.solid,
          color: Color(0xffFF7F24),
        )),
      ),
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}