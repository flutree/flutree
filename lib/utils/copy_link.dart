import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CopyLink {
  static void copy({String? url}) {
    Clipboard.setData(ClipboardData(text: url))
        .then((value) => Fluttertoast.showToast(msg: 'Link copied!'));
  }
}
