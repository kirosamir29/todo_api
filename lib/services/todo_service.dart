import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo/utils/app_strings.dart';

class DioClient {
  final dio = Dio(BaseOptions(baseUrl: AppStrings.baseURL));

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
    debugPrint("${options.headers}");
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

  Future<bool> deleteById(String id) async {
    final response =
        await fInterceptor.dio.delete(AppStrings.apiDeleteLink + id);
    return response.statusCode == 200;
  }

  Future<List?> fetchTodo() async {
    final response = await fInterceptor.dio.get(AppStrings.apiFetchLink);
    if (response.statusCode == 200) {
      final result = response.data['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  Future<bool> updateTodo(String id, Map body) async {
    final response = await fInterceptor.dio.put(
      AppStrings.apiUpdateLink + id,
      data: body,
      queryParameters: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  Future<bool> addTodo(Map body) async {
    final response = await fInterceptor.dio.post(
      AppStrings.apiPostLink,
      data: body,
      queryParameters: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
