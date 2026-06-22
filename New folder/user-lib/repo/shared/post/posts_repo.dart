import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/post_model.dart';

class PostsRepo {
  Future<List<PostModel>> fetchPost() async {
    // 1. Define your headers
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Adding a User-Agent often bypasses 403 blocks from simple security filters
      'User-Agent': 'PostmanRuntime/7.28.4',
    };

    try {
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/comments"),
        headers: headers, // 2. Pass headers here
      );

      // print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List body = jsonDecode(response.body);
        return body.map((e) => PostModel.fromJson(e)).toList();
      } else if (response.statusCode == 403) {
        throw 'Access Forbidden (403): The server refused the request. Check your headers or network.';
      } else {
        throw 'Server Error: ${response.statusCode}';
      }
    } catch (e) {
      // print('Repo Error: $e');
      throw 'Failed to load data: $e';
    }
  }
}
