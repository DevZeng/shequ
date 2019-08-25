import 'package:flutter/material.dart';
import 'model.dart';
import 'api.dart';
import 'package:dio/dio.dart';

class Family extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _family();
  }
}

class _family extends State<Family>{
  var parsons = [
  ];
  List<String> types = ['家庭成员', '户主', '工人', '租客'];

  Api api = new Api();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((val){
      getHold().then((hold){
        Dio().get(api.getHHouseUserFamily+"?token=${val}&holdId=${hold}").then((response){
          if(response.statusCode==200){
            print(response);
            var data = response.data;
            if(data['code']==200){
              setState(() {
                print(data['data']);
                parsons = data['data'];
              });
            }
          }
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('家庭成员信息'),elevation: 0,),
      body: Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 10),child: Wrap(
        spacing: 8.0, // 主轴(水平)方向间距
        runSpacing: 10.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.start, //沿主轴方向居中
        children: parsons.map((person){
          return GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width*0.5-10,
              height: 150,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Container(
                    width: MediaQuery.of(context).size.width*0.5-30,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(image: NetworkImage(person['familyImage']),fit: BoxFit.fill)
                    ),
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(10,10, 10, 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(person['familyName']),
                          width: MediaQuery.of(context).size.width*0.25-15,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(types[person['familyIdentity']]),
                          width: MediaQuery.of(context).size.width*0.25-15,
                        ),
                      ],
                    ),)
                ],
              ),
            ),
            onTap: (){
              Navigator.of(context).pushNamed('familyDetail',arguments: {
                'id':person['familyId'],
                'type':person['familyType'],
                'status':person['familyStatus'],
                'name':person['familyName'],
                'image':person['familyImage'],
                'sex':person['familySex'],
                'idcard':person['familyIdcard'],
                'identity':person['familyIdentity'],
              });
            },
          );
        }).toList(),
      ),),
    );
  }
}