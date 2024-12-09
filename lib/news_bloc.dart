import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_api.dart'; // Reference to the API service
import 'news_event.dart'; // Import events
import 'news_state.dart'; // Import states

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService newsService;

  NewsBloc(this.newsService) : super(NewsLoadingState()) {
    on<FetchNews>((event, emit) async {
      emit(NewsLoadingState()); // Emit loading state
      try {
        final articles = await newsService.fetchNews();
        emit(NewsLoadedState(articles)); // Emit loaded state with articles
      } catch (error) {
        emit(NewsErrorState(error.toString())); // Emit error state with message
      }
    });
  }
}
