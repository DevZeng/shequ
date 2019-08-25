import 'package:flutter/material.dart';
import 'model.dart';
import 'package:dio/dio.dart';
import 'api.dart';

class OutSellerOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _outSellerOrderPage();
  }
}

class _outSellerOrderPage extends State<OutSellerOrderPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller
  List tabs = [
    "未支付",
    "已支付",
    "配送中",
    "已完成",
  ];
  String token = '';
  List<Store> unPayOrders = [];
  List<Store> payOrders = [];
  List<Store> waitPayOrders = [];
  List<Store> finishPayOrders = [];
  Api api = new Api();

  @override
  void initState() {
    super.initState();
    getUser().then((val) {
      token = val;
      getOrder(0);
    });
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController.addListener(() {
//      print(_tabController.index);
      switch (_tabController.index) {
        case 0:
          getUser().then((val) {
            token = val;
            getOrder(0);
          });
          break;
        case 1:
          getUser().then((val) {
            token = val;
            getOrder(1);
          });
          break;
        case 2:
          getUser().then((val) {
            token = val;
            getOrder(2);
          });
          break;
        case 3:
          getUser().then((val) {
            token = val;
            getOrder(3);
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('外卖订单'),
        elevation: 0,
        bottom: TabBar(
          //生成Tab菜单
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
              itemCount: unPayOrders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Image.network(unPayOrders[index].icon),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 60,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            unPayOrders[index].name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
//                                          width: MediaQuery.of(context)
//                                              .size
//                                              .width *
//                                              0.2,
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[0],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          child: Column(
                            children:
                            unPayOrders[index].products.map((product) {
                              return Container(
//                                color:Colors.red,
//                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.fromLTRB(75, 5, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(product.name),
                                      width: MediaQuery.of(context).size.width *
                                          0.8 -
                                          80,
                                    ),
                                    Container(
                                      child: Text('x ${product.number}'),
                                      alignment: Alignment.bottomRight,
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text(
                              '共${unPayOrders[index].products.length}件商品，实付¥${unPayOrders[index].price}'),
                        ),
                        Container(
//                          decoration: BoxDecoration(
//                             border: new Border.all(width: 1.0 ),
//                          ),
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          child: OutlineButton(
                            onPressed: () {},
                            child: Text('再来一单'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          ListView.builder(
              itemCount: payOrders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Image.network(payOrders[index].icon),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 60,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            payOrders[index].name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[1],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          child: Column(
                            children: payOrders[index].products.map((product) {
                              return Container(
//                                color:Colors.red,
//                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.fromLTRB(75, 5, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(product.name),
                                      width: MediaQuery.of(context).size.width *
                                          0.8 -
                                          80,
                                    ),
                                    Container(
                                      child: Text('x ${product.number}'),
                                      alignment: Alignment.bottomRight,
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text(
                              '共${payOrders[index].products.length}件商品，实付¥${payOrders[index].price}'),
                        ),
                        Container(
//                          decoration: BoxDecoration(
//                             border: new Border.all(width: 1.0 ),
//                          ),
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          child: OutlineButton(
                            onPressed: () {},
                            child: Text('再来一单'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          ListView.builder(
              itemCount: waitPayOrders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Image.network(waitPayOrders[index].icon),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 60,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            waitPayOrders[index].name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.2,
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[2],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          child: Column(
                            children:
                            waitPayOrders[index].products.map((product) {
                              return Container(
//                                color:Colors.red,
//                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.fromLTRB(75, 5, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(product.name),
                                      width: MediaQuery.of(context).size.width *
                                          0.8 -
                                          80,
                                    ),
                                    Container(
                                      child: Text('x ${product.number}'),
                                      alignment: Alignment.bottomRight,
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text(
                              '共${waitPayOrders[index].products.length}件商品，实付¥${waitPayOrders[index].price}'),
                        ),
                        Container(
//                          decoration: BoxDecoration(
//                             border: new Border.all(width: 1.0 ),
//                          ),
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          child: OutlineButton(
                            onPressed: () {},
                            child: Text('再来一单'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          ListView.builder(
              itemCount: finishPayOrders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Image.network(finishPayOrders[index].icon),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 60,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            finishPayOrders[index].name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.2,
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[3],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          child: Column(
                            children:
                            finishPayOrders[index].products.map((product) {
                              return Container(
//                                color:Colors.red,
//                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.fromLTRB(75, 5, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(product.name),
                                      width: MediaQuery.of(context).size.width *
                                          0.8 -
                                          80,
                                    ),
                                    Container(
                                      child: Text('x ${product.number}'),
                                      alignment: Alignment.bottomRight,
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: Text(
                              '共${finishPayOrders[index].products.length}件商品，实付¥${finishPayOrders[index].price}'),
                        ),
                        Container(
//                          decoration: BoxDecoration(
//                             border: new Border.all(width: 1.0 ),
//                          ),
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          child: OutlineButton(
                            onPressed: () {},
                            child: Text('再来一单'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print(unPayOrders[0].products[0].number);
      }),
    );
  }

  getOrder(int type) async {
    print(type);
    List<Store> stores = [];
    Dio()
        .get(api.getUserTakeoutOrder + "?token=$token&&toOrderStatus=$type")
        .then((response) {
      var data = response.data;
      print(data);
      if (data['code'] == 200) {
        switch (type) {
          case 0:
            data['data'].forEach((item) {
              Store store = new Store(
                  item['toOrderShopId'],
                  item['toOrderShopName'],
                  item['toOrderShopThumbnail'],
                  [],
                  item['toOrderTotalPrice'],
                  1,0);
              List<Product> products = [];
              item['listGoods'].forEach((good) {
                products.add(new Product(
                    good['stogTakeoutId'],
                    good['stogTaketoutName'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutNum'],
                    good['stogTakeoutThumbnail']));
              });
              store.products = products;
              stores.add(store);
            });
            unPayOrders = stores;
            break;
          case 1:
            data['data'].forEach((item) {
              Store store = new Store(
                  item['toOrderShopId'],
                  item['toOrderShopName'],
                  item['toOrderShopThumbnail'],
                  [],
                  item['toOrderTotalPrice'],
                  1,0);
              List<Product> products = [];
              item['listGoods'].forEach((good) {
                products.add(new Product(
                    good['stogTakeoutId'],
                    good['stogTaketoutName'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutNum'],
                    good['stogTakeoutThumbnail']));
              });
              store.products = products;
              stores.add(store);
            });
            payOrders = stores;

            break;
          case 2:
            data['data'].forEach((item) {
              Store store = new Store(
                  item['toOrderShopId'],
                  item['toOrderShopName'],
                  item['toOrderShopThumbnail'],
                  [],
                  item['toOrderTotalPrice'],
                  1,0);
              List<Product> products = [];
              item['listGoods'].forEach((good) {
                products.add(new Product(
                    good['stogTakeoutId'],
                    good['stogTaketoutName'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutNum'],
                    good['stogTakeoutThumbnail']));
              });
              store.products = products;
              stores.add(store);
            });
            waitPayOrders = stores;

            break;
          case 3:
            data['data'].forEach((item) {
              Store store = new Store(
                  item['toOrderShopId'],
                  item['toOrderShopName'],
                  item['toOrderShopThumbnail'],
                  [],
                  item['toOrderTotalPrice'],
                  1,0);
              List<Product> products = [];
              item['listGoods'].forEach((good) {
                products.add(new Product(
                    good['stogTakeoutId'],
                    good['stogTaketoutName'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutPrice'],
                    good['stogTakeoutNum'],
                    good['stogTakeoutThumbnail']));
              });
              store.products = products;
              stores.add(store);
            });
            finishPayOrders = stores;
            break;
        }
        setState(() {

        });
      }
    });
  }
}
