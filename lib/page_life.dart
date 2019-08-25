import 'package:flutter/material.dart';
//import 'package:amap_location/amap_location.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LifePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Page();
  }
}

class Page extends State<LifePage> {
  Api api = new Api();
  var _imageUrls = [];
  var shops = [];

  Page() {
    getR();
    getShop();
  }

  void getR() {
    Dio().request(api.getHRotation + '?rotationType=3').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
//        print(content['data']);
        setState(() {
          _imageUrls = content['data'];
        });
      }
    });
  }

  void getShop() {
    Dio().request(api.getTypeHShopMsg + '?shopType=2').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        setState(() {
          shops = content['data'];
        });
      }
    });
  }

//  AMapLocation _loc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('便利生活'),
        elevation: 0,
      ),
      body: new Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: <Widget>[
              Container(
                child: _imageUrls.length == 0
                    ? null
                    : CarouselSlider(
                        viewportFraction: 1.0,
                        aspectRatio: 2.0,
                        height: MediaQuery.of(context).size.height * 0.25,
                        items: _imageUrls.map(
                          (url) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Image.network(
                                  url['rotationPicture'],
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
              Wrap(
                spacing: 8.0, // 主轴(水平)方向间距
                runSpacing: 4.0, // 纵轴（垂直）方向间距
                alignment: WrapAlignment.start, //沿主轴方向居中
                children:  shops.map((shop) {
                        return GestureDetector(
                          child: Container(
                            height: 160,
                            width: MediaQuery.of(context).size.width * 1 / 3 - 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  //添加边框
                                  width: 1, //边框宽度
                                  color: Colors.grey[100], //边框颜色
                                )),
//                color: Colors.grey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                          NetworkImage(shop['shopThumbnail']),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            1 /
                                            3 -
                                            10,
                                        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                        child: Text(
                                          shop['shopName'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                        child: Row(
                                          children: <Widget>[
                                            ImageIcon(
                                              AssetImage('images/location.png'),
                                              size: 10,
                                            ),
                                            Text(
                                              shop['shopDistance'] == null
                                                  ? ' 未知'
                                                  : ' ' + shop['shopDistance'],
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.of(context).pushNamed("lifeStore", arguments: shop['shopId']);
                          },
                        );
                      }).toList(),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(onPressed: () {
//       print(AM)
        print(shops);
//        print(_loc.formattedAddress);
      }),
    );
  }

  getLocation() async {}

//  void _checkPersmission() async {
//    AMapLocation loc = await AMapLocationClient.getLocation(true);
////    print(loc.description);
//    setState(() {
//      _loc = loc;
//    });
//  }
}
