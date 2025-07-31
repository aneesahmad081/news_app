import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(
    String source,
  ) async {
    return await _rep.fetchNewsChannelsHeadlinesApi(source);
  }

  static Future<NewsChannelsHeadlinesModel> fetchNewsModelsHeadlinesApi(
    String source,
  ) {
    final viewModel = NewsViewModel();
    return viewModel.fetchNewsChannelsHeadlinesApi(source);
  }

  Future<NewsChannelsHeadlinesModel> fetchNewsByCategory(
    String category,
  ) async {
    return await _rep.fetchNewsByCategory(category);
  }

  static Future<NewsChannelsHeadlinesModel> fetchNewsByCategoryStatic(
    String category,
  ) {
    final viewModel = NewsViewModel();
    return viewModel.fetchNewsByCategory(category);
  }
}
