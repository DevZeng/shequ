import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api.dart';
import 'model.dart';

class StayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<StayPage> {
  DateTime intime = DateTime.now();
  DateTime outtime = DateTime.now().add(new Duration(days: 1));
  TextEditingController searchController = new TextEditingController();
  Api api = new Api();
  var stores = [];
  var loc;
  ScrollController scrollController = new ScrollController();
  int total = 0;
  int page = 1;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
//      print(scrollController.offset);
//      print('heigth:${MediaQuery.of(context).size.height},offset:${scrollController.offset}');
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if(total != stores.length){
          print(total);
          print(stores.length);
          setState(() {
            loading = true;
          });
          _retrieveData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    if(args!=null){
      loc = args;
    }
    if(stores.length==0){
      getShop(loc['lat'],loc['lon']);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('酒店住宿'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: new BoxDecoration(
//                      color: Colors.grey[100],
                        borderRadius: new BorderRadius.all(Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 80,
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      child: Text(
                                        "${intime.month}月${intime.day}日",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                    ),
                                    onTap: () {
                                      showDatePicker(

                                        locale: Locale('zh'),
                                        context: context,
                                        initialDate: new DateTime.now(),
                                        firstDate: new DateTime.now()
                                            .subtract(new Duration(days: 30)),
                                        // 减 30 天
                                        lastDate: new DateTime.now()
                                            .add(new Duration(days: 30)),
                                      ).then((val) {
//                                    print(val);
                                        if (val != null &&
                                            outtime.difference(val).inDays >
                                                0) {
//                                    print(outtime.difference(val).inDays);
                                          intime = val;
                                        }
                                        setState(() {});
                                      });
                                    },
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                    child: Text(
                                      '——',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Text(
                                        "${outtime.month}月${outtime.day}日",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                        locale: Locale('zh'),
                                        context: context,
                                        initialDate: new DateTime.now(),
                                        firstDate: new DateTime.now()
                                            .subtract(new Duration(days: 30)),
                                        // 减 30 天
                                        lastDate: new DateTime.now()
                                            .add(new Duration(days: 30)),
                                      ).then((val) {
                                        if (val != null) {
                                          outtime = val;
                                        }
                                        setState(() {});
                                      });
                                    },
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2-4,
//                                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text(
                                        "共${getDay(outtime.difference(intime).inHours)}晚"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
                              decoration: new BoxDecoration(
//                      color: Colors.grey[100],
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(20)),
                              ),
                              alignment: Alignment.center,
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        new EdgeInsets.only(left: 0.0),
                                    border: InputBorder.none,
                                    icon: Icon(Icons.search,),
                                    hoverColor: Colors.grey,
                                    hintText: "搜索酒店名称",
                                    hintStyle: new TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                style: new TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 40.0,
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: RaisedButton(
//                                onPressed: searchShop(1,searchController.text,loc['lat'],loc['lon']),
                                  color: Color.fromRGBO(240, 190, 60, 1),
                                  disabledColor: Color.fromRGBO(240, 190, 60, 1),
                                  child: new Text("搜索酒店",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  shape: new StadiumBorder(
                                      side: new BorderSide(
                                        style: BorderStyle.solid,
                                        color: Color.fromRGBO(240, 190, 60, 1),
                                      )),
                                ),
                              ),
                              onTap: (){
                                searchShop(1, searchController.text,loc['lat'],loc['lon']);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    Container(
//                color: Colors.white,
                      width: MediaQuery.of(context).size.width - 30,
                      child: Wrap(
                        spacing: 8.0, // 主轴(水平)方向间距
                        runSpacing: 8.0, // 纵轴（垂直）方向间距
                        alignment: WrapAlignment.start, //沿主轴方向居中
                        children: stores.map((store) {
                          return GestureDetector(child: Container(
                            decoration: new BoxDecoration(
//                      color: Colors.grey[100],
                              borderRadius:
                              new BorderRadius.all(Radius.circular(8)),
                              color: Colors.white,
                            ),
                            width: MediaQuery.of(context).size.width * 0.5 - 19,
                            height:
                            MediaQuery.of(context).size.width * 0.75 - 19,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                  MediaQuery.of(context).size.width * 0.5 -
                                      19,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              store['shopThumbnail']),
                                          fit: BoxFit.fill)),
                                ),
                                Container(
                                  child: Text(
                                    store['shopName'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 2,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on,color: Colors.yellow,size: 14,),
                                      Text(store['shopDistance']==null?'未知':getDistance(store['shopDistance'])
                                      ),
                                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: Text('${store['shopScore']}分',style: TextStyle(color: Colors.grey)),)
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('¥${store['shopLowPrice']}',style: TextStyle(color: Colors.red,fontSize: 18),),
                                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child:
                                        Text('${store['shopMonthlySales']}销量',style: TextStyle(color: Colors.grey),))
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                ),
                              ],
                            ),
//                      color: Colors.blue,
                          ),onTap: (){
                            Navigator.of(context).pushNamed('stayDetail',arguments: {
                              'id':store['shopId'],
                              'indate':intime,
                              'outdate':outtime,
                            });
                          },);
                        }).toList(),
                      ),
                    ),
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print(stores);
      }),
    );
  }
  void getShop(lat ,lon) {
    String url = api.getTypeHShopMsg+ '?shopType=3&start=1&lenght=10';
    if(lat!=0&&lat!=null){
      url+="&lat=${lat}&log=${lon}";
    }
    print(url);
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content);
        setState(() {
          stores = content['data'];
          total = content['total'];
          loading = false;
        });
      }
    });
  }
  void _retrieveData() {
    if(total!=stores.length){
      Future.delayed(Duration(seconds: 1)).then((e) {
        addShop(loc['lat'],loc['lon'],page+1);
        setState(() {
          page = page+1;
          loading = false;
          //重新构建列表
        });
      });
    }else{
      setState(() {
//        page = page+1;
        loading = false;
        //重新构建列表
      });
    }
  }
  void addShop(lat ,lon,page) {
    String url = api.getTypeHShopMsg+ '?shopType=3&start=$page&lenght=10';
    if(lat!=0&&lat!=null){
      url+="&lat=${lat}&log=${lon}";
    }
    print(url);
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content);
        setState(() {
          stores = content['data'];
//          total = content['total'];
        });
      }
    });
  }
  searchShop(int page,String key,lat ,lon)
  {
    print('search');
    if(key.length==0){
      return ;
    }
    String url = api.searchHotel+ "?start=$page&length=100&key="+key;
    if(lat!=0&&lat!=null){
      url+="&lat=${loc['lat']}&log=${loc['lon']}";
    }
    print(url);
    Dio().request(url).then((response) {
      if (response.statusCode == 200) {
        var content = response.data;
        print(content);
        if(content['code']==200){
          setState(() {
            stores = content['data'];
          });
        }
      }
    });
  }
}
