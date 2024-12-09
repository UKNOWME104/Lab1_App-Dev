import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String apiUrl =
      'https://newsapi.org/v2/top-headlines?country=us';
  static const String apiKey = 'abb021fcd9124fe4a756d19365dc0136';

  // Fetch news articles from the API
  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse('$apiUrl&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
