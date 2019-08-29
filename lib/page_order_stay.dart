import 'package:flutter/material.dart';
import 'model.dart';
import 'package:dio/dio.dart';
import 'api.dart';

class StayOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _stayOrderPage();
  }
}

class _stayOrderPage extends State<StayOrderPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller
  List tabs = [
    "未支付",
    "待入住",
    "入住中",
    "已完成",
  ];
  String token = '';
  var unPayOrders = [];
  var payOrders = [];
  var waitPayOrders = [];
  var finishPayOrders = [];
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
        title: Text('酒店订单'),
        elevation: 0,
        bottom: TabBar(
          //生成Tab菜单
            controller: _tabController,
            labelColor: Color.fromRGBO(243, 200, 70, 1),
            indicatorColor: Color.fromRGBO(243, 200, 70, 1),
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
                              child: Image.network(unPayOrders[index]['hotelOrderShopThumbnail']),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    height: 40,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          child: Text(
                                            unPayOrders[index]['hotelOrderShopName'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[0],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0),child: Container(
//                                    color: Colors.yellow,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width*0.8-140,
                                          child: Text(
                                              '${unPayOrders[index]['hotelOrderName']}'),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: MediaQuery.of(context).size.width*0.2,
                                          child: Text(
                                            '¥${unPayOrders[index]['hotelOrderTotalFee']}',style: TextStyle(color: Colors.red,fontSize: 18),),
                                        )
                                      ],
                                    ),
                                  ),),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),child: Container(
                                    width: MediaQuery.of(context).size.width-125,
                                    child: Text('${unPayOrders[index]['hotelOrderInTime']} - ${unPayOrders[index]['hotelOrderOutTime']}'),
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),

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
                              child: Image.network(payOrders[index]['hotelOrderShopThumbnail']),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    height: 40,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          child: Text(
                                            payOrders[index]['hotelOrderShopName'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[0],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0),child: Container(
//                                    color: Colors.yellow,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width*0.8-140,
                                          child: Text(
                                              '${payOrders[index]['hotelOrderName']}'),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: MediaQuery.of(context).size.width*0.2,
                                          child: Text(
                                            '¥${payOrders[index]['hotelOrderTotalFee']}',style: TextStyle(color: Colors.red,fontSize: 18),),
                                        )
                                      ],
                                    ),
                                  ),),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),child: Container(
                                    width: MediaQuery.of(context).size.width-125,
                                    child: Text('${payOrders[index]['hotelOrderInTime']} - ${payOrders[index]['hotelOrderOutTime']}'),
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),

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
                              child: Image.network(waitPayOrders[index]['hotelOrderShopThumbnail']),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    height: 40,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          child: Text(
                                            waitPayOrders[index]['hotelOrderShopName'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[0],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0),child: Container(
//                                    color: Colors.yellow,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width*0.8-140,
                                          child: Text(
                                              '${waitPayOrders[index]['hotelOrderName']}'),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: MediaQuery.of(context).size.width*0.2,
                                          child: Text(
                                            '¥${waitPayOrders[index]['hotelOrderTotalFee']}',style: TextStyle(color: Colors.red,fontSize: 18),),
                                        )
                                      ],
                                    ),
                                  ),),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),child: Container(
                                    width: MediaQuery.of(context).size.width-125,
                                    child: Text('${waitPayOrders[index]['hotelOrderInTime']} - ${waitPayOrders[index]['hotelOrderOutTime']}'),
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),

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
                              child: Image.network(finishPayOrders[index]['hotelOrderShopThumbnail']),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    height: 40,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8 -
                                              110,
                                          child: Text(
                                            finishPayOrders[index]['hotelOrderShopName'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            tabs[0],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0),child: Container(
//                                    color: Colors.yellow,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width*0.8-140,
                                          child: Text(
                                              '${finishPayOrders[index]['hotelOrderName']}'),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: MediaQuery.of(context).size.width*0.2,
                                          child: Text(
                                            '¥${finishPayOrders[index]['hotelOrderTotalFee']}',style: TextStyle(color: Colors.red,fontSize: 18),),
                                        )
                                      ],
                                    ),
                                  ),),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),child: Container(
                                    width: MediaQuery.of(context).size.width-125,
                                    child: Text('${finishPayOrders[index]['hotelOrderInTime']} - ${finishPayOrders[index]['hotelOrderOutTime']}'),
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print(unPayOrders);
      }),
    );
  }

  getOrder(int type) async {
    print(type);
    List<Store> stores = [];
    Dio()
        .get(api.getHShopHotelOrder + "?token=$token&&hotelOrderStatus=$type")
        .then((response) {
      var data = response.data;
      print(data);
      if (data['code'] == 200) {
        switch (type) {
          case 0:
            unPayOrders = data['data'];
//            data['data'].forEach((item) {
//              Store store = new Store(
//                  item['storeOrderShopId'],
//                  item['storeOrderShopName'],
//                  item['storeOrderShopThumbnail'],
//                  [],
//                  item['storeOrderTotalPrice'],
//                  2);
//              List<Product> products = [];
//              item['listGoods'].forEach((good) {
//                products.add(new Product(
//                    good['ssogId'],
//                    good['ssogStoreName'],
//                    good['ssogStorePrice'],
//                    good['ssogStoreNum'],
//                    good['ssogStoreThumbnail']));
//              });
//              store.products = products;
//              stores.add(store);
//            });
//            unPayOrders = stores;
            break;
          case 1:
//            data['data'].forEach((item) {
//              Store store = new Store(
//                  item['storeOrderShopId'],
//                  item['storeOrderShopName'],
//                  item['storeOrderShopThumbnail'],
//                  [],
//                  item['storeOrderTotalPrice'],
//                  2);
//              List<Product> products = [];
//              item['listGoods'].forEach((good) {
//                products.add(new Product(
//                    good['ssogId'],
//                    good['ssogStoreName'],
//                    good['ssogStorePrice'],
//                    good['ssogStoreNum'],
//                    good['ssogStoreThumbnail']));
//              });
//              store.products = products;
//              stores.add(store);
//            });
            payOrders = data['data'];

            break;
          case 2:

            waitPayOrders = data['data'];
            break;
          case 3:
            finishPayOrders = data['data'];
            break;
        }
        setState(() {

        });
      }
    });
  }
}
