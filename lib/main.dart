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

void main() async {
//  debugPrint('main方法运行');
//  if(Platform.isIOS){
//    AMapLocationClient.setApiKey("975cc40659857357ff77d093d50ba770");
//  }
  runApp(MyApp());
}

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.white,
    primaryColorBrightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.white,
    unselectedWidgetColor: Colors.white,
    buttonColor: Colors.white,
    bottomAppBarColor: Colors.white);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orangeAccent[400],
);

class MyApp extends StatelessWidget {
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
        'lifeStore':(context)=>LifeStorePage()
      },
    );
  }
}
