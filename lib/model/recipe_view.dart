import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Recipe extends StatefulWidget {

  String url;
  Recipe(this.url);

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  late final String finalUrl ;
  final Completer<WebViewController> controller = Completer<WebViewController>();
 @override
  void initState() {
    if(widget.url.toString().contains("http"))
      {
        finalUrl = widget.url.toString().replaceAll("http://", "https://");
      }
    else{
      finalUrl = widget.url;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Recipe'),
      ),
      body: Card(
        child: WebView(
          initialUrl: finalUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController){
            setState(() {
              controller.complete(webViewController);
            });
          } ,
        ),
      ),
    );
  }
}
