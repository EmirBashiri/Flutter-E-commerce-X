part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<ProductEntity> productList;

  FavoriteSuccess(this.productList);
}

class FavoriteEmpty extends FavoriteState {}
