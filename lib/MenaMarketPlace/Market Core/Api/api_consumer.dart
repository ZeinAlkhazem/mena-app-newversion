abstract class ApiConsumer {
  Future<dynamic>? get(String path, {Map<String, dynamic>? queryParameter});

  Future<dynamic>? post(String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParameter , bool isFormDataEnabled = false,});
}
