import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> gifsList = [];
  List<String> gifFavorites = [];
  bool isLoading = false;

  void getGifs() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(
      "https://api.giphy.com/v1/gifs/trending?api_key=71fZ8yW6a6Z4Au0WrG4LfOeD2BZsHvTp",
    );
    if (response.statusCode == 200) {
      final convertedToMap = json.decode(response.body);

      gifsList = convertedToMap["data"];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getGifs();
  }

  @override
  Widget build(BuildContext context) {
    print(isLoading);
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Gif"),
        centerTitle: true,
      ),
      /* -------------------------------------------------------------------------- */
      body: Visibility(
        visible: !isLoading,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ListView(
                  children: gifsList.map((e) {
                    return buildTile(
                        gifUrl: e["images"]["fixed_height"]["url"],
                        title: e["title"]);
                  }).toList(),
                ),
              ),
              Divider(
                height: 50,
                thickness: 2.5,
              ),
              /* -------------------------------------------------------------------------- */
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Favorite",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.star),
                        Spacer(),
                        FlatButton.icon(
                          onPressed: () {
                            setState(() {
                              gifFavorites.clear();
                            });
                          },
                          icon: Icon(Icons.delete),
                          label: Text(
                            "Clear All",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // gifFavorites.remove(gifFavorites[index]);
                                    //       || 
                                    gifFavorites.removeAt(index);
                                  });
                                  print(gifFavorites);
                                },
                                child: Image.network(gifFavorites[index],
                                    fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                        itemCount: gifFavorites.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        replacement: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Procurando...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            CircularProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation(Colors.orange.shade700),
            ),
          ],
        )),
      ),
    );
  }

  Widget buildTile({@required String gifUrl, @required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: () {
          setState(() {
            gifFavorites.add(gifUrl);
          });
        },
        title: Text(title),
        leading: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            gifUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
