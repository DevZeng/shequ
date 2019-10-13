import 'package:flutter/material.dart';
//import 'package:amap_base_location/amap_base_location.dart';
import 'dart:convert';

class LocationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<LocationPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
//  final _amapLocation = AMapLocation();
//  List<Location> _result = [];
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      floatingActionButton: FloatingActionButton(onPressed: (){
//        print(_result[0]);
//      }),
////      color: Theme.of(context).primaryColor,
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              FlatButton.icon(onPressed: getLocation, icon: Icon(Icons.add), label: Text('asd'))
//        ],
//      )],
//    ));
//  }
//  getLocation() async{
//    final options = LocationClientOptions(
//    isOnceLocation: true,
//    locatingWithReGeocode: true,
//    );
//
//    _amapLocation
//        .getLocation(options)
//        .then(_result.add)
//        .then((_) => setState(() {}));
//  }
//  @override
//  void dispose() {
//    _amapLocation.stopLocate();
//    super.dispose();
//  }
}
