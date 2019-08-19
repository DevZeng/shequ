class Api {
  static final host = 'http://193.112.129.128:8091/zboot/';
  final getHRotation = host + 'appHRotation/getHRotation'; //获取轮播
  static final sendMessage = host + 'appHUserAccount/sendMessage';
  static final register = host + 'appHUserAccount/postHUserAccount';
  static final login = host + 'appHUserAccount/postLogin';
  final informationClass = host + 'appHInformationClass/getInformationClass';
  final information = host + 'appHInformation/getHInformation';
  final informationOne = host + 'appHInformation/getOne';
  final getTypeHShopMsg = host + 'appHShopMsg/getTypeHShopMsg';
  final upload = host +'txUpload_t';
  final uploadT = host +'txUpload';
  final getOneShopMsg = host +'appHShopMsg/getOneShopMsg';
  final products = host +'appHShopStore/getQianShopHShopStore';
  final setAddress = host +'appHUserAddress/putUserMsg';
  final delAddress = host +'appHUserAddress/delHUserAddress';
  final modifyAddress = host +'appHUserAddress/putHUserAddress';
  final getUserInfo = host +'appHUserMsg/getUserMsg';
  final setUserInfo = host +'appHUserMsg/putUserMsg';
  final postHUserMemberOrder = host +'appUserMemberOrder/postHUserMemberOrder';
  final wxpay = host +'pay/onpenPay';
  final getUserMember = host +'appHUserMember/getUserMember';
  final getHUserAddress = host +'appHUserAddress/getHUserAddress';
  final getHHouseMsg = host +'appHHouseMsg/getHHouseMsg';
  final postHHouseUserHold = host +'appHHouseUserHold/postHHouseUserHold';
  final putHHouseUserHold = host +'appHHouseUserHold/putHHouseUserHold';
  final getHHouseUserHold = host +'appHHouseUserHold/getHHouseUserHold';
  final postHVisitorRoom = host +'appHVisitor/postHVisitorRoom';
  final getUserHVisitorRoom = host +'appHVisitor/getUserHVisitorRoom';
  final share = 'http://193.112.129.128:8099/';
  final postHShopStoreOrder = host +'appHShopStoreOrder/postHShopStoreOrder';
  final getHShopStoreOrder = host +'appHShopStoreOrder/getHShopStoreOrder';
  final getXqHHouseInformation = host +'appHouseInformation/getXqHHouseInformation';
  final postHComplaint = host +'appHComplaint/postHComplaint';
}
