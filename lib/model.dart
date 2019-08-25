import 'package:shared_preferences/shared_preferences.dart';
class HouseInfo {
  int holdIdentity =0 ;
  int id =0 ;
  int holdXqId =0;
  String holdXq = '请选择';
  int holdLdId = 0;
  String holdLd = '请选择';
  int holdDyId =0;
  String holdDy = '请选择';
  String imageAddress = '';
  setHouseInfo(int identity,int XqId,String Xq,int LdId,String Ld,int DyId,String Dy,String image,int id){
    this.holdIdentity = identity;
    this.holdXqId = XqId;
    this.holdXq = Xq;
    this.holdLdId = LdId;
    this.holdLd = Ld;
    this.holdDyId = DyId;
    this.holdDy = Dy;
    this.imageAddress = image;
    this.id = id;
  }
}
getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user');
  return user;
}

getHold() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int holdId = prefs.getInt('holdId');
  return holdId;
}
void saveHold(id) async
{
  var prefs = await SharedPreferences.getInstance();
  await prefs.setInt('holdId', id);
}



getXq() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int holdId = prefs.getInt('xqId');
  return holdId;
}
void saveXq(id) async
{
  var prefs = await SharedPreferences.getInstance();
  await prefs.setInt('xqId', id);
}


class Address{
int id;
String name;
String phone;
String area;
String detail;
int is_default = 0;
Address(this.id,this.name,this.phone,this.area,this.detail,this.is_default);
}

class Product {
  int id;
  String name;
  double price;
  double sprice;
  int number;
  String icon;

  Product(int id, String name, double price, double sprice, int number,String icon) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.sprice = sprice;
    this.number = number;
    this.icon = icon;
  }
}

class Store{
  int id ;
  String name;
  String icon;
  double price;
  int type;//1 外卖 2 便利
  int send = 0;
  List<Product> products = [];
  Store (this.id,this.name,this.icon,this.products,this.price,this.type,this.send);
}

class Order{
  String number;
  Store store;
  Order(this.number,this.store);
}