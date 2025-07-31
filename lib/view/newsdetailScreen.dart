import 'package:flutter/material.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final Articles article;
  final DateFormat format = DateFormat('MMMM dd, yyyy');

  NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(article.publishedAt ?? '');
    return Scaffold(
      appBar: AppBar(title: Text(article.source?.name ?? 'News')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              article.title ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (date != null)
              Text(
                format.format(date),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const Divider(height: 30),
            Text(
              article.description ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(article.content ?? '', style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
