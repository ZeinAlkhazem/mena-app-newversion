

import 'package:shared_preferences/shared_preferences.dart';

import '../functions/main_funcs.dart';




class CacheHelper
/// add Cache init in main
{
  static SharedPreferences? sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async
  {
    logg('Putting bool value: $key');
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData({
    required String key,
  }) {
    logg('cacheGetting: $key');
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    logg('cacheSaving: $key');
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> saveListData({
    required String key,
    required List<String> value,
  }) async {
    logg('cacheSaving: $key');


    return await sharedPreferences!.setStringList(key, value);
  }


  static List<String>? getListData({
    required String key,

  })  {
    logg('cacheGetting: $key');


    return  sharedPreferences!.getStringList(key);
  }

  static Future<bool> removeData({
    required String key,
  }) async
  {
    return await sharedPreferences!.remove(key);
  }

  static Future<void> clearAllData() async
  {
    await sharedPreferences!.clear();
  }
}
//////  cache functions

bool? getCachedFirstApplicationRun() {
  return CacheHelper.getData(key: 'isFirstApplicationRun');
}

Future<bool>? saveCachedFirstApplicationRun(bool value) async {
  return CacheHelper.putBoolean(key: 'isFirstApplicationRun', value: value);
}

//token
Future<void> saveCacheToken(String? token) async {
  CacheHelper.saveData(key: 'token', value: token);
}
String? getCachedToken() {
  return CacheHelper.getData(key: 'token');
}
removeToken(){
  CacheHelper.removeData(key: 'token');
}

//Locations
Future<void> saveCacheLat(String? lat) async {
  CacheHelper.saveData(key: 'lat', value: lat);



}
String? getCachedLat() {
  return CacheHelper.getData(key: 'lat')??"";
  /// return format: lat=35&lng=35
}

Future<void> saveCacheLng(String? lng) async {
  CacheHelper.saveData(key: 'lng', value: lng);



}
String? getCachedLng() {
  return CacheHelper.getData(key: 'lng')??"";
  /// return format: lat=35&lng=35
}


//localize
Future<void> saveCacheLocal(String? localCode) async {
  CacheHelper.saveData(key: 'Local', value: localCode);
}
String? getCachedLocal() {
  return CacheHelper.getData(key: 'Local');
}
removeLocal(){
  CacheHelper.removeData(key: 'Local');
}

//selected country
Future<void> saveCachedSelectedCountry(String? localCode) async {
  CacheHelper.saveData(key: 'CachedSelectedCountry', value: localCode);
}
String? getCachedSelectedCountry() {
  return CacheHelper.getData(key: 'CachedSelectedCountry');
}
removeCachedSelectedCountry(){
  CacheHelper.removeData(key: 'CachedSelectedCountry');
}

//user id
Future<void> saveCacheUserId(int? userId) async {
  CacheHelper.saveData(key: 'UserId', value: userId);
}
int? getCacheUserId() {
  return CacheHelper.getData(key: 'UserId');
}
removeUserId(){
  CacheHelper.removeData(key: 'UserId');
}


/// clear cache
Future<void> clearAllCache()async{

  CacheHelper.clearAllData();
}
