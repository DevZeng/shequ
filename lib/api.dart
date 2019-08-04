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
  final getOneShopMsg = host +'appHShopMsg/getOneShopMsg';
  final products = host +'appHShopStore/getQianShopHShopStore';
}
