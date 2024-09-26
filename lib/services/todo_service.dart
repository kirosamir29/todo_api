import 'package:dio/dio.dart';

class TodoService {
  static final dio = Dio();

  static Future<bool> deleteById(String id) async {
    final response = await dio.delete("https://api.nstack.in/v1/todos/$id");
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodo() async {
    final response =
        await dio.get("https://api.nstack.in/v1/todos?page=1&limit=20");
    if (response.statusCode == 200) {
      final result = response.data['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodo(String id, Map body) async {
    final response = await dio.put(
      "https://api.nstack.in/v1/todos/$id",
      data: body,
      queryParameters: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> addTodo(Map body) async {
    final response = await dio.post(
      "https://api.nstack.in/v1/todos?page=1&limit=20",
      data: body,
      queryParameters: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
