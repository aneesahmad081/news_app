import 'package:flutter/material.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/view/newsdetailScreen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final format = DateFormat('MMMM dd, yyyy');
  String selectedCategory = 'general';

  final List<Map<String, String>> categories = [
    {'title': 'General', 'value': 'general'},
    {'title': 'Business', 'value': 'business'},
    {'title': 'Technology', 'value': 'technology'},
    {'title': 'Entertainment', 'value': 'entertainment'},
    {'title': 'Health', 'value': 'health'},
    {'title': 'Science', 'value': 'science'},
    {'title': 'Sports', 'value': 'sports'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category['value'] == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChoiceChip(
                      label: Text(
                        category['title']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.deepPurple,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category['value']!;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: NewsViewModel.fetchNewsByCategoryStatic(
                  selectedCategory,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(color: Colors.blue, size: 40),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles == null) {
                    return Center(child: Text("No news found."));
                  }

                  final articles = snapshot.data!.articles!;
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final date = DateTime.parse(article.publishedAt!);

                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: article.urlToImage ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const SpinKitFadingCircle(
                            color: Colors.amber,
                            size: 30,
                          ),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                        title: Text(
                          article.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(format.format(date)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
