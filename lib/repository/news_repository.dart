import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as htpp;
import 'package:news_app/models/news_channels_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=de3c9af50e3747b08d8b71baeb96ac95';

    final response = await htpp.get(Uri.parse(url));
    if (kDebugMode) print(response.body);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
