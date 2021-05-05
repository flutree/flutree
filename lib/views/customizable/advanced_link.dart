import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart';
import 'package:linktree_iqfareez_flutter/utils/api_bitly.dart';
import 'package:linktree_iqfareez_flutter/utils/api_dynamic_link.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';
import 'package:linktree_iqfareez_flutter/utils/url_launcher.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/qr_code_page.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseable.dart';
import 'package:share_plus/share_plus.dart';

class AdvancedLink extends StatelessWidget {
  AdvancedLink({this.userInfo, this.uniqueLink, this.uniqueCode});
  final DocumentSnapshot userInfo;
  final String uniqueLink;
  final String uniqueCode;
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
                child: FdlWidget(
                  uniqueLink: uniqueLink,
                  userInfo: userInfo,
                ),
              ),
              Divider(indent: 10, endIndent: 10),
              Expanded(
                child: BitlyWidget(
                  uniqueLink: uniqueLink,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FdlWidget extends StatefulWidget {
  FdlWidget({@required this.uniqueLink, @required this.userInfo});

  final String uniqueLink;
  final DocumentSnapshot userInfo;

  @override
  _FdlWidgetState createState() => _FdlWidgetState();
}

class _FdlWidgetState extends State<FdlWidget> {
  String _fdlLink;
  bool _hasGeneratedFdlLink;
  bool _waitForFdl = false;

  @override
  void initState() {
    super.initState();
    _hasGeneratedFdlLink = GetStorage().read(kHasFdlLink) ?? false;
    _fdlLink = GetStorage().read(kFdlLink) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Link with social meta tags',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () => launchURL(context, 'https://$_fdlLink'),
            child: LinkContainer(
                child: Text.rich(
              TextSpan(
                  style: TextStyle(
                    fontSize: 21,
                  ),
                  children: [
                    TextSpan(
                        text: _fdlLink.substring(0, _fdlLink.indexOf('/') + 1)),
                    TextSpan(
                      text: _fdlLink.substring(_fdlLink.indexOf('/') + 1),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
              textAlign: TextAlign.center,
            )),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: _hasGeneratedFdlLink,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => QrPage(url: _fdlLink),
                            fullscreenDialog: true),
                      );
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.qrcode,
                      size: 14,
                    ),
                    label: Text('QR Code')),
              ),
            ),
            Visibility(
              visible: _hasGeneratedFdlLink,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: 'https://$_fdlLink'))
                        .then((value) => Fluttertoast.showToast(msg: 'Copied'));
                  },
                  label: Text('Copy'),
                  icon: FaIcon(FontAwesomeIcons.copy, size: 14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton.icon(
                onPressed: _waitForFdl
                    ? null
                    : _hasGeneratedFdlLink
                        ? () {
                            Share.share('Visit my profile on https://$_fdlLink',
                                subject: 'My Flutree profile link');
                          }
                        : () async {
                            setState(() => _waitForFdl = true);
                            try {
                              String fdLink =
                                  await DynamicLinkApi.generateShortUrl(
                                      profileUrl: widget.uniqueLink,
                                      userInfo: widget.userInfo);

                              setState(() {
                                _fdlLink = fdLink.substring(8);
                                _hasGeneratedFdlLink = true;
                                _waitForFdl = false;
                              });
                              GetStorage().write(kFdlLink, _fdlLink);
                              GetStorage()
                                  .write(kHasFdlLink, _hasGeneratedFdlLink);
                            } catch (e) {
                              print(e);
                              CustomSnack.showErrorSnack(context,
                                  message:
                                      'Failed to build dynamic link. Error: $e');
                            }
                          },
                label: _waitForFdl
                    ? LoadingIndicator()
                    : Text(_hasGeneratedFdlLink ? 'Share' : 'Generate'),
                icon: FaIcon(
                    _hasGeneratedFdlLink
                        ? FontAwesomeIcons.share
                        : FontAwesomeIcons.checkCircle,
                    size: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BitlyWidget extends StatefulWidget {
  BitlyWidget({@required this.uniqueLink});
  final String uniqueLink;
  @override
  _BitlyWidgetState createState() => _BitlyWidgetState();
}

class _BitlyWidgetState extends State<BitlyWidget> {
  bool _hasGeneratedBitlyLink;
  String _bitlyLink;
  bool _waitForBitly = false;
  @override
  void initState() {
    super.initState();
    _hasGeneratedBitlyLink = GetStorage().read(kHasBitlyLink) ?? false;
    _bitlyLink = GetStorage().read(kBitlyLink) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Shorten link with Bitly',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () => launchURL(context, 'https://$_bitlyLink'),
            child: LinkContainer(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 21),
                  children: [
                    TextSpan(
                        text: _bitlyLink.substring(
                            0, _bitlyLink.indexOf('/') + 1)),
                    TextSpan(
                      text: _bitlyLink.substring(_bitlyLink.indexOf('/') + 1),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        _hasGeneratedBitlyLink
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total clicks for the past seven days: '),
                    FutureBuilder(
                      future: BitlyApi.clickSummary(url: _bitlyLink),
                      builder: (context, snapshot) {
                        print(snapshot.toString());
                        if (snapshot.hasError) {
                          return Text(
                            'Failed to fetch metric data :(',
                          );
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return LoadingIndicator();
                        }
                      },
                    )
                  ],
                ),
              )
            : SizedBox.shrink(),
        Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            Visibility(
              visible: _hasGeneratedBitlyLink,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => QrPage(url: _bitlyLink),
                            fullscreenDialog: true),
                      );
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.qrcode,
                      size: 14,
                    ),
                    label: Text('QR Code')),
              ),
            ),
            Visibility(
              visible: _hasGeneratedBitlyLink,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                            ClipboardData(text: 'https://$_bitlyLink'))
                        .then((value) => Fluttertoast.showToast(
                            msg: 'Copied link to clipboard.'));
                  },
                  label: Text('Copy'),
                  icon: FaIcon(FontAwesomeIcons.copy, size: 14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton.icon(
                onPressed: _waitForBitly
                    ? null
                    : _hasGeneratedBitlyLink
                        ? () {
                            Share.share(
                                'Visit my Flutree profile on https://$_bitlyLink');
                          }
                        : () async {
                            bool response = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      24.0, 20.0, 24.0, 8.0),
                                  content: Text.rich(
                                    TextSpan(
                                      text:
                                          'By using Bitly services, you agree to Bitly\'s ',
                                      children: [
                                        TextSpan(
                                            text: 'Terms of Service',
                                            style: linkTextStyle,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => launchURL(context,
                                                  kBitlyTermsOfService)),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                            text: 'Privacy Policy',
                                            style: linkTextStyle,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => launchURL(context,
                                                  kBitlyPrivacyPolicyLink)),
                                        TextSpan(text: '.')
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text('Agree all'))
                                  ],
                                );
                              },
                            );
                            if (response ?? false) {
                              setState(() {
                                _waitForBitly = true;
                              });
                              try {
                                var link = await BitlyApi.shorten(
                                    url: widget.uniqueLink);
                                setState(() {
                                  _bitlyLink = link;
                                  _hasGeneratedBitlyLink = true;
                                });
                                GetStorage().write(kHasBitlyLink, true);
                                GetStorage().write(kBitlyLink, _bitlyLink);
                              } catch (e) {
                                print(e);
                              }

                              setState(() {
                                _waitForBitly = false;
                              });
                            } else
                              return;
                          },
                label: _waitForBitly
                    ? LoadingIndicator()
                    : Text(_hasGeneratedBitlyLink ? 'Share' : 'Shorten'),
                icon: FaIcon(
                    _hasGeneratedBitlyLink
                        ? FontAwesomeIcons.share
                        : FontAwesomeIcons.link,
                    size: 14),
              ),
            ),
            SizedBox(width: 5),
          ],
        )
      ],
    );
  }
}
