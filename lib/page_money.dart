import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<MoneyPage> {
  String _result = "无";

  void initState() {
    super.initState();

    fluwx.responseFromPayment.listen((data) {
      setState(() {
        _result =
            "opid:${data.androidOpenId},'PrepayId':${data.androidPrepayId},'androidTransaction':${data.androidTransaction}"
            ",'errCode':${data.errCode},'errStr':${data.errStr},'extData':${data.extData}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('钱包'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
//              width: MediaQuery.of(context).size.width*0.9,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/money.png'), fit: BoxFit.fill),
//                border: Border.all(width: 0)
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Text(
                        '888',
                        style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
                      ),
//                    height: MediaQuery.of(context).size.height*0.1,
//                    color: Colors.white,
                    ),
                    Text('888'),
                    Text('888'),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
//color: Colors.grey,
                alignment: Alignment.bottomRight,
//              alignment: Alignment(0, 1),
                child: RadioListTile(
                  value: 0,
                  groupValue: 1,
                  onChanged: null,
                  title: Text('自动缴费'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40.0,
                child: new RaisedButton(
                  onPressed: () {
//                print(detailController.text);
//                fluwx.pay(appId: 'wx00ce24906ff638d4', partnerId: '1544254701', prepayId: 'wx072037024038545b547813bd1534702000', packageValue: 'Sign=WXPay', nonceStr: 'mHJCkoKGtCfJpIqAfhnAGws9AeohgfPd', timeStamp: 1565181422, sign: 'F657FABDECD7E14ECC8CDF5FA7A8D66B');
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new addDialog();
                        });
                  },
                  color: Colors.orange,
                  child: new Text("保存地址",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  shape: new StadiumBorder(
                      side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xffFF7F24),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print(_result);
//        fluwx.share(model)
      }),
    );
  }
}

class addDialog extends Dialog {
  Api api = new Api();
  TextEditingController textEditingController = new TextEditingController();
  String url;

  addDialog({Key key, this.url}) : super(key: key);

  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(12),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                decoration: ShapeDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ))),
                margin: const EdgeInsets.all(12.0),
                child: new Column(children: <Widget>[
                  new Padding(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 28.0),
                      child: Center(
                          child: new Text('请输入金额',
                              style: new TextStyle(
                                fontSize: 20.0,
                              )))),
                  new Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: textEditingController,
                      )),
                  new Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width - 68) / 2,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('取消')),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width - 68) / 2,
                          child: FlatButton(
                              onPressed: () {
                                //"${int.parse(textEditingController.text)}"
                                getUser().then((val) {
                                  var formData =
                                      '{"token": "$val", "moFeeValue":1 }';
                                  Dio()
                                      .post(api.postHUserMemberOrder,
                                          data: formData)
                                      .then((response) {
                                    var data = response.data;
                                    if (data['code'] == 200) {
                                      var moId = data['data']['moId'];
                                      var formData =
                                          '{"token": "$val", "orderid": "${moId}","orderType": 4}';
                                      Dio()
                                          .post(api.wxpay, data: formData)
                                          .then((response) {
                                        data = response.data;
                                        if (data['code'] == 200) {
                                          print(data['data']);
                                          fluwx
                                              .pay(
                                                  appId: data['data']['appId']
                                                      .toString(),
                                                  partnerId: data['data']
                                                          ['partnerId']
                                                      .toString(),
                                                  prepayId: data['data']
                                                          ['prepayId']
                                                      .toString(),
                                                  packageValue: data['data']
                                                          ['packAge']
                                                      .toString(),
                                                  nonceStr: data['data']
                                                          ['nonceStr']
                                                      .toString(),
                                                  timeStamp: int.parse(
                                                      data['data']
                                                          ['timeStamp']),
                                                  sign: data['data']['sign']
                                                      .toString())
                                              .then((val) {
                                            print(val);
                                          }).catchError((error) {
                                            print(error);
                                          });
                                        }
                                      });
                                    }
                                  });
                                });
//                            print(textEditingController.text);

//                            fluwx.pay(appId: 'wx00ce24906ff638d4', partnerId: '1544254701', prepayId: 'wx072037024038545b547813bd1534702000', packageValue: 'Sign=WXPay', nonceStr: 'mHJCkoKGtCfJpIqAfhnAGws9AeohgfPd', timeStamp: 1565181422, sign: 'F657FABDECD7E14ECC8CDF5FA7A8D66B');
//                            print(this.url);
//                          print();
//                          print(textEditingController.text);
//                          fluwx.openWeChatApp();
                              },
                              child: Text('确认')),
                        ),
                      ],
                    ),
                  )
//                  new Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      mainAxisSize: MainAxisSize.max,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        TextFormField()
////                        TextField()
//                      ])
                ])),
          ],
        ),
      ),
    );
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
//    print(user);
    return user;
  }
}
