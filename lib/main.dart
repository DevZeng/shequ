import 'package:flutter/material.dart';
import 'page_add_address.dart';
import 'page_list_address.dart';
import 'home.dart';
import 'page_register.dart';
import 'page_login.dart';
import 'page_outseller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'page_reading.dart';
import 'page_life.dart';
import 'dart:io';
//import 'package:amap_location/amap_location.dart';
import 'page_notification.dart';
import 'page_report.dart';
import 'page_lifeStore.dart';
import 'page_add_info.dart';
import 'page_money.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'page_houseInfo.dart';
//import 'package:sy_flutter_wechat/sy_flutter_wechat.dart';
import 'page_add_houseInfo.dart';
import 'page_visitor.dart';
import 'page_add_visitor.dart';
import 'page_repair.dart';
import 'page_count.dart';
import 'page_stay.dart';
import 'page_order_life.dart';
import 'page_needPay.dart';
import 'page_outsellerDetail.dart';
import 'page_stayDetail.dart';
import 'page_stayOrder.dart';
import 'page_order_stay.dart';
import 'page_family.dart';
import 'page_familyDetail.dart';
import 'page_repairList.dart';
import 'page_order_outseller.dart';
import 'page_visitorDetail.dart';
import 'page_add_visitorList.dart';
import 'page_comments.dart';
import 'page_product.dart';
import 'page_search.dart';
import 'page_addFamily.dart';

void main() async {
//  debugPrint('main方法运行');
//  if(Platform.isIOS){
//    AMapLocationClient.setApiKey("975cc40659857357ff77d093d50ba770");
//  }
  runApp(MyApp());
}

final ThemeData kIOSTheme = new ThemeData(
//    primarySwatch: MaterialColor(primary, {
//      50:
//    }),
    primaryColor: Colors.white,
//    primaryColorBrightness: Brightness.light,
//    backgroundColor: Colors.white,
//    unselectedWidgetColor: ,
//    scaffoldBackgroundColor: Colors.white,
//    accentColor: Colors.white,
//    unselectedWidgetColor: Colors.white,
//    buttonColor: Colors.white,
//    bottomAppBarColor: Colors.white
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orangeAccent[400],
);

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  String _result = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFluwx();
    fluwx.responseFromPayment.listen((data) {
      setState(() {
        _result = "${data}";
      });
    });
  }

  _initFluwx() async {
    await fluwx.register(
        appId: "wx00ce24906ff638d4",
        doOnAndroid: true,
        doOnIOS: true,
        enableMTA: false);
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
//    bool result = await SyFlutterWechat.register('wx00ce24906ff638d4');
//    print(result);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kIOSTheme,
      home: MyHomePage(),
      routes: {
        'addAddress': (context) => addAddressPage(),
        'listAddress': (context) => listAddressPage(),
        'login': (context) => LoginPage(),
        'home': (context) => MyHomePage(),
        'register': (context) => RegisterPage(),
        'outseller': (context) => OutSellerPage(),
        'reading': (context) => ReadingPage(),
        'life': (context) => LifePage(),
        'notifications':(context)=>NotificationPage(),
        'report':(context)=>ReportPage(),
        'lifeStore':(context)=>LifeStorePage(),
        'userInfo':(context)=>addPageInfo(),
        'money':(context)=>MoneyPage(),
        'listHouseInfo':(context)=>HouseInfoPage(),
        'addHouseInfo':(context)=>addHouseInfo(),
        'visitorePage':(context)=>VisitorPage(),
        'addVisitorPage':(context)=>addVisitorPage(),
        'repairPage':(context)=>RepairPage(),
        'countPage':(context)=>countPage(),
        'stayPage':(context)=>StayPage(),
        'lifeOrderPage':(context)=>LifeOrderPage(),
        'needPay':(context)=>NeedPayPage(),
        'outsellerDetail':(context)=>OutSellerDetailPage(),
        'stayDetail': (context) => StayDetail(),
        'stayOrder': (context) => StayOrder(),
        'stayOrderPage': (context) => StayOrderPage(),
        'family':(context)=>Family(),
        'familyDetail':(context)=>FamilyDetail(),
        'repairList':(context)=>RepairList(),
        'outsellerOrderPage':(context)=>OutSellerOrderPage(),
        'visitorDetailPage':(context)=>VisitorDetailPage(),
        'addVisitorList':(context)=>addVisitorListPage(),
        'comments':(context)=>CommentPage(),
        'product':(context)=>ProductPage(),
        'search':(context)=>SearchPage(),
        'addFamily':(context)=>addFamily()
      },
    );
  }
}

