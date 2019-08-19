import 'package:flutter/material.dart';

class VisitorDetailPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _visitorDetailPage();
  }
}

class _visitorDetailPage extends State<VisitorDetailPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('访客详情'),
        elevation: 0,
      ),
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Divider(height: 1,),
          Container(
            height: MediaQuery.of(context).size.height*0.05,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('名字'),
                  width: MediaQuery.of(context).size.width*0.3-15,
                ),
                Text('xxx,xxx,xxx',style: TextStyle(color: Colors.grey[700]),)
              ],
            ),
          ),
          Divider(height: 1,),
          Container(
            height: MediaQuery.of(context).size.height*0.05,

            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('联系电话'),
                  width: MediaQuery.of(context).size.width*0.3-15,
                ),

                Text('1866494515',style: TextStyle(color: Colors.grey[700]),)
              ],
            ),
          ),
          Divider(height: 1,),
          Container(
            height: MediaQuery.of(context).size.height*0.15,

            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('理由（选填）'),
                  width: MediaQuery.of(context).size.width*0.3-15,
                ),

                Text('xxx,xxx,xxx',style: TextStyle(color: Colors.grey[700]),)
              ],
            ),
          ),
          Divider(height: 1,),

          Container(
            height: MediaQuery.of(context).size.height*0.4,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  height: 40.0  ,
                  child: new RaisedButton(onPressed: (){
                    Navigator.of(context).pushNamed('addHouseInfo');
//          print(detailController.text);
                  },color: Colors.orange,
                    child: new Text("保存地址",style: TextStyle(color: Colors.white,)),
                    shape: new StadiumBorder(side: new BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xffFF7F24),
                    )),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.02, 0, 0),
//                  height: 40.0  ,
                  child: new RaisedButton(onPressed: (){
                    Navigator.of(context).pushNamed('addHouseInfo');
//          print(detailController.text);
                  },color: Colors.orange,
                    child: new Text("保存地址",style: TextStyle(color: Colors.white,)),
                    shape: new StadiumBorder(side: new BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xffFF7F24),
                    )),
                  ),
                )
              ],
            ),
          )
        ],
      ),),
    );
  }
}
