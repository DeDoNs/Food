class InfoRest {

  String id;
  String imageRest, name, rating;

  InfoRest({required this.id, required this.imageRest, required this.name, required this.rating});

  factory InfoRest.fromJson(Map<String, dynamic> json){ return InfoRest(
          id: json['id'],
          imageRest: 'http://192.168.0.118/api_food/images/'+json['img_main'],
          name: json['name_info'],
          rating: json['rating']
      );}


}
