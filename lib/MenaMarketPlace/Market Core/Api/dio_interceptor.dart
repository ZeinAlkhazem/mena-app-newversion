import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';

import '../../../core/cache/cache.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrintStack(
        label: 'REQUEST[${options.method}] => PATH: ${options.path}');
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    
    // options.headers['Authorization'] = EndPoints.token;
    getCachedToken()== null
        ? null
        : options.headers['Authorization'] =
            'Bearer ${getCachedToken()}';
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrintStack(
        label:
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} => response:${response.data}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrintStack(
        label:
            'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
