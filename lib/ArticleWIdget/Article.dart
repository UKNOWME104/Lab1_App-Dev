import 'dart:convert';

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


abstract class ArticleEvent {}
class FetchArticles extends ArticleEvent{}

abstract class ArticleState{}
class ArticleInitial extends ArticleState{}
class ArticleLoading extends ArticleState{}

class ArticleLoaded extends ArticleState{
  final List<Article> article;
  ArticleLoaded(this.article);
}

class ArticleError extends ArticleState{
  final String error;
  ArticleError(this.error);
}

class ArticleBloc extends Bloc<ArticleEvent, ArticleState>{

  // Should be kept in an .env file but for the sake of demonstration its kept exposed here
  final APIKEY = 'de4c12ea15c4491198f156baaca879ca';

  ArticleBloc() : super(ArticleInitial()){
    on<FetchArticles>(_onFetchArticles);
  }

  Future<void> _onFetchArticles(
      FetchArticles event,
      Emitter<ArticleState> emit,
      ) async {
    emit(ArticleLoading());
    try{
      final response = await http.get(Uri.parse("https://newsapi.org/v2/top-headlines?country=us&apiKey=$APIKEY"));
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final articles =  (data['articles'] as List).map((article) => Article.fromJson(article)).toList();
        print(articles);
        emit(ArticleLoaded(articles));
      }
      else throw Exception("Failed to load posts");
    }
    catch (e){
      emit(ArticleError('Error: $e'));
    }
  }
}



class ArticleExpanded extends StatelessWidget {

  final Article article;
  ArticleExpanded({required this.article});

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(article.title ?? "", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            Container(height: 10,),
            Text("by ${article.author ?? "Unknown author"}"),
            Text("published on ${DateFormat("yyyy-MM-dd").format(DateTime.parse(article.publishedAt ?? ""))}"),
            Container(height: 10,),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(image: NetworkImage(article.urlToImage.toString()), errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),),),
            Container(height: 10,),
            Text(article.description ?? "No Description available", style: TextStyle(fontWeight: FontWeight.bold),),
            Container(height: 10,),
            Text(article.content ?? "No Content available"),
            Container(height: 10,),
            TextButton(onPressed: () async {
              if (!await launchUrl(Uri.parse(article.url ?? ""))) {
                throw Exception('Could not launch ${article.url}');
              }}
              , child: Text("Open Article"),
            )
          ],
        ),
      ),
    );
  }
}



class ArticleList extends StatelessWidget{
  final List<Article> articles;
  ArticleList({required this.articles});

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView.builder(
                cacheExtent: 9999,
                itemCount: articles.length,
                itemBuilder: (c, index){
                  Article article = articles[index];
                  return  ArticleTile(article: article);
                })
          // return Center(child: CircularProgressIndicator(),);
        ));
  }
}




class ArticleTile extends StatefulWidget {
  final Article article;
  ArticleTile({required this.article});

  State<StatefulWidget> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  @override
  Widget build(BuildContext context) {
    Article? article = widget.article;
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(15),
      // ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        shadowColor: Colors.orange,
        elevation: 3,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(context: context, isScrollControlled: true, enableDrag: true,
                showDragHandle: true, builder: (BuildContext context) {
                  return ArticleExpanded(article: article,);
                });
          },
          child: Container(
            child: ListTile(
              title: Text(article.title ?? "Unknown Title",
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  )),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.author ?? "Unknown Author"),
                  Text(DateFormat("yyyy-MM-dd")
                      .format(DateTime.parse(article.publishedAt ?? "Unknown Date"))),
                ],
              ),
              leading:Image(image: NetworkImage(article.urlToImage.toString()), height: 100, width: 100, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  height: 100,
                  width: 100,
                  child: Icon(Icons.broken_image, size: 50,),),
              ),
            ),),
        ),
      ),
    );
  }
}

class Article {
  String? author;
  String? title;
  String? publishedAt;
  String? urlToImage;
  String? url;
  String? description;
  String? content;

  Article({this.author, this.title, this.publishedAt, this.urlToImage, this.url, this.description, this.content});

  Article.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    title = json['title'];
    publishedAt = json['publishedAt'];
    urlToImage = json['urlToImage'];
    url = json['url'];
    description = json['description'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['title'] = this.title;
    data['publishedAt'] = this.publishedAt;
    data['urlToImage'] = this.urlToImage;
    data['url'] = this.url;
    data['description'] = this.description;
    data['content'] = this.content;
    return data;
  }
}