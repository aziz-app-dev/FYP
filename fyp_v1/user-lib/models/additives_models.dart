import 'dart:convert';

Additives additivesFromJson(String str) => Additives.fromJson(json.decode(str));

String additivesToJson(Additives data) => json.encode(data.toJson());

class Additives {
  final int id;
  final String title;
  final String price;

  Additives({
    required this.id,
    required this.title,
    required this.price,
  });

  factory Additives.fromJson(Map<String, dynamic> json) => Additives(
        id: json["id"],
        title: json["title"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
      };
}
