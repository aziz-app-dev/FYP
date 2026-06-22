class CategoryStyle {
  final String? style; // 'style1', 'style2', 'style3'
  final String? layout; // 'horizontal', 'vertical'
  final int? columns; // default 2
  final bool? showIcons;
  final String? iconSize;

  CategoryStyle({
    this.style,
    this.layout,
    this.columns,
    this.showIcons,
    this.iconSize,
  });

  factory CategoryStyle.fromJson(Map<String, dynamic> json) => CategoryStyle(
    style: json["style"]?.toString() ?? 'style1',
    layout: json["layout"]?.toString() ?? 'horizontal',
    columns: json["columns"] is int
        ? json["columns"]
        : (json["columns"] != null
              ? int.tryParse(json["columns"].toString())
              : 2),
    showIcons: json["showIcons"] ?? true,
    iconSize: json["iconSize"]?.toString() ?? 'medium',
  );

  Map<String, dynamic> toJson() => {
    "style": style,
    "layout": layout,
    "columns": columns,
    "showIcons": showIcons,
    "iconSize": iconSize,
  };

  CategoryStyle copyWith({
    String? style,
    String? layout,
    int? columns,
    bool? showIcons,
    String? iconSize,
  }) {
    return CategoryStyle(
      style: style ?? this.style,
      layout: layout ?? this.layout,
      columns: columns ?? this.columns,
      showIcons: showIcons ?? this.showIcons,
      iconSize: iconSize ?? this.iconSize,
    );
  }
}

class CarouselStyle {
  final bool? autoPlay;
  final int? interval;
  final bool? showDots;
  final int? height;

  CarouselStyle({this.autoPlay, this.interval, this.showDots, this.height});

  factory CarouselStyle.fromJson(Map<String, dynamic> json) => CarouselStyle(
    autoPlay: json["autoPlay"],
    interval: json["interval"],
    showDots: json["showDots"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "autoPlay": autoPlay,
    "interval": interval,
    "showDots": showDots,
    "height": height,
  };
}
