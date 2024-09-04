import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JsonParsingScreen(),
    );
  }
}


class JsonParsingScreen extends StatelessWidget {

  final String jsonInput1 = '''
  [{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},
  [{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]
  ''';

  final String jsonInput2 = '''
  [{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},
  {"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},
  [{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]
  ''';

  const JsonParsingScreen({super.key});





  List<AndroidVersion> parseJson(String jsonString) {
    List<AndroidVersion> androidVersions = [];
    final parsedJson = jsonDecode(jsonString);

    for (var element in parsedJson) {
      if (element is Map) {
        element.forEach((key, value) {
          androidVersions.add(AndroidVersion(id: value['id'], title: value['title']));
        });
      } else if (element is List) {
        for (var item in element) {
          androidVersions.add(AndroidVersion(id: item['id'], title: item['title']));
        }
      }
    }

    return androidVersions;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Parsing Task'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                List<AndroidVersion> androidVersions = parseJson(jsonInput1);
                _showParsedData(context, androidVersions);
              },
              child: const Text('Parse JSON Input 1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                List<AndroidVersion> androidVersions = parseJson(jsonInput2);
                _showParsedData(context, androidVersions);
              },
              child: const Text('Parse JSON Input 2'),
            ),
          ],
        ),
      ),
    );
  }

  void _showParsedData(BuildContext context, List<AndroidVersion> androidVersions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Parsed Data'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: androidVersions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${androidVersions[index].title}'),
                  subtitle: Text('ID: ${androidVersions[index].id}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AndroidVersion {
  AndroidVersion({
    this.id,
    this.title,
  });

  int? id;
  String? title;
}
