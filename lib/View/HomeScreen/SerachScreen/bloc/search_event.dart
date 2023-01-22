part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class InitialSearchScreen extends SearchEvent {}

class SearchStart extends SearchEvent {
  final String searchKeyWord;

  SearchStart({required this.searchKeyWord});
}
