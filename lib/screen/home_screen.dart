import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/screen/search.dart';
import 'package:http/http.dart';

import '../model/recipe_view.dart';
class Homr_Screen extends StatefulWidget {


  @override
  State<Homr_Screen> createState() => _Homr_ScreenState();
}

class _Homr_ScreenState extends State<Homr_Screen> {
  bool isLoading= true;
  List recipeCatList = [{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"}];
  List<RecipeModel> recipeList = [];
  TextEditingController searchController = new TextEditingController();

  get index => null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData("Indian");

  }
  getData(String query)async{
    String url = 'https://api.edamam.com/search?q=$query&app_id=8ba2c28c&app_key=447999a7b456b79ec6f69e0743a32341';
    Response  response = await get(Uri.parse(url));
    Map Data = jsonDecode(response.body);
    print(Data);
    log(Data.toString());
    setState(() {
      Data["hits"].forEach((element){
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading=false;
        });
        log("Respe item Instanse"+recipeModel.toString());
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
                  colors: [
                    Color(0xff213750),
                    Color(0xff071938)
                  ]
              ),

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
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: (){
                              print("Search Food Name");
                              print(searchController.text);

                              if((searchController.text).replaceAll(" ", "")== ""){
                                return print('blank value');

                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Recipe(recipeList[index].appUrl.toString())));
                                
                              }
                            },
                            child: Container(child: Icon(Icons.search_rounded,color: Colors.blue,),margin: EdgeInsets.fromLTRB(3, 0, 7, 0),)),
                        Expanded(child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something")
                        ),),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("What Do You Want to Cook Today?",style: TextStyle(fontSize: 30 ),),
                      Text("Top Indian Dishes",style: TextStyle(fontSize: 20,color: Colors.white),)

                    ],
                  ),

                ),
                Container(
                    child: isLoading?CircularProgressIndicator():ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recipeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Recipe(recipeList[index].appUrl.toString())));

                            },
                            child: Card(
                              margin: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network('${recipeList[index].appImageUrl}',
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.black26
                                        ),
                                        child: Text("${recipeList[index].appLabel}",style: TextStyle(color: Colors.white,fontSize: 18),),
                                      )
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10)
                                            )
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.local_fire_department_outlined,size: 20),
                                              Text("${recipeList[index].appCalries}".substring(0,6)),
                                            ],
                                          ),
                                        )
                                    ),
                                  )
                                ],),
                            ),
                          );
                        })
                ),

                Container(
                  height: 100,
                  child: ListView.builder( itemCount: recipeCatList.length, shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){

                        return Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Recipe(recipeList[index].appUrl.toString())));
                              },
                              child: Card(
                                  margin: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0.0,
                                  child:Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(18.0),
                                          child: Image.network(recipeCatList[index]["imgUrl"], fit: BoxFit.cover,
                                            width: 200,
                                            height: 250,)
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    recipeCatList[index]["heading"],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  )
                              ),
                            )
                        );
                      }),
                )


              ],
            ),
          )
        ],
      ),
    );
  }
}
