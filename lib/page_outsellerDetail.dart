import 'package:flutter/material.dart';
import 'api.dart';
import 'package:dio/dio.dart';
import 'model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';

class OutSellerDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OutSellerDetailPage();
  }
}

class _OutSellerDetailPage extends State<OutSellerDetailPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller
  Api api = new Api();
  List<String> images = [];
  List tabs = [
    "点餐",
    "评价",
    "商家",
  ];
  var info = null;
  var types = [];
  int id = 0;
  int select = 0;
  int total = 0;
  String category = '全部';
  var products = [
  ];
  var comments = null;
  var lists = [
  ];
  double price = 0;
  List<Product> buys = [];
//  AMapLocation _loc;
  int member = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMember().then((val){
      print(val);
      setState(() {
        member = val;
      });
    });
    _tabController = TabController(length: tabs.length, vsync: this);

  }
  getProducts(takeoutCategoryId) {
    String url = api.getClassHShopTakeout+'?takeoutShopId=${id}';
    if(takeoutCategoryId!=0){
      url = url+'&takeoutCategoryId=${takeoutCategoryId}';
    }
//    print(url);
    Dio().get(url).then((response){
      if(response.statusCode==200){
        var data = response.data;
        print(data);
        if(data['code']==200){
          setState(() {
            products = data['data'];
            total = data['total'];
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if(id==0){
      id = ModalRoute.of(context).settings.arguments;
//    getProducts(1);
//      _checkPersmission().then((val){
//        print('locatopmn');
//      });
      getR();

      getComments(1);
      getProducts(0);
    }
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
//      appBar: AppBar(
//          backgroundColor: Color.fromRGBO(251, 239, 199, 1),
//        elevation: 0,
//      ),
      body: SingleChildScrollView(
//        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
                height: 240,
                color: Colors.white,
                alignment: Alignment.topCenter,
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
//                  color: Colors.red,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(info==null?'':info['shopRotation'].split(',')[0]),fit: BoxFit.cover)
                    ),
                    child: Stack(
                      alignment: Alignment(0, 1.6),
                      children: <Widget>[
                        Container(
//                        alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 80,
                            height: 80,
//                color: Colors.red,
                            child: Image.network(
                                info == null ? '' : info['shopThumbnail'] ),
                          ),
//                color: Colors.red,
                        )
                      ],
                    ),
                  )
                ])),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  info == null ? '' : info['shopName'],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text('评价${info == null ? '' : ''}    月售${info == null ? '' : ''}'),
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                    '起送￥${info == null ? 0 : info['shopStartFee']}    配送￥${info == null ? 0 : info['shopDeliveryFee']}'),
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                //是否可以滚动
                controller: _tabController,
                tabs: tabs.map((item) {
                  return Tab(
                    text: item,
                  );
                }).toList(),
              ),
            ),
            Container(
            height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      height: double.infinity,
//                    color: Colors.red,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height,
//                      color: Colors.green,
                            child: ListView.builder(
//                                physics: PageScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                itemCount: types.length,
                                itemExtent: 50,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(child: Container(
                                    color: types[index]['categoryId']==select?Colors.white:Colors.grey[100],
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: Center(
                                      child: Text(types[index]['categoryName']),
                                    ),
                                  ),onTap: (){
                                    getProducts(types[index]['categoryId']);
                                    setState(() {
                                      select = types[index]['categoryId'];
                                      category = types[index]['categoryName'];
                                    });
                                  },);
                                }),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                            child: Column(children: <Widget>[
                              ListTile(title: Text(category),),
                              Expanded(child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(0 ,0 , 0, 0),
                                  itemCount: products.length,
                                  itemBuilder: (context,index){
                                    return Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.75,
//                                  color: Colors.deepPurpleAccent,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  image: DecorationImage(image: NetworkImage(products[index]['takeoutThumbnail']),fit: BoxFit.cover)
                                              ),
                                            ),),
                                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.75-120,
                                              height: 100,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(products[index]['taketoutName'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                                                    width: MediaQuery.of(context).size.width * 0.75-100,
                                                    height: 40,
                                                  ),
                                                  Container(
                                                    height: 30,
//                                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                    child: Text('月售 ${products[index]['monthlySales']}',style: TextStyle(color: Colors.grey),),
                                                    width: MediaQuery.of(context).size.width * 0.75-100,
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 30,
                                                          width: MediaQuery.of(context).size.width * 0.75-170,
//                                                      color: Colors.red,
                                                          alignment: Alignment.centerLeft,
                                                          child: Text('￥ ${member==1?products[index]['takeoutMemberFee']:products[index]['takeoutFee']}'),
                                                        ),
                                                        GestureDetector(
                                                          child: Container(
                                                            width: 30,
                                                            alignment: Alignment.center,
//                                                    height: 40,
//                                                    color: Colors.red,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(image: AssetImage('images/add.png')),
                                                            ),
                                                          ),
                                                          onTap: (){
                                                            Product buy = new Product(
                                                              products[index]['takeoutId'],
                                                              products[index]['taketoutName'],
                                                              double.parse(products[index]['takeoutFee'].toString()),
                                                              double.parse(products[index]['takeoutMemberFee'].toString()),
                                                              1,
                                                              products[index]['takeoutThumbnail'],
                                                            );
                                                            addBuy(buy);
                                                            price += double.parse(member==1?products[index]['takeoutMemberFee'].toString():products[index]['takeoutFee'].toString());
                                                            showCart();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),)
                                        ],
                                      ),
                                    );
                                  }))
                            ],),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 0)),
                          Container(
                            color: Colors.white,
                            height: 120,
                            child: Row(
                              children: <Widget>[
                                Container(
//                            color: Colors.grey,
                                  width: MediaQuery.of(context).size.width*0.4,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 20, 0, 20),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(comments==null?'':'${comments['comprehensiveScore']}',style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.red
                                          ),),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.4-62,
//                                          color: Colors.red,
                                                child: Text('商家评价'),
                                                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.4-62,
//                                          color: Colors.red,
                                                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                                child: SmoothStarRating(
                                                    allowHalfRating: false,
                                                    starCount: 5,
                                                    rating: comments==null?0:comments['comprehensiveScore'],
                                                    size: 14.0,
                                                    color: Colors.orange,
                                                    borderColor: Colors.orange,
                                                    spacing:0.0
                                                ),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  width: MediaQuery.of(context).size.width*0.17,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text('味道'),
                                      ),
                                      Container(
                                        child: Text(comments==null?'':'${comments['tcommentWd']}',style: TextStyle(fontSize: 24),),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  width: MediaQuery.of(context).size.width*0.17,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text('包装'),
                                      ),
                                      Container(
                                        child: Text(comments==null?'':'${comments['tcommentBz']}',style: TextStyle(fontSize: 24),),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  width: MediaQuery.of(context).size.width*0.26,
//                            color: Colors.red,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text('配送'),
                                      ),
                                      Container(
                                        child: Text(comments==null?'':'${comments['tcommentPs']}',style: TextStyle(fontSize: 24),),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
//                    Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                          Container(
                            child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(0,10, 0, 0),
                                itemCount: lists.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index){
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 70,
                                          color: Colors.white,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.fromLTRB(20 , 10, 10  , 10),
                                                child: ClipRRect( //圆角图片
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(lists[index]['userMsgHead'],
                                                      width: 50,
                                                      height: 50
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 35,
                                                    width: MediaQuery.of(context).size.width-80,
                                                    color: Colors.white,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.7-80,
                                                          child: Text(lists[index]['userMsgNike']),
                                                          alignment: Alignment.centerLeft,
                                                        ),
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          width: MediaQuery.of(context).size.width*0.3,
                                                          child: Text(lists[index]['createTime'],style: TextStyle(color: Colors.grey),),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 35,
                                                    width: MediaQuery.of(context).size.width-80,
                                                    color: Colors.white,
                                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                    child: SmoothStarRating(
                                                        allowHalfRating: false,
                                                        starCount: 5,
                                                        rating: (lists[index]['tcommentWd']+lists[index]['tcommentBz']+lists[index]['tcommentPs'])/3,
                                                        size: 14.0,
                                                        color: Colors.orange,
                                                        borderColor: Colors.orange,
                                                        spacing:0.0
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(80, 10, 0, 0),
                                          width: MediaQuery.of(context).size.width,
//                            height: 80,
                                          color: Colors.white,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                width:MediaQuery.of(context).size.width,
                                                child: Text(lists[index]['tcommentContent']),
                                              ),
                                              Container(
                                                height: 150,
                                                width: MediaQuery.of(context).size.width,
                                                color: Colors.white,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: lists[index]['tcommentPicture'].split(',').length,
                                                    itemBuilder: (context,index){
                                                      return Padding(padding: EdgeInsets.fromLTRB(0, 0, 30, 0),child: Container(
                                                        height: 120,
                                                        width: 120,
                                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(lists[index]['tcommentPicture'].split(',')[index]))
                                                        ),
//                        child: ,
                                                      ),);
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(height: 1,),
                                      ],
                                    ),
//                      height: MediaQuery.of(context).size.height,
                                  );
                                }),
                            height: MediaQuery.of(context).size.height-123,
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '商家信息',
                                  style: TextStyle(fontSize: 20),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: images.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                  NetworkImage(images[index]),
                                                  fit: BoxFit.fill)),
                                        ),
                                      );}),
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                              color: Colors.red,
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                        Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: Text(
                              '商家名称',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            trailing: Text(info == null ? '' : info['shopName']),
                          ),
                        ),
                        Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: Text(
                                '商家地址',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              trailing: Container(
                                child:
                                Text(info == null ? '' : info['shopAddress']),
                                width: MediaQuery.of(context).size.width * 0.4,
                              ),
                            )),
                        Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: Text(
                              '商家电话',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            trailing: Text(info == null ? '' : info['shopPhone']),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: Text(
                              '营业时间',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            trailing:
                            Text(info == null ? '' : info['shopDoTime']),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(onPressed: () {
//        print(info);
//      }),
    );
  }

  void getR() {
    String url ;
//    print(_loc);
    if (info == null) {
      url = api.getOneShopMsg + '?shopId=$id';
      print(url);
      Dio().request(url).then((response) {
        if (response.statusCode == 200) {
          var content = response.data;
          print(content['data']);
          setState(() {
            info = content['data'];
            images = content['data']['shopRotation'].split(',');
            types = content['data']['listHShopCategory'];
          });
        }
      });
    }
  }
  void showCart() {
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
                      width: 140,
                      child: FlatButton(
                        onPressed: () {
                          state(() {
                            buys = [];
                          });
                        },
                        child: Row(
                          children: <Widget>[Icon(Icons.delete_outline), Text('清空购物车')],
                        ),
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
                                                  price+=buys[index].price;
                                                });
//                                        setCart(buys[index], index);
                                              }),
                                        ),
                                        Text(buys[index].number.toString()),
                                        IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              setState(() {
                                                state(() {
                                                  if(buys[index].number!=1){
                                                    buys[index].number -= 1;
                                                    price -= buys[index].price;
                                                  }
//                                                  buys[index].number -= 1;
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
                                            price.toStringAsFixed(2),
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
                                color: Color.fromRGBO(243, 200, 70, 1),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('countPage',arguments: new Store(id, info['shopName'], info['shopThumbnail'], buys,price,1,info['shopIfDelivery'],info['shopStartFee'],info['shopDeliveryFee']));
                                  },
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
  getComments(page) {
    Dio().get(api.getShopComment+'?tCommentShopId=${id}&start=${page}&length=10&tCommentType=1').then((response){
      var data = response.data;
      if(data['code']==200){
//        var images = data['data']['list'];
        setState(() {
          comments = data['data'];
          lists = data['data']['list']?data['data']['list']:[];
        });
      }
    });
  }

}
