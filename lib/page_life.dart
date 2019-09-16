import 'package:flutter/material.dart';
//import 'package:amap_location/amap_location.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model.dart';

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
  var loc ;

  Page() {
    getR();

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

  void getShop(lat ,lon) {
    String url = api.getTypeHShopMsg+ '?shopType=2&start=1&lenght=10';
    if(lat!=0&&lat!=null){
      url+="&lat=${lat}&log=${lon}";
    }
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
//        print(content['data']);
        setState(() {
          shops = content['data'];
        });
      }
    });
  }

//  AMapLocation _loc;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    if(args!=null){
      loc = args;
    }
    if(shops.length==0){
      getShop(loc['lat'],loc['lon']);
    }
//    getShop();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('便利生活'),
        centerTitle: true,
        elevation: 0,
      ),
      body: new Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                            return GestureDetector(
                              child: Container(
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                  child: Image.network(
                                    url['rotationPicture'],
                                    fit: BoxFit.cover,
                                    width: 1000.0,
                                  ),
                                ),
                              ),
                              onTap: (){
                                if(url['rotationLink']!=null&&url['rotationLink'].length!=0){
                                  Navigator.of(context).pushNamed("lifeStore", arguments: int.parse(url['rotationLink']));
                                }
                              },
                            );
                          },
                        ).toList(),
                        autoPlay: true,
                      ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              Wrap(
                spacing: 8.0, // 主轴(水平)方向间距
                runSpacing: 8.0, // 纵轴（垂直）方向间距
                alignment: WrapAlignment.start, //沿主轴方向居中
                children:  shops.map((shop) {
                        return GestureDetector(
                          child: Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width * 1 / 3 -12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  //添加边框
                                  width: 1, //边框宽度
                                  color: Colors.grey[200], //边框颜色
                                )),
//                color: Colors.grey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                                color: Color.fromRGBO(243, 200, 70, 1)
                                            ),
                                            Text(
                                              shop['shopDistance'] == null
                                                  ? ' 未知'
                                                  : getDistance(shop['shopDistance']),
                                              style: TextStyle(fontSize: 11,color: Colors.grey),
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
