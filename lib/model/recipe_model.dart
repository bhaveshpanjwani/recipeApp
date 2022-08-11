class RecipeModel{
  String? appLabel;
  double? appCalries;
  String? appUrl;
  String? appImageUrl;
  RecipeModel({this.appLabel='Label',this.appCalries=0.00,this.appImageUrl='imageurl',this.appUrl='url'});

  factory RecipeModel.fromMap(Map recipe){
    return RecipeModel(
        appLabel: recipe["label"],
        appCalries: recipe["calories"],
        appImageUrl: recipe["image"],
        appUrl: recipe["url"]
    );
  }

}