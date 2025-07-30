import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi() async {
    final apiKey = dotenv.env['NEWS_API_KEY'];
    final url =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) print(response.body);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Failed to fetch BBC News');
    }
  }
}
