
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

    BitlyShortenModel({this.createdAt, this.id, this.link, this.customBitlinks, this.longUrl, this.archived, this.tags, this.deeplinks, this.references});

    BitlyShortenModel.fromJson(Map<String, dynamic> json) {
        this.createdAt = json["created_at"];
        this.id = json["id"];
        this.link = json["link"];
        this.customBitlinks = json["custom_bitlinks"] ?? [];
        this.longUrl = json["long_url"];
        this.archived = json["archived"];
        this.tags = json["tags"] ?? [];
        this.deeplinks = json["deeplinks"] ?? [];
        this.references = json["references"] == null ? null : References.fromJson(json["references"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data["created_at"] = this.createdAt;
        data["id"] = this.id;
        data["link"] = this.link;
        if(this.customBitlinks != null)
            data["custom_bitlinks"] = this.customBitlinks;
        data["long_url"] = this.longUrl;
        data["archived"] = this.archived;
        if(this.tags != null)
            data["tags"] = this.tags;
        if(this.deeplinks != null)
            data["deeplinks"] = this.deeplinks;
        if(this.references != null)
            data["references"] = this.references.toJson();
        return data;
    }
}

class References {
    String group;

    References({this.group});

    References.fromJson(Map<String, dynamic> json) {
        this.group = json["group"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data["group"] = this.group;
        return data;
    }
}