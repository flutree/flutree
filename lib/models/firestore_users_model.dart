class FirestoreUsersModel {
  String? name;
  Fields? fields;
  String? createTime;
  String? updateTime;

  FirestoreUsersModel(
      {this.name, this.fields, this.createTime, this.updateTime});

  FirestoreUsersModel.fromJson(Map<String, dynamic> json) {
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
  AuthUid? authUid;
  CreationDate? creationDate;
  Socials? socials;
  ShowSubtitle? showSubtitle;
  Nickname? nickname;
  Subtitle? subtitle;
  DpUrl? dpUrl;

  Fields(
      {this.authUid,
      this.creationDate,
      this.socials,
      this.showSubtitle,
      this.nickname,
      this.subtitle,
      this.dpUrl});

  Fields.fromJson(Map<String, dynamic> json) {
    authUid =
        json["authUid"] == null ? null : AuthUid.fromJson(json["authUid"]);
    creationDate = json["creationDate"] == null
        ? null
        : CreationDate.fromJson(json["creationDate"]);
    socials =
        json["socials"] == null ? null : Socials.fromJson(json["socials"]);
    showSubtitle = json["showSubtitle"] == null
        ? null
        : ShowSubtitle.fromJson(json["showSubtitle"]);
    nickname =
        json["nickname"] == null ? null : Nickname.fromJson(json["nickname"]);
    subtitle =
        json["subtitle"] == null ? null : Subtitle.fromJson(json["subtitle"]);
    dpUrl = json["dpUrl"] == null ? null : DpUrl.fromJson(json["dpUrl"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (authUid != null) data["authUid"] = authUid?.toJson();
    if (creationDate != null) {
      data["creationDate"] = creationDate?.toJson();
    }
    if (socials != null) data["socials"] = socials?.toJson();
    if (showSubtitle != null) {
      data["showSubtitle"] = showSubtitle?.toJson();
    }
    if (nickname != null) data["nickname"] = nickname?.toJson();
    if (subtitle != null) data["subtitle"] = subtitle?.toJson();
    if (dpUrl != null) data["dpUrl"] = dpUrl?.toJson();
    return data;
  }
}

class DpUrl {
  String? stringValue;

  DpUrl({this.stringValue});

  DpUrl.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}

class Subtitle {
  String? stringValue;

  Subtitle({this.stringValue});

  Subtitle.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}

class Nickname {
  String? stringValue;

  Nickname({this.stringValue});

  Nickname.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}

class ShowSubtitle {
  bool? booleanValue;

  ShowSubtitle({this.booleanValue});

  ShowSubtitle.fromJson(Map<String, dynamic> json) {
    booleanValue = json["booleanValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["booleanValue"] = booleanValue;
    return data;
  }
}

class Socials {
  ArrayValue? arrayValue;

  Socials({this.arrayValue});

  Socials.fromJson(Map<String, dynamic> json) {
    arrayValue = json["arrayValue"] == null
        ? null
        : ArrayValue.fromJson(json["arrayValue"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (arrayValue != null) data["arrayValue"] = arrayValue?.toJson();
    return data;
  }
}

class ArrayValue {
  List<Values>? values;

  ArrayValue({this.values});

  ArrayValue.fromJson(Map<String, dynamic> json) {
    values = json["values"] == null
        ? null
        : (json["values"] as List).map((e) => Values.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (values != null) {
      data["values"] = values?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Values {
  MapValue? mapValue;

  Values({this.mapValue});

  Values.fromJson(Map<String, dynamic> json) {
    mapValue =
        json["mapValue"] == null ? null : MapValue.fromJson(json["mapValue"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mapValue != null) data["mapValue"] = mapValue?.toJson();
    return data;
  }
}

class MapValue {
  Fields1? fields;

  MapValue({this.fields});

  MapValue.fromJson(Map<String, dynamic> json) {
    fields = json["fields"] == null ? null : Fields1.fromJson(json["fields"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fields != null) data["fields"] = fields?.toJson();
    return data;
  }
}

class Fields1 {
  Link? link;
  DisplayName? displayName;
  ExactName? exactName;

  Fields1({this.link, this.displayName, this.exactName});

  Fields1.fromJson(Map<String, dynamic> json) {
    link = json["link"] == null ? null : Link.fromJson(json["link"]);
    displayName = json["displayName"] == null
        ? null
        : DisplayName.fromJson(json["displayName"]);
    exactName = json["exactName"] == null
        ? null
        : ExactName.fromJson(json["exactName"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (link != null) data["link"] = link?.toJson();
    if (displayName != null) {
      data["displayName"] = displayName?.toJson();
    }
    if (exactName != null) data["exactName"] = exactName?.toJson();
    return data;
  }
}

class ExactName {
  String? stringValue;

  ExactName({this.stringValue});

  ExactName.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}

class DisplayName {
  String? stringValue;

  DisplayName({this.stringValue});

  DisplayName.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}

class Link {
  String? stringValue;

  Link({this.stringValue});

  Link.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}

class CreationDate {
  String? timestampValue;

  CreationDate({this.timestampValue});

  CreationDate.fromJson(Map<String, dynamic> json) {
    timestampValue = json["timestampValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["timestampValue"] = timestampValue;
    return data;
  }
}

class AuthUid {
  String? stringValue;

  AuthUid({this.stringValue});

  AuthUid.fromJson(Map<String, dynamic> json) {
    stringValue = json["stringValue"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["stringValue"] = stringValue;
    return data;
  }
}
