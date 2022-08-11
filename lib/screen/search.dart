import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/recipe_model.dart';
import '../model/recipe_view.dart';

class Search extends StatefulWidget {
  String? query;

  Search({this.query, Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  List recipeCatList = [
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    }
  ];
  List<RecipeModel> recipeList = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.query.toString());
  }

  getData(String query) async {
    String url =
        'https://api.edamam.com/search?q=$query&app_id=8ba2c28c&app_key=447999a7b456b79ec6f69e0743a32341';
    Response response = await get(Uri.parse(url));
    Map Data = jsonDecode(response.body);
    print(Data);
    log(Data.toString());
    setState(() {
      Data["hits"].forEach((element) {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        log("Respe item Instanse" + recipeModel.toString());
      });
    });

    recipeList.forEach((Recipe) {
      print(Recipe.appLabel);
      print(Recipe.appCalries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff213750), Color(0xff071938)]),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    //This is Search  Container
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              print("Search Food Name");
                              print(searchController.text);

                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                return print('blank value');
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Search(
                                            query: searchController.text)));
                              }
                            },
                            child: Container(
                              child: Icon(
                                Icons.search_rounded,
                                color: Colors.blue,
                              ),
                              margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                            )),
                        Expanded(
                          child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Let's Cook Something")),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recipeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Recipe(recipeList[index].appUrl.toString())));
                                },
                                child: Card(
                                  margin: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '${recipeList[index].appImageUrl}',
                                          fit: BoxFit.cover,
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.black26),
                                            child: Text(
                                              "${recipeList[index].appLabel}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          )),
                                      Positioned(
                                        right: 0,
                                        child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .local_fire_department_outlined,
                                                      size: 20),
                                                  Text(
                                                      "${recipeList[index].appCalries}"
                                                          .substring(0, 6)),
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
              ],
            ),
          )
        ],
      ),
    );
  }
}
