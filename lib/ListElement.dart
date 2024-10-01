import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Post.dart';
import 'package:http/http.dart' as http;

class ListElement extends StatelessWidget {
  Future<List<Post>> fetchAllPosts() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.org/posts"));
    print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: fetchAllPosts(),
        builder: (context, snap) {
          if (snap.hasData) {
            ListView.builder(itemBuilder: (context, index) {
              return Card(
                key: ValueKey(index),
                child: ListTile(
                  leading: Image.network(snap.data![index].image),
                  title: Text(snap.data![index].title),
                  subtitle: Text(
                    snap.data![index].content,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            });
          } else if (snap.hasError) {
            return Text('error in fetch');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );

    // ListView.builder(itemCount: 100,itemBuilder: (context,index){
    //   return ListElement();}),);
  }
}
