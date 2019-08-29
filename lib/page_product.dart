import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';

class ProductPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _productPage();
  }
}

class _productPage extends State<ProductPage>{
  List<String> _imageUrls = [];
  var product = null;
  var info = null;
  Api api = new Api();
  @override
  Widget build(BuildContext context) {
    if(info==null){
      print('aa');
      info = ModalRoute.of(context).settings.arguments;
      getProduct(info['productId']);
    }
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){print(_imageUrls);}),
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('商品详情'),centerTitle: true,elevation: 0,),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: _imageUrls.length == 0
                  ? null
                  : CarouselSlider(
                viewportFraction: 1.0,
                aspectRatio: 2.0,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.25,
                items: _imageUrls.map(
                      (url) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(2.0)),
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
              child: Padding(padding: EdgeInsets.fromLTRB(15,10, 15, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(product==null?'':product['storeName'],style: TextStyle(fontSize: 25),),
                ),),
            ),
            Container(
              child: Padding(padding: EdgeInsets.fromLTRB(15,10, 15, 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Text('¥',style: TextStyle(fontSize: 16,color: Colors.red),),
                      Text('${product==null?'':product['storePrice']}',style: TextStyle(fontSize: 24,color: Colors.red),),
                      Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
                      Text('会员价¥',style: TextStyle(fontSize: 16,color: Colors.orange),),
                      Text('${product==null?'':product['storeMemberPrice']}',style: TextStyle(fontSize: 24,color: Colors.orange),),
                    ],
                  ),
                ),),
              color: Colors.white,
            ),
            Container(height: 5,color: Colors.grey[100],),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                    width: MediaQuery.of(context).size.width,
                    child: Text('产品详情'),
                  ),
                  Container(
//                    padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                    width: MediaQuery.of(context).size.width,
                    child: Html(data: product==null||product['storeDetails']==null?'':product['storeDetails']),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.orange,
        child: FlatButton(onPressed: (){
          Navigator.of(context).pushNamed('countPage',arguments: new Store(info['storeId'], info['storeName'], info['storeIcon'], [Product(product['storeId'], product['storeName'], product['storePrice'], product['storeMemberPrice'], 1, product['storeThumbnail'])],product['storePrice'],2,info['send'],info['start'],info['sendPrice']));
        },child: Text('立即购买',style: TextStyle(fontSize: 20,color: Colors.white),),),
      ),
    );
  }
  getProduct(id) {
    Dio().get(api.getOneStore+'?storeId=${id}').then((response){
      if(response.statusCode==200){
        var data = response.data;
        print(data);
        if(data['code']==200){
          setState(() {
            product = data['data'];
            _imageUrls = data['data']['storeRotation'].split(',');
          });
        }
      }
    });
  }
}