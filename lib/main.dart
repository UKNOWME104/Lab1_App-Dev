import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'news_api.dart'; // Import your news API service
import 'news_bloc.dart'; // Import your NewsBloc
import 'news_event.dart'; // Import your NewsEvent
import 'news_state.dart'; // Import your NewsState

void main() {
  runApp(const HeadlineNewsApp());
}

class HeadlineNewsApp extends StatelessWidget {
  const HeadlineNewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NewsBloc(NewsService())..add(FetchNews()),
        child: const HomePage(),
      ),
    );
  }
}

// Utility function to format date
String formatDate(String? dateInput) {
  if (dateInput == null) return 'Date Unavailable';
  try {
    final parsedDate = DateTime.parse(dateInput);
    return DateFormat('MMM dd, yyyy, h:mm a').format(parsedDate);
  } catch (error) {
    return 'Invalid Date Format';
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent, // Updated color scheme
        elevation: 2, // Slight shadow effect
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Latest Headlines",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for title
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Stay Updated Daily",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70, // Subtle text for subtitle
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(
              'assets/newspaper.png', // Ensure this asset exists
              height: 40,
              width: 40,
            ),
          ],
        ),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade400,
                  highlightColor: Colors.grey.shade200,
                  child: ListTile(
                    title: Container(height: 20, color: Colors.grey),
                    subtitle: Container(height: 15, color: Colors.grey),
                  ),
                );
              },
            );
          } else if (state is NewsLoadedState) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                String formattedDate = formatDate(article['publishedAt']);

                return Card(
                  key: ValueKey(index),
                  margin: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) => ArticleDetails(article: article),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  article['urlToImage'] ?? '',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 70,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'] ?? 'Title Missing',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      article['author'] ?? 'Anonymous',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      article['description'] != null &&
                                          article['description']!.length >
                                              60
                                          ? '${article['description']!.substring(0, 60)}...'
                                          : article['description'] ?? 'No Description',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is NewsErrorState) {
            return Center(child: Text(state.errorMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ArticleDetails extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleDetails({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article['urlToImage'] != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                article['urlToImage']!,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
            )
                : const Icon(Icons.broken_image, size: 100),
            const SizedBox(height: 10),
            Text(
              article['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              article['author'] ?? 'Unknown Author',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(article['content'] ?? 'Content Not Available'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
