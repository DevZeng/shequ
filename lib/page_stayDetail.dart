import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api.dart';
import 'model.dart';
import 'package:dio/dio.dart';

class StayDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<StayDetail> {
  List<String> images = [];
  Api api = new Api();
  var parms = null;
  var info = null;
  List<String> remarks = [];
  int member = 0;
  int total = 0;
  var attrs = [];
  var rooms = [
  ];
  DateTime intime ;
  DateTime outtime ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMember().then((val){
      setState(() {
        member = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if(parms==null){
      parms = ModalRoute.of(context).settings.arguments;
      intime = parms['indate'];
      outtime =parms['outdate'];
      getDetail(parms['id']);
      getRooms(parms['id']);
//      print(parms);
    }

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('酒店详情'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: images.length == 0
                  ? null
                  : CarouselSlider(
                      viewportFraction: 1.0,
                      aspectRatio: 2.0,
                      height: MediaQuery.of(context).size.height * 0.2,
                      items: images.map(
                        (url) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 15.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: 1000.0,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      autoPlay: true,
                    ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                info == null ? '' : info['shopName'],
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      info == null ? '' : '${info['score']}分',
                      style: TextStyle(color: Colors.red),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  GestureDetector(child: Container(
                    child: Text(info == null ? '' : '${info['commentSum']}条点评',style: TextStyle(color: Colors.red),),
                  ),
                  onTap: (){
                    Navigator.of(context).pushNamed('comments',arguments: info['shopId']);
                  },),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: ListView(
//                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: remarks.map((remark) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Row(
                            children: <Widget>[
                              ImageIcon(
                                AssetImage('images/yes.png'),
                                size: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(remark),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
//                        alignment: Alignment.centerRight,
//                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Icon(
                          Icons.phone,
                          size: 14,
                        ),
                      ),
                      Container(
//                        width: MediaQuery.of(context).size.width * 0.3,
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: Text(
                          info == null ? '' : info['shopPhone'],
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              height: 40,
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(info == null ? '' : info['shopAddress']),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              height: 40,
              color: Colors.white,
//              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: ListView(
//                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: attrs.map((attr) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GestureDetector(child: Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      color: Colors.grey[200],
                      child: Text(attr['attributeName']),
                    ),
                    onTap: (){
                      Dio().get(api.getAttribute+"?hotleShopId=${info['shopId']}&key=${attr['attributeName']}").then((response){
                        if(response.statusCode==200){
                          var data = response.data;
                          if(data['code']==200){
                            setState(() {
                              rooms = data['data'];
                            });
                          }
                        }
                      });
                    },)
                  );
                }).toList(),
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Column(
              children: rooms.map((room){
                return Column(children: <Widget>[GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    height: 102,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
//                                  color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        room['hotleThumbnail'].split(',')[0]),
                                    fit: BoxFit.cover)),
                          ),
                          onTap: (){
                            print(room['hotleThumbnail'].split(',')[0]);
                            Navigator.of(context).pushNamed('stayImage',arguments:room['hotleThumbnail'].split(',') );
                          },
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
//                              color: Colors.blue,
                          child: Column(
                            children: <Widget>[
                              Container(
//                                    color: Colors.amber,
                                child: Row(
                                  children: <Widget>[
                                    Container(child: Text(
                                      room['hotleName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),width: MediaQuery.of(context).size.width *0.8 - 165,),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '¥ ${member==1?room['hotleMemberPrice']:room['hotlePrice']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,color: Colors.red),
                                      ),
                                      width: MediaQuery.of(context).size.width *0.2,
                                    )
                                  ],
                                ),
                                width:
                                MediaQuery.of(context).size.width - 150,
                                padding: EdgeInsets.fromLTRB(15, 5, 0, 5),

                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(15,0, 2, 0),
                                width:
                                MediaQuery.of(context).size.width - 150,
                                child: Text(room['hotleAttribute']),
                                height: 30,
                              ),
                              Container(child: Row(
                                children: <Widget>[Container(
                                  alignment: Alignment(-1, 1),
                                  width:
                                  40,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '有房',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.yellow, width: 1)),
//                                      height: 20,
//                                      width: 60,
                                  ),
                                )],
                              ),width: MediaQuery.of(context).size.width - 150,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
//                        print(rooms[0]);
                    Navigator.of(context).pushNamed('stayOrder',arguments: {
                      'id':info['shopId'],
                      'roomid':room['hotleId'],
                      'name':room['hotleName'],
                      'indate':parms['indate'],
                      'outdate':parms['outdate'],
                      'livenum':room['hotleNum'],
                      'exist':room['ifExistRoom']==null?1:room['ifExistRoom'],
                      'price':room['hotlePrice'],
                      'memberPrice':room['hotleMemberPrice']
                    });
                  },
                ),Divider(height: 1,)],);
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
  getDetail(id)
  {
    Dio().get(api.getOneShopHotel+'?shopId=${id}').then((response){
      if(response.statusCode==200){
        var data = response.data;
        print(data);
        if(data['code']==200){
          setState(() {
            info = data['data'];
            attrs = data['data']['listHoteAttribute'];
            remarks = data['data']['shopRemarks'].split(',');
            images = data['data']['shopRotation'].split(',');
          });
        }
      }
    });
  }
  getRoomsByAttr(id){
    Dio().get(api.getAttribute+"?hotleShopId=${id}").then((response){
      if(response.statusCode==200){
        var data = response.data;
        print(data);
        if(data['code']==200){
          setState(() {
            rooms = data['data'];
          });
        }
      }
    });
  }
  getRooms(id){
    Dio().get(api.getQianHShopHShopHotel+"?hotleShopId=${id}&hotelOrderInTime=${intime.year}-${intime.month}-${intime.day}&hotelOrderOutTime=${outtime.year}-${outtime.month}-${outtime.day}").then((response){
      if(response.statusCode==200){
        var data = response.data;
        print(data);
        if(data['code']==200){
          setState(() {
            rooms = data['data'];
          });
        }
      }
    });
  }
}
