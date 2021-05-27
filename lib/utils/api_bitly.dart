import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../PRIVATE.dart';

class BitlyApi {
  static Future shorten({String url}) async {
    var _jsonBody = {
      "long_url": url,
      "domain": "bit.ly",
      "group_guid": "Bl4628jEmC1"
    };
    //TODO: jadikan url to vriable (boleh guna URI)
    var apiResponse = await Dio().post('https://api-ssl.bitly.com/v4/shorten',
        options: Options(
          headers: {
            'Authorization': 'Bearer $kBitlyApiToken',
            Headers.contentTypeHeader: Headers.jsonContentType
          },
        ),
        data: _jsonBody);

    switch (apiResponse.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
        var decoded = json.decode(apiResponse.toString());

        return decoded["id"];

        break;
      default:
        String errMessage =
            'Error: ${apiResponse.statusCode}: ${apiResponse.statusMessage}';
        Fluttertoast.showToast(msg: errMessage);
        throw errMessage;
    }
  }

  static Future clickSummary({String url}) async {
    var apiResponse = await Dio().get(
        'https://api-ssl.bitly.com/v4/bitlinks/$url/clicks/summary',
        options: Options(headers: {'Authorization': 'Bearer $kBitlyApiToken'}));
    switch (apiResponse.statusCode) {
      case HttpStatus.ok:
        var decoded = json.decode(apiResponse.toString());
        return decoded["total_clicks"];
        break;
      default:
        Fluttertoast.showToast(
            msg:
                'Error: ${apiResponse.statusCode}: ${apiResponse.statusMessage}');
    }
  }
}
