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
  int sort = 0;
  var shops = [
  ];

  Page() {
    getR();
    getShop();
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
                  FlatButton(onPressed: (){
                    setState(() {
                      sort = 0;
                    });
                  }, child: Text('综合排序',style: TextStyle(color: sort==0?Colors.yellow:Colors.black),)),
                  FlatButton(onPressed: (){
                    setState(() {
                      sort = 1;
                    });
                  }, child: Text('销量',style: TextStyle(color: sort==1?Colors.yellow:Colors.black),))
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
                itemCount: shops.length,
                itemBuilder: (context,index){
                  return GestureDetector(child: Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    height: 105,
                    child: Row(
                      children: <Widget>[
                        Container(
//                          color: Colors.green,
                          width: 80,
                          child: Image.network(shops[index]['shopThumbnail']),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width-110,
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(shops[index]['shopName'],style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                height: 30,
//                                color: Colors.red,
                                width: MediaQuery.of(context).size.width-110,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: Icon(Icons.star,size: 15,),
                                    ),
                                    Text(double.parse(shops[index]['shopScore'].toString()).toStringAsFixed(1),style: TextStyle(fontSize: 14)),
                                    Text('  月售${shops[index]['shopMonthlySales']}',style: TextStyle(fontSize: 14),),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 7, 0, 0),
                                height: 25,
                                width: MediaQuery.of(context).size.width-110,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width-200,
//                                      height: 10,
                                      child: Text('起送￥${shops[index]['shopStartFee']} 配送￥${shops[index]['shopDeliveryFee']}'),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 80,
                                      child: Text('2km'),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),onTap: (){
                    Navigator.of(context).pushNamed('outsellerDetail',arguments: shops[index]['shopId']);
                  },);
                })
          ],
        ),
      )
    );
  }
  void getShop() {
    Dio().request(api.getTypeHShopMsg + '?shopType=1').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
//        print(content['data']);
        setState(() {
          shops = content['data'];
        });
      }
    });
  }
}