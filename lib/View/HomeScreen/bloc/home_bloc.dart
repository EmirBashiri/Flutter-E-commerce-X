import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/ViewModel/Home/HomeRepository/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  HomeBloc({required this.homeRepository}) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      try {
        if (event is HomeStart) {
          emit(HomeLoading());
          final productList = await homeRepository.getProducts();
          emit.call(HomeSuccess(productList: productList));
        }
      } catch (e) {
        emit(HomeError());
      }
    });
  }
}
