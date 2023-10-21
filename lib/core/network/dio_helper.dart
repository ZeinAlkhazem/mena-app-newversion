import 'dart:convert';

import 'package:dio/dio.dart';

import '../cache/cache.dart';
import '../functions/main_funcs.dart';
import 'network_constants.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ));
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'lat': '${getCachedLat()}',
      'lng': '${getCachedLng()}',
      'Content-Type': 'application/json',
    };

    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    logRequestedUrl('url: $baseUrl$url\n');
    logRequestedUrl('queryParameters: $query\n');
    logRequestedUrl('data: $data\n');
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'lat': '${getCachedLat()}',
      'lng': '${getCachedLng()}',
      'Content-Type': 'application/json',
    };

    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'lat': '${getCachedLat()}',
      'lng': '${getCachedLng()}',
      'Content-Type': 'application/json',
    };

    return dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}

class MainDioHelper {
  static Dio? dio;

  static init() {
    logg('MainDioHelper init');
    dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(seconds: 60), // 60 seconds
          receiveTimeout: Duration(seconds:120)),
    );
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
    String lang = 'en',
    // String? token,
  }) async {
    String? cachedLocal = getCachedLocal();
    String? token = getCachedToken();
    
    if (cachedLocal == null) {
      lang = 'en';
    } else if (cachedLocal == 'ar') {
      lang = 'ar';
    } else {
      lang = 'en';
    }
    logRequestedUrl('get method');
    logRequestedUrl('url: $baseUrl$url\n');
    // query.putIfAbsent('lat', () => getCachedLat());
    // query.putIfAbsent('lng', () => getCachedLng());
    logRequestedUrl('queryParameters: $query\n');
    logRequestedUrl('token: $token\n');

    dio!.options.headers = {
      'lang': lang,
      'Authorization': "Bearer $token",
      'lat': '${getCachedLat()}',
      'lng': '${getCachedLng()}',
      'Accept': 'application/json',
    };

    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
  }) async {
    String? cachedLocal = getCachedLocal();

    if (cachedLocal == null) {
      lang = 'en';
    } else if (cachedLocal == 'ar') {
      lang = 'ae';
    } else {
      lang = 'en';
    }
    String? token = getCachedToken();

    ///
    logRequestedUrl('post method');
    logRequestedUrl('url: $baseUrl$url\n');
    logRequestedUrl('queryParameters: $query\n');
    logRequestedUrl('data: $data\n');
    logRequestedUrl('token: $token\n');
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token != null ? "Bearer $token" : token,
      'lat': '${getCachedLat()}',
      'lng': '${getCachedLng()}',
      'Accept': 'application/json',
    };

    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    logRequestedUrl('putData method');
    logRequestedUrl('url: $baseUrl$url\n');
    logRequestedUrl('queryParameters: $query\n');
    logRequestedUrl('data: $data\n');

    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'lat': '${getCachedLat()}',
      'lng': '${getCachedLng()}',
      'Content-Type': 'application/json',
    };

    return dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> postDataWithFormData({
    required String url,
    FormData? data,
    Map<String, dynamic>? query,
    String lang = 'en',
  }) async {
    String? token = getCachedToken();
    logRequestedUrl('postDataWithFormData method');
    logRequestedUrl('url: $baseUrl$url\n');
    logRequestedUrl('queryParameters: $query\n');
    logRequestedUrl('data: $data\n');
    logRequestedUrl('token: $token\n');
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token != null ? "Bearer $token" : null,
      'lat': '${getCachedLat()}',
      'lng': '${getCachedLng()}',
      'Accept': 'application/json',
    };

    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
//
// static Future<Response> getTestData() async {
//   dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://blasanka.github.io/watch-ads/lib/data/ads.json',
//       receiveDataWhenStatusError: true,
//     ),
//   );
//   return dio!.get('');
// }
}
