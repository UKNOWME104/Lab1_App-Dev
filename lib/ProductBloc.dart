import 'dart:convert';


import 'package:assignment1/products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

abstract class ProductEvent {}

class FetchProducts extends ProductEvent{}

abstract class ProductState{}
class ProductInitial extends ProductState{}
class ProductLoading extends ProductState{}

class ProductLoaded extends ProductState{
  final List<Product> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState{
  final String error;
  ProductError(this.error);
}

class ProductBloc extends Bloc<ProductEvent, ProductState>{
  ProductBloc() : super(ProductInitial()){
    on<FetchProducts>(_onFetchProducts);
  }
  Future<void> _onFetchProducts(
      FetchProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());
    try{
      final response = await http.get(Uri.parse("https://dummyjson.com/products"));
      if(response.statusCode == 200){
        List jsonResponse = jsonDecode(response.body)['products'];
        final products = jsonResponse.map((product) => Product.fromJson(product)).toList();
        emit(ProductLoaded(products));
      }
      else throw Exception("Failed to load posts");
    }
    catch (e){
      emit(ProductError('Error: $e'));
    }
  }
}