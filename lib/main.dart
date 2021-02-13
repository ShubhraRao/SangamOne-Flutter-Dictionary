import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String url = ;
  String token = "YOUR API KEY";

  TextEditingController textEditingController = TextEditingController();

  List<dynamic> list;
  Map<String, dynamic> map;
  String text="Enter text";

  // int flag = 0;
  bool isLoading = false;
  bool noWordFound = false;

  fetchData() async {
    final response = await http.get(
        "https://owlbot.info/api/v4/dictionary/" + textEditingController.text,
        headers: {
          "Authorization": "Token 3fa2aa1918418b421556f2f0665829ccf12f3ca0"
        });

    if (response.statusCode == 200) {
      // list = (json.decode(response.body) as List);
      // if()
      print(response.body);
      map = json.decode(response.body);
      list = map["definitions"];
      print(list[0]["definition"]);
      print(response.body);
      print(list.length);
      // .map((data) => new LocModel.fromJson(data))
      // .toList();

      // print("fetched");
      // print(list);
      if (list.length != null) {
        setState(() {
          list = map["definitions"];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        noWordFound = true;
      });
      print(noWordFound);
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(list);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Dictionary",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12, bottom: 11.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.white),
                  child: TextFormField(
                    onChanged: (String text) {
                      setState(() {
                        noWordFound = false;
                        isLoading = true;
                      });
                      fetchData();
                      // if (_debounce?.isActive ?? false) _debounce.cancel();
                      // _debounce = Timer(const Duration(milliseconds: 1000), () {
                      //   searchText();
                      // });
                    },
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "Search for a word",
                      contentPadding: const EdgeInsets.only(left: 24.0),

                      // removing the input border
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  // searchText();
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(8),
          child:
              // StreamBuilder(
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.data == null) {
              //       return
              // Center(
              //         child: Text("Enter a search word"),
              //       // );
              //     }
              //     if (snapshot.data == "waiting") {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }

              // output
              // return
              (textEditingController.text.isEmpty) ? Text("Enter text") : (noWordFound) ? Text("No data found") : (isLoading) ? Center(child: CircularProgressIndicator()) : 


              // (textEditingController.text.isEmpty || flag == 0)
              //     ? Text(text)
              //     : (isLoading)
              //         ? Center(child: CircularProgressIndicator())
                      // : 
                      ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListBody(
                              children: [
                                Container(
                                  color: Colors.grey[300],
                                  child: ListTile(
                                    leading: (list[index]["image_url"] == null)
                                        ? null
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                list[index]["image_url"]),
                                          ),
                                    title: Text(map["word"]
                                        // Text(
                                        //     textEditingController.text.trim()
                                        +
                                        "(" +
                                        list[index]["type"] +
                                        ")"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(list[index]["definition"]),
                                )
                              ],
                            );
                          },
                        )),
    );
  }
}
