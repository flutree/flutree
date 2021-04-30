import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart';
import 'package:linktree_iqfareez_flutter/PRIVATE.dart';

class AdvancedLink extends StatefulWidget {
  AdvancedLink({this.userInfo, this.uniqueLink, this.uniqueCode});
  final DocumentSnapshot userInfo;
  final String uniqueLink;
  final String uniqueCode;
  @override
  _AdvancedLinkState createState() => _AdvancedLinkState();
}

class _AdvancedLinkState extends State<AdvancedLink> {
  DocumentReference _userData;
  bool _hasGeneratedFdlLink = false;
  bool _hasGeneratedBitlyLink = false;
  String _fdlLink;
  String _bitlyLink;

  @override
  void initState() {
    super.initState();
    _userData =
        FirebaseFirestore.instance.collection('links').doc(widget.uniqueCode);
    _hasGeneratedFdlLink = GetStorage().read(kHasFdlLink) != null;
    _fdlLink = GetStorage().read(kFdlLink) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.blueGrey),
          actionsIconTheme: IconThemeData(color: Colors.blueGrey),
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Advanced',
            style: TextStyle(color: Colors.blueGrey.shade700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Link with social meta tags',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            '$kPageUrl/ ',
                            style: TextStyle(
                                fontSize: 20,
                                textBaseline: TextBaseline.alphabetic),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            maxLength: 16,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          label: Text('Copy'),
                          icon: FaIcon(FontAwesomeIcons.copy, size: 14),
                        ),
                        SizedBox(width: 5),
                        SizedBox(width: 5),
                        ElevatedButton.icon(
                          onPressed: () {
                            // DynamicLinkParameters _parameters =
                            //     DynamicLinkParameters(
                            //         uriPrefix: 'https://flutree.web.app',
                            //         link: Uri.parse(widget.uniqueLink));
                            Fluttertoast.showToast(msg: 'hiihiiih');
                          },
                          label: Text(
                              _hasGeneratedFdlLink ? 'Refresh' : 'Generate'),
                          icon: FaIcon(
                              _hasGeneratedFdlLink
                                  ? FontAwesomeIcons.syncAlt
                                  : FontAwesomeIcons.checkCircle,
                              size: 14),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text('Bitly'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: Colors.blueGrey.shade100.withAlpha(105)),
                    child: Text.rich(
                      TextSpan(
                          style: TextStyle(
                            fontSize: 21,
                          ),
                          children: [
                            TextSpan(text: ''),
                            TextSpan(
                                text: _bitlyLink,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        label: Text('Copy'),
                        icon: FaIcon(FontAwesomeIcons.copy, size: 14),
                      ),
                      SizedBox(width: 5),
                      SizedBox(width: 5),
                      ElevatedButton.icon(
                        onPressed: _hasGeneratedBitlyLink
                            ? () {
                                // DynamicLinkParameters _parameters =
                                //     DynamicLinkParameters(
                                //         uriPrefix: 'https://flutree.web.app',
                                //         link: Uri.parse(widget.uniqueLink));
                                Fluttertoast.showToast(msg: 'Copy');
                              }
                            : () async {
                                var _jsonBody = {
                                  "long_url": widget.uniqueLink,
                                  "domain": "bit.ly",
                                  "group_guid": "Bl4628jEmC1"
                                };
                                var response = await Dio().post(
                                    'https://api-ssl.bitly.com/v4/shorten',
                                    options: Options(
                                      headers: {
                                        'Authorization':
                                            'Bearer $kBitlyApiToken',
                                        Headers.contentTypeHeader:
                                            'application/json'
                                      },
                                    ),
                                    data: _jsonBody);

                                print(response);

                                switch (response.statusCode) {
                                  case HttpStatus.ok:
                                  //TODO: Response message
                                  case HttpStatus.created:
                                    //TODO: Respomnse message
                                    var decoded =
                                        json.decode(response.toString());
                                    print(decoded);
                                    Fluttertoast.showToast(msg: decoded["id"]);
                                    Fluttertoast.showToast(
                                        msg: decoded["created_at"]);
                                    setState(() {
                                      _hasGeneratedBitlyLink = true;
                                      _bitlyLink = decoded["id"];
                                    });
                                    break;
                                  default:
                                    Fluttertoast.showToast(
                                        msg:
                                            'Error: ${response.statusCode}: ${response.statusMessage}');
                                }
                              },
                        label:
                            Text(_hasGeneratedBitlyLink ? 'Copy' : 'Shorten'),
                        icon: FaIcon(
                            _hasGeneratedBitlyLink
                                ? FontAwesomeIcons.copy
                                : FontAwesomeIcons.link,
                            size: 14),
                      ),
                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
