import 'dart:convert';

import 'package:api_integration/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostsModel> postList = [];
  Future<List<PostsModel>> getPostApi() async {
    try {
      final res = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        List<PostsModel> posts = [];
        for (Map<String, dynamic> i in data) {
          posts.add(PostsModel.fromJson(i));
        }
        postList = posts;
        return postList;
      } else {
        throw Exception('Failed to load data: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text("Api Course"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Loading..."),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading data : ${snapshot.error}"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Title",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(postList[index].title.toString()),
                              SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(postList[index].body.toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
