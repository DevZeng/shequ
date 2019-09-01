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
  int state = 0;
  setHouseInfo(int identity,int XqId,String Xq,int LdId,String Ld,int DyId,String Dy,String image,int id,int state){
    this.holdIdentity = identity;
    this.holdXqId = XqId;
    this.holdXq = Xq;
    this.holdLdId = LdId;
    this.holdLd = Ld;
    this.holdDyId = DyId;
    this.holdDy = Dy;
    this.imageAddress = image;
    this.id = id;
    this.state = state;
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
saveAddress(address)async{
  var prefs = await SharedPreferences.getInstance();
  await prefs.setString('address', address);
}
getAddress()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String address = prefs.getString('address');
  return address;
}
void saveHold(id) async
{
  var prefs = await SharedPreferences.getInstance();
  await prefs.setInt('holdId', id);
}
logout()async{
  var prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  await prefs.remove('xqId');
  await prefs.remove('holdId');
}
void saveHoldType(type) async{
  var prefs = await SharedPreferences.getInstance();
  await prefs.setInt('holdType', type);
}
getHoldType() async {
  var prefs = await SharedPreferences.getInstance();
  int type =  prefs.getInt('holdType');
  return type;
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

getDay(int hours){
  int day ;
  if(hours<24){
    day = 1;
  }
  int a = hours%24;
  if(a==0){
    day = (hours/24).toInt();
  }else{
    day = (hours/24).toInt()+1;
  }
  return day;
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
  double sendPrice;
  double startPrice;
  int type;//1 外卖 2 便利
  int send = 0;
  List<Product> products = [];
  Store (this.id,this.name,this.icon,this.products,this.price,this.type,this.send,this.startPrice,this.sendPrice);
}

class Order{
  String number;
  Store store;
  Order(this.number,this.store);
}

getDistance(int distance) {
  if(distance<1000){
    return '${distance}m';
  }else{
    return '${(distance/1000).toStringAsFixed(2)}km';
  }
}