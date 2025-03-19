import 'dart:convert';
import 'package:dashhost_flutter/dashhost_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

String buildUrl(int number) {
  return "https://api.artic.edu/api/v1/artworks/$number?fields=id,title,image_id,credit_line,description,alt_image_ids";
}

Future<Map<String, dynamic>> fetchArtwork(int number) async {
  final url = buildUrl(number);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load artwork');
  }
}

class DetailScreen extends StatelessWidget {
  final int identifier;
  const DetailScreen({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchArtwork(identifier),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!['data'];

          if (data == null) {
            return Scaffold(appBar: AppBar(title: Text('Artwork $identifier')), body: const Center(child: Text("Error")));
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            DashRecorder().readyToCapture();
          });

          return Scaffold(
            appBar: AppBar(
              title: DashText(data['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              flexibleSpace: Container(color: Colors.blueGrey),

              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
            body: Container(
              color: Colors.blueGrey,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      DashMetaTag.title(data['title']),
                      DashMetaTag.image("https://www.artic.edu/iiif/2/${data['image_id']}/full/843,/0/default.jpg"),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          "https://www.artic.edu/iiif/2/${data['image_id']}/full/200,/0/default.jpg",
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      DashText(data['title'], style: Theme.of(context).textTheme.titleLarge, dashTag: "h1"),
                      SizedBox(height: 10),
                      DashText(data['credit_line'] ?? "", style: Theme.of(context).textTheme.labelLarge, dashTag: "p"),
                      SizedBox(height: 10),
                      DashText(
                        (data['description'] as String? ?? "").replaceAll("<p>", "").replaceAll('</p>', ""),
                        style: Theme.of(context).textTheme.labelLarge,
                        dashTag: "p",
                      ),
                      SizedBox(height: 6),
                      DashReady(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: DashText('Artwork $identifier', style: TextStyle(color: Colors.white)),
              flexibleSpace: Container(color: Colors.blueGrey),
            ),
            body: Container(
              color: Colors.blueGrey,
              child: const Center(child: DashText("Error", style: TextStyle(color: Colors.redAccent, fontSize: 24))),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: DashText('Artwork $identifier', style: TextStyle(color: Colors.white)),
            flexibleSpace: Container(color: Colors.blueGrey),
          ),
          body: Container(
            color: Colors.blueGrey,
            child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple))),
          ),
        );
      },
    );
  }
}
