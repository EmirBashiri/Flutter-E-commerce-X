part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchingScreen extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {

}

class SearchSuccess extends SearchState {
  final List<ProductEntity> productList;

  SearchSuccess({required this.productList});
}

class SearchEmptyScreen extends SearchState {}
