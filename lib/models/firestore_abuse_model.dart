class FirestoreAbuseModel {
  String? name;
  Fields? fields;
  String? createTime;
  String? updateTime;

  FirestoreAbuseModel(
      {this.name, this.fields, this.createTime, this.updateTime});

  FirestoreAbuseModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    fields = json["fields"] == null ? null : Fields.fromJson(json["fields"]);
    createTime = json["createTime"];
    updateTime = json["updateTime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    if (fields != null) data["fields"] = fields?.toJson();
    data["createTime"] = createTime;
    data["updateTime"] = updateTime;
    return data;
  }
}

class Fields {
  ProfileLink? profileLink;
  Timestamp? timestamp;
  Category? category;

  Fields({this.profileLink, this.timestamp, this.category});

  Fields.fromJson(Map<String, dynamic> json) {
    profileLink = json["Profile Link"] == null
        ? null
        : ProfileLink.fromJson(json["Profile Link"]);
    timestamp = json["Timestamp"] == null
        ? null
        : Timestamp.fromJson(json["Timestamp"]);
    category =
        json["Category"] == null ? null : Category.fromJson(json["Category"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profileLink != null) {
      data["Profile Link"] = profileLink?.toJson();
    }
    if (timestamp != null) data["Timestamp"] = timestamp?.toJson();
    if (category != null) data["Category"] = category?.toJson();
    return data;
  }
}

class Category {
  String? stringValue;

  Category({this.stringValue});

  Category.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}

class Timestamp {
  String? timestampValue;

  Timestamp({this.timestampValue});

  Timestamp.fromJson(Map<String, dynamic> json) {
    timestampValue = json["timestampValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["timestampValue"] = timestampValue;
    return data;
  }
}

class ProfileLink {
  String? stringValue;

  ProfileLink({this.stringValue});

  ProfileLink.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}
