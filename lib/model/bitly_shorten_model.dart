class BitlyShortenModel {
  String createdAt;
  String id;
  String link;
  List<dynamic> customBitlinks;
  String longUrl;
  bool archived;
  List<dynamic> tags;
  List<dynamic> deeplinks;
  References references;

  BitlyShortenModel(
      {this.createdAt,
      this.id,
      this.link,
      this.customBitlinks,
      this.longUrl,
      this.archived,
      this.tags,
      this.deeplinks,
      this.references});

  BitlyShortenModel.fromJson(Map<String, dynamic> json) {
    createdAt = json["created_at"];
    id = json["id"];
    link = json["link"];
    customBitlinks = json["custom_bitlinks"] ?? [];
    longUrl = json["long_url"];
    archived = json["archived"];
    tags = json["tags"] ?? [];
    deeplinks = json["deeplinks"] ?? [];
    references = json["references"] == null
        ? null
        : References.fromJson(json["references"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["created_at"] = createdAt;
    data["id"] = id;
    data["link"] = link;
    if (customBitlinks != null) {
      data["custom_bitlinks"] = customBitlinks;
    }
    data["long_url"] = longUrl;
    data["archived"] = archived;
    if (tags != null) {
      data["tags"] = tags;
    }
    if (deeplinks != null) {
      data["deeplinks"] = deeplinks;
    }
    if (references != null) {
      data["references"] = references.toJson();
    }
    return data;
  }
}

class References {
  String group;

  References({this.group});

  References.fromJson(Map<String, dynamic> json) {
    group = json["group"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["group"] = group;
    return data;
  }
}
