


import 'package:assignment1/ArticleWIdget/Article.dart';
import 'package:assignment1/ArticleWIdget/ShimmerComponents/ArticleListShimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


import 'appbar.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, ),
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: BlocProvider(
            create: (context) => ArticleBloc()..add(FetchArticles()),
            child: ArticleScreen()
        )
    );
  }
}

class ArticleScreen extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text('Headlines News', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Read Top News Today', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(3),
            child: Image.asset("assets/newspaper.png", height: 100, width: 100,),),],
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state){
            if (state is ArticleLoading){
              return ArticleListShimmer();
            } else if (state is ArticleLoaded){
              List<Article> articles = state.article;
              return ArticleList(articles: articles);
            } else if (state is ArticleError) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text("Press button to fetch Articles"));
          }),

    );
  }
}