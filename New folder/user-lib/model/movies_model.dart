import 'dart:convert';

MoviesModel moviesModelFromJson(String str) =>
    MoviesModel.fromJson(json.decode(str));

String moviesModelToJson(MoviesModel data) => json.encode(data.toJson());

class MoviesModel {
  final int? total;
  final int? page;
  final int? pages;
  final List<TvShow>? tvShows;

  MoviesModel({this.total, this.page, this.pages, this.tvShows});

  MoviesModel copyWith({
    int? total,
    int? page,
    int? pages,
    List<TvShow>? tvShows,
  }) => MoviesModel(
    total: total ?? this.total,
    page: page ?? this.page,
    pages: pages ?? this.pages,
    tvShows: tvShows ?? this.tvShows,
  );

  factory MoviesModel.fromJson(Map<String, dynamic> json) => MoviesModel(
    total: json["total"],
    page: json["page"],
    pages: json["pages"],
    tvShows:
        json["tv_shows"] == null
            ? []
            : List<TvShow>.from(
              json["tv_shows"]!.map((x) => TvShow.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "pages": pages,
    "tv_shows":
        tvShows == null
            ? []
            : List<dynamic>.from(tvShows!.map((x) => x.toJson())),
  };
}

class TvShow {
  final int? id;
  final String? name;
  final String? permalink;
  final DateTime? startDate;
  final dynamic endDate;
  final String? country;
  final String? network;
  final String? status;
  final String? imageThumbnailPath;

  TvShow({
    this.id,
    this.name,
    this.permalink,
    this.startDate,
    this.endDate,
    this.country,
    this.network,
    this.status,
    this.imageThumbnailPath,
  });

  TvShow copyWith({
    int? id,
    String? name,
    String? permalink,
    DateTime? startDate,
    dynamic endDate,
    String? country,
    String? network,
    String? status,
    String? imageThumbnailPath,
  }) => TvShow(
    id: id ?? this.id,
    name: name ?? this.name,
    permalink: permalink ?? this.permalink,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    country: country ?? this.country,
    network: network ?? this.network,
    status: status ?? this.status,
    imageThumbnailPath: imageThumbnailPath ?? this.imageThumbnailPath,
  );

  factory TvShow.fromJson(Map<String, dynamic> json) => TvShow(
    id: json["id"],
    name: json["name"],
    permalink: json["permalink"],
    startDate:
        json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"],
    country: json["country"],
    network: json["network"],
    status: json["status"],
    imageThumbnailPath: json["image_thumbnail_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "permalink": permalink,
    "start_date":
        "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": endDate,
    "country": country,
    "network": network,
    "status": status,
    "image_thumbnail_path": imageThumbnailPath,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
