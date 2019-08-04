import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  var shops = [];

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

              ),
            )
          ],
        ),
      )
    );
  }
}