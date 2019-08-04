import 'package:flutter/material.dart';


class listAddressPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<listAddressPage> {
  int radio = 1;
  final addresses = [
    {
      'id':1,
      'name':'zengshungeng',
      'phone':'123123123',
      'address':'xxxxxxx',
      'default':0
    },
    {
      'id':2,
      'name':'devzeng',
      'phone':'231123',
      'address':'qqqqqqq',
      'default':1
    }
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('我的地址'),elevation:0,),
      body: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
          Container(
            color: Colors.white,
//            height: MediaQuery.of(context).size.height*0.2,
//            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Container(child: Row(
                  children: <Widget>[
                    Container(child: Text('xxxxxx',style: TextStyle(fontSize: 20),),width: MediaQuery.of(context).size.width*0.2,),
                    Container(child: Text('123****9999',style: TextStyle(fontSize: 20),),width: MediaQuery.of(context).size.width*0.8-50,)
                  ],
                ),padding: EdgeInsets.fromLTRB(15, 0, 15, 0),),
                Container(child: Text('xxxxxxdddsfadsafasdfsfsdxxxxxxxxxxxxxxxxxxxxxxx',style: TextStyle(fontSize: 20,color: Colors.grey),),padding: EdgeInsets.fromLTRB(15, 0, 15, 0),),
                Container(
                  color: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: new Divider()
                  ),
                ),
                Container(
                  child:Row(
                    children: <Widget>[
                      Container(child: Row(
                        children: <Widget>[
                          ImageIcon(AssetImage('images/selected.png'),color: Colors.yellow,size: 16,),
                          Text('设为默认'),
                        ],
                      ),width: MediaQuery.of(context).size.width*0.55,
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),),
                      FlatButton(onPressed: null, child: Row(children: <Widget>[Icon(Icons.edit),Text('编辑')],),),
                      FlatButton(onPressed: null, child: Row(children: <Widget>[Icon(Icons.delete),Text('删除')],),),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: new Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 40.0  ,
        child: new RaisedButton(onPressed: (){

        },color: Colors.orange,
          child: new Text("新增地址",style: TextStyle(color: Colors.white,)),
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