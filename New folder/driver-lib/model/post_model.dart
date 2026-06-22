import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  final int? postId;
  final int? id;
  final String? name;
  final String? email;
  final String? body;

  PostModel({this.postId, this.id, this.name, this.email, this.body});

  PostModel copyWith({
    int? postId,
    int? id,
    String? name,
    String? email,
    String? body,
  }) => PostModel(
    postId: postId ?? this.postId,
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    body: body ?? this.body,
  );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    postId: json["postId"],
    id: json["id"],
    name: json["name"],
    email: json["email"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "id": id,
    "name": name,
    "email": email,
    "body": body,
  };
}
