import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

class OutSellerPage extends StatefulWidget {
  @override
  Page createState() => Page();
}

class Page extends State<OutSellerPage> {
  Api api = new Api();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  var _imageUrls = [];
  var shops = [
    {
      "shopId": 5,
      "shopName": "美团外卖",
      "shopThumbnail": "http://hongyuan-1258763596.cos.ap-guangzhou.myqcloud.com/hy/2019/156463976334501.jpg",
      "shopLog": 113.363233,
      "shopLat": 22.933466,
      "shopDeliveryFee": 2,
      "shopStartFee": 10,
      "shopScore": 4.3333335,
      "shopMonthlySales": 0,
      "shopDistance": null
    }
  ];

  Page() {
    getR();
  }

  void getR() {
    Dio().request(api.getHRotation + '?rotationType=2').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
//        print(content['data']);
        setState(() {
          _imageUrls = content['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('美食外卖'),elevation: 0,),
      backgroundColor: Colors.white,
      body: Container(
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
            Container(
              child:Row(
                children: <Widget>[
                  FlatButton(onPressed: (){}, child: Text('综合排序')),
                  FlatButton(onPressed: (){}, child: Text('销量'))
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
                itemCount: shops.length,
                itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    height: 100,
//                    color: Colors.red,
                    child: Row(
                      children: <Widget>[
                        Container(
                          color: Colors.green,
                          width: 80,
                          child: Image.network(shops[index]['shopThumbnail']),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.yellow,

                                width: MediaQuery.of(context).size.width-110,
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(shops[index]['shopName'],style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                              ),
                              Container(
//                                color: Colors.red,
                                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                height: 35,
                                width: MediaQuery.of(context).size.width-110,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: ImageIcon(AssetImage('images/star.png')),
                                    ),
                                    Text(double.parse(shops[index]['shopScore'].toString()).toStringAsFixed(1)),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.red,
//                                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
//                                height: 35,
                                width: MediaQuery.of(context).size.width-110,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: ImageIcon(AssetImage('images/star.png')),
                                    ),
                                    Text(double.parse(shops[index]['shopScore'].toString()).toStringAsFixed(1)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      )
    );
  }
}