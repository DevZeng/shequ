import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:dio/dio.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class MoneyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Page();
  }
}

class Page extends State<MoneyPage> {
  double amount = 0;
  int id = 0;
  bool auto = false;
  double price = 0;
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    return user;
  }
  String _result = "无";
  String remark = '';
  Api api = new Api();
  bool loading = false;

  void initState() {
    super.initState();
    fluwx.responseFromPayment.listen((data) {
      setState(() {
        loading = false;
      });
      if(data.errCode==0){
        getUser().then((val){
          Dio().request(api.getUserMember+'?token=$val').then((response){
            var data = response.data;
            if(data['code']==200){
              print(data['data']);
              amount = data['data']['memberBalance']==null?0:data['data']['memberBalance'];
              setState(() {

              });
            }
          });
        });
      }
    });
//    fluwx.
    getUser().then((val){
      Dio().request(api.getUserMember+'?token=$val').then((response){
        var data = response.data;
        if(data['code']==200){
          print(data['data']);
          amount = data['data']['memberBalance']==null?0:data['data']['memberBalance'];
          auto = data['data']['memberAutopay']==null?false:data['data']['memberAutopay'];
          id = data['data']['memberId']==null?0:data['data']['memberId'];
          remark = data['data']['memberDifferPrice']==0?'':data['data']['memberSetRemarks1']+'${data['data']['memberDifferPrice']}'+data['data']['memberSetRemarks2'];
          setState(() {

          });
        }
      });
    });
  }
//  Page(){
//
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('钱包'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ModalProgressHUD(inAsyncCall: loading, child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
//          color: Colors.white,
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
                        amount.toString(),
                        style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
                      ),
//                    height: MediaQuery.of(context).size.height*0.1,
//                    color: Colors.white,
                    ),
                    Text('¥余额',style: TextStyle(fontWeight: FontWeight.w600),),
                    Text(remark,style: TextStyle(fontSize: 12,color: Colors.grey[600]),),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
//color: Colors.grey,
                alignment: Alignment.bottomRight,
//              alignment: Alignment(0, 1),
                child: SwitchListTile(
                  value: auto,
//                  groupValue: auto,
                  onChanged: (val){
                    print(val);
                    getUser().then((token){
                      var formData = {
                        'token':token,'memberId':id,'memberAutopay':val
                      };
                      print(formData);
                      Dio().put(api.putUserMember,data: formData).then((response){
                        print(response);
                        if(response.statusCode==200){
                          var data = response.data;
                          print(data);
                          if(data['code']==200){
                            setState(() {
                              auto = val;
                            });
                          }else{
                            Fluttertoast.showToast(
                                msg: data['msg'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          }
                        }
                      });

                    });
                  },
                  title: Text('自动缴费'),
                  activeColor: Color.fromRGBO(243, 200, 70, 1),
//                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40.0,
                child: new RaisedButton(
                  onPressed: () {
                    myDialog(context).then((val){
                      if(price==0){
                        return;
                      }
//                      var price  = double.parse(val);
//                      print(price);
                      getUser().then((val) {
                        var formData =
                            '{"token": "$val", "moFeeValue":${price} }';
                        print(formData);
                        Dio()
                            .post(api.postHUserMemberOrder,
                            data: formData)
                            .then((response) {
                          print(response);
                          var data = response.data;
                          if (data['code'] == 200) {
                            var moId = data['data']['moId'];
                            var formData =
                                '{"token": "$val", "orderid": "${moId}","orderType": 4}';
                            print(formData);
                            Dio()
                                .post(api.wxpay, data: formData)
                                .then((response) {
//                                  print(response);
                              data = response.data;
                              print(data);
                              if (data['code'] == 200) {
                                setState(() {
                                  loading = true;
                                });
                                data = jsonDecode(data['data']);
                                fluwx
                                    .pay(
                                    appId: data['appid']
                                        .toString(),
                                    partnerId: data['partnerid']
                                        .toString(),
                                    prepayId: data['prepayid']
                                        .toString(),
                                    packageValue: data['package']
                                        .toString(),
                                    nonceStr: data['noncestr']
                                        .toString(),
                                    timeStamp: int.parse(
                                        data['timestamp']),
                                    sign: data['sign']
                                        .toString())
                                    .then((val) {
                                  print(val);
                                }).catchError((error) {
                                  print(error);
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                            });
                          }
                        });
                      });
                    });

//                print(detailController.text);
//                fluwx.pay(appId: 'wx00ce24906ff638d4', partnerId: '1544254701', prepayId: 'wx072037024038545b547813bd1534702000', packageValue: 'Sign=WXPay', nonceStr: 'mHJCkoKGtCfJpIqAfhnAGws9AeohgfPd', timeStamp: 1565181422, sign: 'F657FABDECD7E14ECC8CDF5FA7A8D66B');
//                    showGeneralDialog(context: null, pageBuilder: null)
                  },
                  color: Color.fromRGBO(243, 200, 70, 1),
                  child: new Text("充值",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  shape: new StadiumBorder(
                      side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Color.fromRGBO(243, 200, 70, 1),
                      )),
                ),
              )
            ],
          ),
        ),
      )),
//      floatingActionButton: FloatingActionButton(onPressed: () {
//        print(amount);
////        fluwx.share(model)
//      }),
    );
  }
  Future<AlertDialog> myDialog(BuildContext context) {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController _controller = new TextEditingController();
          return SimpleDialog(
            title: Text("请输入金额"),
            titlePadding: EdgeInsets.all(10),
//                            backgroundColor: Colors.amber,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
//                              WhitelistingTextInputFormatter(RegExp(r'^\d+\.\d{2}\$'))
//                                  TextInputFormatter();
                    _UsNumberTextInputFormatter(),//只允许输入小数
                  ],
                ),
              ),
              ListTile(
                leading: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('取消')),
                trailing: FlatButton(
                    onPressed: () {
                      if(_controller.text.length==0){
                        Navigator.of(context).pop();
                      }
                      setState(() {
                        price = double.parse(_controller.text);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('确认')),

              ),

            ],
          );
        });
  }
}
class _UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;
  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" && value != defaultDouble.toString() && strToFloat(value, defaultDouble) == defaultDouble) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }


}

