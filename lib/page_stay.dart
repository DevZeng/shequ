import 'package:flutter/material.dart';

class StayPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<StayPage>{
  DateTime intime = DateTime.now();
  DateTime outtime =DateTime.now().add(new Duration(days: 1));
  var stores  = [{"shopId":7,"shopName":"红宝石","shopThumbnail":"http://hongyuan-1258763596.cos.ap-guangzhou.myqcloud.com/hy/2019/156472680101642.png","shopLog":113.32236,"shopLat":23.18171,"shopScore":4.0,"shopMonthlySales":1,"shopDistance":7999,"shopLowPrice":null}];
  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener((){

//      print(scrollController.offset);
//      print('heigth:${MediaQuery.of(context).size.height},offset:${scrollController.offset}');
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('bottom');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('酒店住宿'),
        elevation: 0,
      ),
      backgroundColor:Colors.grey[100] ,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              Center(child: Column(
                children: <Widget>[Container(
                  width: MediaQuery.of(context).size.width-30,
                  decoration: new BoxDecoration(
//                      color: Colors.grey[100],
                    borderRadius: new BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 80,
                          child: Row(
                            children: <Widget>[
                              GestureDetector(child: Container(
                                child: Text("${intime.month}月${intime.day}日",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                width: MediaQuery.of(context).size.width*0.25,
                              ),onTap: (){
                                showDatePicker(context: context, initialDate: new DateTime.now(),
                                  firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
                                  lastDate: new DateTime.now().add(new Duration(days: 30)),  ).then((val){
                                  if(val!=null){
                                    intime = val;
                                  }
                                  setState(() {
                                  });
                                });
                              },),
                              Container(padding: EdgeInsets.fromLTRB(0, 0, 16, 0),child: Text('——',style: TextStyle(color: Colors.grey[400]),),

                                width: MediaQuery.of(context).size.width*0.15,),
                              GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.25,
                                  child: Text("${outtime.month}月${outtime.day}日",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                                  ),
                                ),
                                onTap: (){
                                  showDatePicker(context: context, initialDate: new DateTime.now(),
                                    firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
                                    lastDate: new DateTime.now().add(new Duration(days: 30)),  ).then((val){
                                      if(val!=null){
                                        outtime = val;
                                      }
                                    setState(() {
                                    });
                                  });
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.2,
//                                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text("共${outtime.difference(intime).inDays}晚"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
                          decoration: new BoxDecoration(
//                      color: Colors.grey[100],
                            borderRadius: new BorderRadius.all(Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding: new EdgeInsets.only(left: 0.0),
                                border: InputBorder.none,
                                icon: Icon(Icons.search),
                                hintText: "搜索酒店名称",
                                hintStyle: new TextStyle(fontSize: 14, color: Colors.grey)),
                            style: new TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 40.0,
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: new RaisedButton(
                            onPressed: null,
                            color: Color.fromRGBO(240, 190, 60, 1),
                            disabledColor: Color.fromRGBO(240, 190, 60, 1),
                            child: new Text("搜索酒店",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            shape: new StadiumBorder(
                                side: new BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color.fromRGBO(240, 190, 60, 1),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                Container(
//                color: Colors.white,
                  width: MediaQuery.of(context).size.width-30,
                  child: Wrap(
                    spacing: 8.0, // 主轴(水平)方向间距
                    runSpacing: 8.0, // 纵轴（垂直）方向间距
                    alignment: WrapAlignment.start, //沿主轴方向居中
                    children: stores.map((store){
                      return Container(
                        decoration: new BoxDecoration(
//                      color: Colors.grey[100],
                          borderRadius: new BorderRadius.all(Radius.circular(8)),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width*0.5-19,
                        height: MediaQuery.of(context).size.width*0.75-19,
child: Column(
  children: <Widget>[
    Container(
      height: MediaQuery.of(context).size.width*0.5-19,
      decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(store['shopThumbnail']),fit: BoxFit.cover),color: Colors.blue),
    ),
    Container(child: Text(store['shopName'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),alignment: Alignment.centerLeft,padding: EdgeInsets.fromLTRB(15,5, 0, 0),),
    Container(child: Text(store['shopName'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),alignment: Alignment.centerLeft,padding: EdgeInsets.fromLTRB(15,5, 0, 0),),
    Container(child: Text(store['shopName'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),alignment: Alignment.centerLeft,padding: EdgeInsets.fromLTRB(15,5, 0, 0),),
  ],
),
//                      color: Colors.blue,
                      );
                    }).toList(),
                  ),
                )
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}