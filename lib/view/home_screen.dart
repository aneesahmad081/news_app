import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/view/category_screen.dart';

import 'package:news_app/view/newsdetailScreen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, espnNews, wired, abcNews }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
          },
          icon: Image.asset('images/category_icon.png', height: 30, width: 30),
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            iconColor: Colors.black,
            onSelected: (FilterList item) {
              selectedMenu = item;
              switch (item) {
                case FilterList.bbcNews:
                  name = 'bbc-news';
                  break;
                case FilterList.aryNews:
                  name = 'ary-news';
                  break;
                case FilterList.espnNews:
                  name = 'espn';
                  break;
                case FilterList.wired:
                  name = 'wired';
                  break;
                case FilterList.abcNews:
                  name = 'abc-news';
                  break;
              }
              setState(() {});
            },
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem(
                value: FilterList.aryNews,
                child: Text('ARY News'),
              ),
              const PopupMenuItem(
                value: FilterList.espnNews,
                child: Text('ESPN'),
              ),
              const PopupMenuItem(
                value: FilterList.wired,
                child: Text('Wired'),
              ),
              const PopupMenuItem(
                value: FilterList.abcNews,
                child: Text('ABC News'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<NewsChannelsHeadlinesModel>(
            future: NewsViewModel.fetchNewsModelsHeadlinesApi(name),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 250,
                  child: Center(child: Spinkit2),
                );
              } else if (snapshot.hasError) {
                return SizedBox(
                  height: 250,
                  child: Center(child: Text("Error: \${snapshot.error}")),
                );
              } else if (!snapshot.hasData || snapshot.data!.articles == null) {
                return const SizedBox(
                  height: 250,
                  child: Center(child: Text("No news available")),
                );
              }

              final articles = snapshot.data!.articles!;

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    final dateTime = DateTime.tryParse(
                      article.publishedAt ?? '',
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(article: article),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: width * 0.9,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child:
                                    (article.urlToImage != null &&
                                        article.urlToImage!.isNotEmpty)
                                    ? CachedNetworkImage(
                                        imageUrl: article.urlToImage!,
                                        width: width * 0.9,
                                        height: height * 0.6,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Spinkit2,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                      )
                                    : Container(
                                        width: width * 0.9,
                                        height: height * 0.6,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    width: width * 0.8,
                                    padding: const EdgeInsets.all(12),
                                    height: height * .22,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              article.source?.name ?? '',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            if (dateTime != null)
                                              Text(
                                                format.format(dateTime),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: NewsViewModel.fetchNewsByCategoryStatic('general'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Spinkit2);
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: \${snapshot.error}"));
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null) {
                  return const Center(child: Text("No general news available"));
                }

                final articles = snapshot.data!.articles!;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    final date = DateTime.tryParse(article.publishedAt ?? '');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  NewsDetailScreen(article: article),
                            ),
                          );
                        },
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
                        subtitle: date != null
                            ? Text(format.format(date))
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const Spinkit2 = SpinKitFadingCircle(size: 50, color: Colors.amberAccent);
