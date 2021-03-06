import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'model.dart';

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
  var shops = [];
  var loc ;
  int page =1;
  bool loading = true;
  ScrollController scrollController = new ScrollController();

  Page() {
    getR();
    scrollController.addListener(() {
//      print(scrollController.offset);
//      print('heigth:${MediaQuery.of(context).size.height},offset:${scrollController.offset}');
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          loading = true;
        });
        _retrieveData();
      }
    });
  }
  void _retrieveData() {
    Future.delayed(Duration(seconds: 1)).then((e) {
      addShop(loc['lat'],loc['lon'],page+1);
      setState(() {
        page = page+1;
        loading = false;
        //重新构建列表
      });
    });
  }

  void getR() {
    Dio().request(api.getHRotation + '?rotationType=2').then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content['data']);
        setState(() {
          _imageUrls = content['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    if(args!=null){
      print(loc);
      loc = args;
    }
//    print(shops);
    if(shops.length==0){
      getShop(loc==null?0:loc['lat'],loc==null?0:loc['lon']);
    }
    return Scaffold(
      appBar: AppBar(title: Text('美食外卖'),elevation: 0,
        centerTitle: true,),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: ScrollController(

        ),
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
                      ),
                      onTap: (){
                        if(url['rotationType']==2&&url['rotationLink']!=null){
                          Navigator.of(context).pushNamed('outsellerDetail',arguments: int.parse(url['rotationLink']));
                        }
                      },
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
                      loading = true;
                    });
                    getShop(loc==null?0:loc['lat'],loc==null?0:loc['lon']);
                  }, child: Text('综合排序',style: TextStyle(color: sort==0?Color.fromRGBO(243, 200, 70, 1):Colors.black),)),
                  FlatButton(onPressed: (){
                    setState(() {
                      sort = 1;
                      loading = true;
                    });
                    getShop(loc==null?0:loc['lat'],loc==null?0:loc['lon']);
                  }, child: Text('销量',style: TextStyle(color: sort==1?Color.fromRGBO(243, 200, 70, 1):Colors.black),))
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
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
                          decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(shops[index]['shopThumbnail'])),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
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
                                      child: Text(shops[index]['shopDistance']==null?'未知':getDistance(shops[index]['shopDistance']),style: TextStyle(color: Colors.grey),),
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
                }),
            loading==true?Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0)
              ),
            ):Container()
          ],
        ),
      )
    );
  }
  void getShop(lat , lon) {
    String url = api.getTypeHShopMsg+ '?shopType=1&start=1&lenght=10&sales=$sort';
    if(lat!=0&&lat!=null){
      url+="&lat=${lat}&log=${lon}";
    }
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content['data']);
        setState(() {
          shops = content['data'];
          loading = false;
        });
      }
    });
  }
  void addShop(lat , lon,page) {
    String url = api.getTypeHShopMsg+ '?shopType=1&start=$page&lenght=10';
    if(lat!=0&&lat!=null){
      url+="&lat=${lat}&log=${lon}";
    }
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content['data']);
        setState(() {
          shops.addAll(content['data']);
        });
      }
    });
  }
}