// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import 'api_consumer.dart';
import 'dio_interceptor.dart';
import 'end_points.dart';
import 'status_code.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;
  DioConsumer({
    required this.client,
  }) {
    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    client.interceptors.add(AppInterceptors());
  }
  @override
  Future? get(String path, {Map<String, dynamic>? queryParameter}) async {
    Response response = await client.get(path, queryParameters: queryParameter);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.data.toString());
    } else {
      throw hundleException(
          response.statusCode, jsonDecode(response.data.toString()));
    }
  }

  @override
  Future? post(String path,
      {Map<String, dynamic>? body,
      bool isFormDataEnabled = false,
      Map<String, dynamic>? queryParameter}) async {
    Response response = await client.post(path,
        data: isFormDataEnabled ? FormData.fromMap(body!) : body,
        queryParameters: queryParameter);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.data.toString());
    } else {
      throw hundleException(
          response.statusCode, jsonDecode(response.data.toString()));
    }
  }
}

Exception hundleException(int? statusCode, dynamic response) {
  switch (statusCode) {
    case 400:
      {
        UnprocessableException.msg = response['message'];
        return UnprocessableException();
      }
    case 401:
      {
        return UnauthorizedException();
      }
    case 409:
      {
        return ConflictException();
      }
    case 404:
      {
        VerifyException.msg = response['message'];
        return VerifyException();
      }
    case 403:
      {
        ForbiddenException.msg = response['message'];
        return ForbiddenException();
      }
    case 422:
      {
        var msgg = List<String>.from(response['data']);

        InvalidParametersException.msg = msgg[0];
        return InvalidParametersException();
      }
    default:
      return InternalServerErrorException();
  }
}
