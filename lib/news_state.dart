abstract class NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<dynamic> articles;
  NewsLoadedState(this.articles);
}

class NewsErrorState extends NewsState {
  final String errorMessage;
  NewsErrorState(this.errorMessage);
}
