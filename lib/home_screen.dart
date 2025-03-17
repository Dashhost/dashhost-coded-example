import 'dart:convert' show jsonDecode;

import 'package:dashhost_flutter/dashhost_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  String buildUrl() {
    return "https://api.artic.edu/api/v1/artworks?limit=100";
  }

  Future<Map<String, dynamic>> fetchCharacters() async {
    final url = buildUrl();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load character');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(color: Colors.blueGrey),
          title: const Text("Artwork DB", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.go('/about');
              },
              icon: const Icon(Icons.info_outline, color: Colors.white),
            ),
          ],
          elevation: 0,
        ),
      ),
      body: FutureBuilder(
        future: fetchCharacters(),

        builder: (context, snapshot) {
          return Container(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: Column(
              children: [
                DashMetaTag.title("Artwork DB"),
                DashMetaTag.description("Dashhost example app to utilize the revolutionary Flutter package dashhost_flutter"),
                Expanded(
                  child: ListView.builder(
                    itemCount: 826,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, i) {
                      if (snapshot.hasData) {
                        final index = i + 1;
                        final artwork = snapshot.data?['data'][index];
                        return GestureDetector(
                          onTap: () {
                            context.go('/artwork/${artwork['id']}');
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              title: Text(artwork['title'], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500)),
                              trailing: const Icon(Icons.chevron_right, color: Colors.white),
                              tileColor: Colors.white.withOpacity(0.05),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
