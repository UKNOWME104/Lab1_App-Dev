import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product{


  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
  });



  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      thumbnail: json['thumbnail'],
    );
  }
}

class ProductsList extends StatelessWidget{

  Future<List<Product>> fetchAllProducts() async{
    try{
      final response = await http.get(Uri.parse("https://dummyjson.com/products"));
      if(response.statusCode == 200){
        List jsonResponse = jsonDecode(response.body)['products'];
        return jsonResponse.map((product) => Product.fromJson(product)).toList();
      }
      else throw Exception("Failed to load posts");
    }
    catch(exp){
      throw Exception("Failed to load posts");
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(posts.toString());

    // Mock dataList
    // List<String> myProducts = ["hello", "hi"];
    // for (int i = 0; i < 100; i++)
    //   myProducts.add("hi" + i.toString());


    return Scaffold(
        body: Center(
            child: FutureBuilder(future: fetchAllProducts(), builder: (context, snap){
              if (snap.hasData){
                return
                  ListView.builder(
                    // the number of items in the list
                      itemCount: snap.data?.length,

                      // display each item of the product list
                      itemBuilder: (context, index) {
                        return Card(
                          // In many cases, the key isn't mandatory
                          key: ValueKey(snap.data?[index]),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snap.data![index].thumbnail),
                              ),
                              title: Text(snap.data![index].title),
                              subtitle: Column(children: [
                                Text((snap.data![index].description), overflow: TextOverflow.ellipsis,),
                                Text((snap.data![index].price.toString()), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), ),
                              ],)
                          ),
                        );
                      });
              }
              return Center(child: CircularProgressIndicator(),);
            })
        )
    );
  }


}