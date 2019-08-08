import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LifeStorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Product {
  int id;
  String name;
  double price;
  int number;

  Product(int id, String name, double price, int number) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.number = number;
  }
}

class Page extends State<LifeStorePage> {
  Api api = new Api();
  var info = null;
  var products = null;
  int id = 0;
  List<String> images = [];
  List<Product> buys = [];

  Page() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      print(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments;
    getProducts(1);
    getR();
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('商店详情'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
//            height: MediaQuery.of(context).size.height * 0.35,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    child: images.length == 0
                        ? null
                        : CarouselSlider(
                            viewportFraction: 1.0,
                            aspectRatio: 2.0,
                            height: MediaQuery.of(context).size.height * 0.25,
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
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(info == null ? '' : info['shopName'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          width: MediaQuery.of(context).size.width - 30,
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '地址',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                              Text(
                                info == null ? '' : info['shopAddress'],
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '电话',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                              Text(
                                info == null ? '' : info['shopPhone'],
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '电话',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                              Text(
                                info == null ? '' : info['shopPhone'],
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 12, 0, 0)),
            ListView.separated(
              shrinkWrap: true,
              itemCount: products.length,
              //列表项构造器
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 110,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  products[index]['storeThumbnail']),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                products[index]['storeName'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              height: 40,
                              width: MediaQuery.of(context).size.width - 140,
//                             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              height: 40,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 190,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          '¥' +
                                              products[index]
                                                      ['storeMemberPrice']
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Colors.red),
                                        ),
                                        Container(
                                          child: Text(
                                            products[index]['storePrice']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      icon: ImageIcon(
                                          AssetImage('images/cart.png')),
                                      onPressed: () {
                                        Product buy = new Product(
                                            products[index]['storeId'],
                                            products[index]['storeName'],
                                            products[index]['storeMemberPrice'],
                                            1);
                                        addBuy(buy);
                                        showCart(context);
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              //分割器构造器
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey[100],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        test();
      }),
    );
  }

  void getR() {
    if (info == null) {
      Dio().request(api.getOneShopMsg + '?shopId=$id').then((response) {
        if (response.statusCode == 200) {
          var content = response.data;
//          print(content['data']['shopRotation']);
          setState(() {
            info = content['data'];
            images = content['data']['shopRotation'].split(',');
          });
        }
      });
    }
  }

  void getProducts(int page) {
    if (products == null) {
      Dio()
          .request(api.products + '?storeShopId=$id&start=$page')
          .then((response) {
        if (response.statusCode == 200) {
          var content = response.data;
          print(content['data']);
          setState(() {
            products = content['data'];
          });
        }
      });
    }
  }

  void addBuy(Product product) {
    bool flag = true;
    for (int i = 0; i < buys.length; i++) {
      if (buys[i].id == product.id) {
        buys[i].number += 1;
        flag = false;
      }
    }
    if (flag) {
      buys.add(product);
    }
  }

  void showCart(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new StatefulBuilder(builder: (context1, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
//                width:130,
                  color: Colors.white,
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    width: 130,
                    child: RaisedButton(
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[Icon(Icons.delete), Text('清空回收站')],
                      ),
                      elevation: 0,
                    ),
                  ),
//                color: Colors.black,
                ),
                Divider(
                  color: Colors.grey[100],
                  height: 1,
                ),
                ListView.builder(
                    itemCount: buys.length,
                    shrinkWrap: true,
                    itemBuilder: ((BuildContext context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5 -
                                          15,
                                  child: Text(buys[index].name),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child:
                                      Text('¥' + buys[index].price.toString()),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                buys[index].number += 1;
                                              });
//                                        setCart(buys[index], index);
                                            }),
                                      ),
                                      Text(buys[index].number.toString()),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              setState(() {
                                                buys[index].number -= 1;
                                              });
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey[100],
                          )
                        ],
                      );
                    })),
              ],
            );
          });
        });
  }

  List<Widget> getCartList(BuildContext context, List<Product> buys) {
    List<Widget> widgets = [
      Container(
        height: 40,
//                width:130,
        color: Colors.white,
        alignment: Alignment.centerRight,
        width: MediaQuery.of(context).size.width,
        child: Container(
          width: 130,
          child: RaisedButton(
            onPressed: () {},
            child: Row(
              children: <Widget>[Icon(Icons.delete), Text('清空回收站')],
            ),
            elevation: 0,
          ),
        ),
//                color: Colors.black,
      ),
      Divider(
        color: Colors.grey[100],
        height: 1,
      ),
    ];

    List<Widget> buysList = buys.map((product) {
      return Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 15,
                  child: Text(product.name),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Text('¥' + product.price.toString()),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              product.number += 1;
//                        setCart(product, index);
                            }),
                      ),
                      Text(product.number.toString()),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              product.number -= 1;
                            });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[100],
          )
        ],
      );
    }).toList();
    widgets.addAll(buysList);
//    Widget cart = ;
//    widgets.add(cart);
    return widgets;
  }

  void setCart(Product product, int index) {
    setState(() {
      buys[index] = product;
    });
  }

  void test() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context1, state) {
            ///这里的state就是setState
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
//                width:130,
                    color: Colors.white,
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      width: 130,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[Icon(Icons.delete), Text('清空回收站')],
                        ),
                        elevation: 0,
                      ),
                    ),
//                color: Colors.black,
                  ),
                  Divider(
                    color: Colors.grey[100],
                    height: 1,
                  ),
                  ListView.builder(
                      itemCount: buys.length,
                      shrinkWrap: true,
                      itemBuilder: ((BuildContext context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width * 0.5 -
                                        15,
                                    child: Text(buys[index].name),
                                  ),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width * 0.2,
                                    child:
                                    Text('¥' + buys[index].price.toString()),
                                  ),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width * 0.3,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                state(() {
                                                  buys[index].number += 1;
                                                });
//                                        setCart(buys[index], index);
                                              }),
                                        ),
                                        Text(buys[index].number.toString()),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              setState(() {
                                                state(() {
                                                  buys[index].number -= 1;
                                                });
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey[100],
                            )
                          ],
                        );
                      })),
                  Container(
                    color: Colors.white,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: <Widget>[
                        Container(
                            height: 60,
                            alignment: Alignment.bottomCenter,
                            child: Row(children: <Widget>[
                              Container(
//                      color: Colors.white,
                                child: Stack(
                                  alignment: new Alignment(-0.6, 1),
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.65,
                                      color: Colors.grey[900],
                                      child: FlatButton(
                                          onPressed: () {},
                                          child: Text(
                                            '去结算',
                                            style: TextStyle(color: Colors.white),
                                          )),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage('images/cart2.png'),
                                        radius: 100.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ])),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Stack(
                            alignment: new Alignment(-0.6, 1),
                            children: <Widget>[
                              Container(
//                height: 50,
                                width: MediaQuery.of(context).size.width * 0.35,
                                color: Colors.yellow,
                                child: FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    '去结算',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 60,
                                child: null,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        });
  }
}
