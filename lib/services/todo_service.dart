import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  final dio = Dio(BaseOptions(baseUrl: "https://api.nstack.in"));

  DioClient() {
    addInterceptor(LogInterceptor(responseBody: true, requestBody: true));
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({"token-token": "value value"});
    handler.next(options);
  }
}

class PrintResponsePropertiesInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    debugPrint("***************************");
    debugPrint("${response.statusCode}");
    debugPrint("${response.realUri}");
    debugPrint("***************************");
    super.onResponse(response, handler);
  }
}

class TodoService {
  static DioClient fInterceptor = DioClient();

  static Future<bool> deleteById(String id) async {
    final response =
        await fInterceptor.dio.delete("https://api.nstack.in/v1/todos/$id");
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodo() async {
    final response = await fInterceptor.dio.get("/v1/todos?page=1&limit=20");
    if (response.statusCode == 200) {
      final result = response.data['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodo(String id, Map body) async {
    final response = await fInterceptor.dio.put(
      "https://api.nstack.in/v1/todos/$id",
      data: body,
      queryParameters: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> addTodo(Map body) async {
    final response = await fInterceptor.dio.post(
      "https://api.nstack.in/v1/todos?page=1&limit=20",
      data: body,
      queryParameters: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
