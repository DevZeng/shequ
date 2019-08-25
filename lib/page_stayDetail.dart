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
  var attrs = [];
  var rooms = [
  ];


  @override
  Widget build(BuildContext context) {

    if(parms==null){
      parms = ModalRoute.of(context).settings.arguments;
      getDetail(parms['id']);
      getRooms(parms['id']);
//      print(parms);
    }

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('酒店详情'),
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
                      style: TextStyle(color: Colors.yellow),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  GestureDetector(child: Container(
                    child: Text(info == null ? '' : '${info['commentSum']}条点评'),
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
                  Container(

                    alignment: Alignment.bottomRight,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: Icon(
                            Icons.phone,
                            size: 14,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Text(
                            info == null ? '' : info['shopPhone'],
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(info == null ? '' : info['shopAddress']),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              height: 60,
              color: Colors.white,
//              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: ListView(
//                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: attrs.map((attr) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      color: Colors.grey[200],
                      child: Text(attr['attributeName']),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return Column(children: <Widget>[GestureDetector(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        height: 100,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
//                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          rooms[index]['hotleThumbnail']),
                                      fit: BoxFit.cover)),
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
                                          rooms[index]['hotleName'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),width: MediaQuery.of(context).size.width *0.8 - 165,),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '¥ ${rooms[index]['hotlePrice']}',
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
                                    child: Text(rooms[index]['hotleAttribute']),
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
                          'roomid':rooms[index]['hotleId'],
                          'name':rooms[index]['hotleName'],
                          'indate':parms['indate'],
                          'outdate':parms['outdate'],
                          'livenum':rooms[index]['hotleNum'],
                          'exist':rooms[index]['ifExistRoom']==null?1:rooms[index]['ifExistRoom'],
                          'price':rooms[index]['hotlePrice']
                        });
                      },
                    ),Divider(height: 1,)],);
                  }),
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
  getRooms(id){
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
}