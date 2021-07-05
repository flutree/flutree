import 'package:flutter/cupertino.dart';

class LinkcardModel {
  String exactName;
  String displayName;
  String link;

  /// Exact name: 'WhatsApp', displayName: 'any', link: 'any'
  LinkcardModel(
      {@required this.exactName,
      @required this.displayName,
      @required this.link});

  Map<String, String> toMap() {
    return {'exactName': exactName, 'displayName': displayName, 'link': link};
  }
}
