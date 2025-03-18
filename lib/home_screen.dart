import 'dart:convert' show jsonDecode;

import 'package:dashhost_flutter/dashhost_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  String buildUrl() {
    return "https://api.artic.edu/api/v1/artworks?limit=100&fields=id,title,image_id";
  }

  Future<List<dynamic>> fetchArtworks() async {
    final url = buildUrl();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List<dynamic> items = result['data'];
      return items.where((item) => item['image_id'] != null).toList();
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
          title: const DashText("Artwork DB", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.push('/about');
              },
              icon: const Icon(Icons.info_outline, color: Colors.white),
            ),
          ],
          elevation: 0,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: Column(
          children: [
            DashMetaTag.title("Artwork DB"),
            DashMetaTag.description("Dashhost example app to utilize the revolutionary Flutter package dashhost_flutter"),
            Expanded(
              child: FutureBuilder(
                future: fetchArtworks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      DashRecorder().readyToCapture();
                    });

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      padding: const EdgeInsets.all(8.0),

                      itemBuilder: (context, index) {
                        final artwork = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            context.push('/artwork/${artwork['id']}');
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              title: DashText(artwork['title'], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500)),
                              trailing: const Icon(Icons.chevron_right, color: Colors.white),
                              tileColor: Colors.white.withValues(alpha: 0.05),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
