import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/bitly_click_summary_model.dart';
import '../../model/bitly_shorten_model.dart';
import '../../constants.dart';
import '../../utils/api_bitly.dart';
import '../../utils/api_dynamic_link.dart';
import '../../utils/copy_link.dart';
import '../../utils/snackbar.dart';
import '../../utils/url_launcher.dart';
import '../widgets/reuseable.dart';
import '../screens/qr_code_page.dart';

var box = Hive.box(kMainBoxName);

class AdvancedLink extends StatelessWidget {
  const AdvancedLink(
      {Key? key, this.userInfo, this.uniqueLink, this.uniqueCode})
      : super(key: key);
  final DocumentSnapshot? userInfo;
  final String? uniqueLink;
  final String? uniqueCode;
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
          iconTheme: const IconThemeData(color: Colors.blueGrey),
          actionsIconTheme: const IconThemeData(color: Colors.blueGrey),
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Advanced',
            style: TextStyle(color: Colors.blueGrey.shade700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 500) {
                return Column(
                  children: [
                    Expanded(
                      child: FdlWidget(
                        uniqueLink: uniqueLink,
                        userInfo: userInfo,
                      ),
                    ),
                    const Divider(indent: 10, endIndent: 10),
                    Expanded(
                      child: BitlyWidget(
                        uniqueLink: uniqueLink,
                      ),
                    )
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: FdlWidget(
                        uniqueLink: uniqueLink,
                        userInfo: userInfo,
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: BitlyWidget(
                        uniqueLink: uniqueLink,
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class FdlWidget extends StatefulWidget {
  const FdlWidget({Key? key, required this.uniqueLink, required this.userInfo})
      : super(key: key);

  final String? uniqueLink;
  final DocumentSnapshot? userInfo;

  @override
  State<FdlWidget> createState() => _FdlWidgetState();
}

class _FdlWidgetState extends State<FdlWidget> {
  late bool _hasGeneratedFdlLink;
  String? _fdlLink;
  bool _waitForFdl = false;

  @override
  void initState() {
    super.initState();
    _hasGeneratedFdlLink = box.get(kHasFdlLink) ?? false;
    _fdlLink = box.get(kFdlLink) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Link with social preview',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        kIsWeb
            ? Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.all(12),
                child:
                    const Text('Firebase Dynamic Link not available on web.'),
              )
            : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () => launchURL(context, 'https://$_fdlLink'),
            child: LinkContainer(
                child: Text.rich(
              TextSpan(
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                  children: [
                    TextSpan(
                        text:
                            _fdlLink!.substring(0, _fdlLink!.indexOf('/') + 1)),
                    TextSpan(
                      text: _fdlLink!.substring(_fdlLink!.indexOf('/') + 1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    icon: const FaIcon(
                      FontAwesomeIcons.qrcode,
                      size: 14,
                    ),
                    label: const Text('QR Code')),
              ),
            ),
            Visibility(
              visible: _hasGeneratedFdlLink,
              child: CopyButton(url: 'https://$_fdlLink'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton.icon(
                onPressed: _waitForFdl
                    ? null
                    : _hasGeneratedFdlLink
                        ? () => Share.share(
                            'Visit my profile on https://$_fdlLink',
                            subject: 'My Flutree profile link')
                        : () async {
                            setState(() => _waitForFdl = true);
                            try {
                              String fdLink =
                                  await DynamicLinkApi.generateShortUrl(
                                      profileUrl: widget.uniqueLink!,
                                      userInfo: widget.userInfo
                                          as DocumentSnapshot<
                                              Map<String, dynamic>>);

                              setState(() {
                                _fdlLink = fdLink.substring(8);
                                _hasGeneratedFdlLink = true;
                                _waitForFdl = false;
                              });
                              box.put(kFdlLink, _fdlLink);
                              box.put(kHasFdlLink, _hasGeneratedFdlLink);
                            } catch (e) {
                              print(e);
                              setState(() => _waitForFdl = false);
                              CustomSnack.showErrorSnack(context,
                                  message:
                                      'Failed to build dynamic link. Error: $e');
                            }
                          },
                label: _waitForFdl
                    ? const LoadingIndicator()
                    : Text(_hasGeneratedFdlLink ? 'Share' : 'Generate'),
                icon: FaIcon(
                    _hasGeneratedFdlLink
                        ? FontAwesomeIcons.share
                        : FontAwesomeIcons.circleCheck,
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
  const BitlyWidget({Key? key, required this.uniqueLink}) : super(key: key);
  final String? uniqueLink;
  @override
  State<BitlyWidget> createState() => _BitlyWidgetState();
}

class _BitlyWidgetState extends State<BitlyWidget> {
  late bool _hasGeneratedBitlyLink;
  String? _bitlyLink;
  bool _waitForBitly = false;
  @override
  void initState() {
    super.initState();
    _hasGeneratedBitlyLink = box.get(kHasBitlyLink) ?? false;
    _bitlyLink = box.get(kBitlyLink) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Shorten link with Bitly',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () => launchURL(context, 'https://$_bitlyLink'),
            child: LinkContainer(
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 21),
                  children: [
                    TextSpan(
                        text: _bitlyLink!
                            .substring(0, _bitlyLink!.indexOf('/') + 1)),
                    TextSpan(
                      text: _bitlyLink!.substring(_bitlyLink!.indexOf('/') + 1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    const Text('Total clicks for past 30 days: '),
                    FutureBuilder(
                      future: BitlyApi.clickSummary(url: _bitlyLink),
                      builder: (context,
                          AsyncSnapshot<BitlyClickSummaryModel> snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                            'Failed to fetch metric data :(',
                          );
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.totalClicks.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return const LoadingIndicator();
                        }
                      },
                    )
                  ],
                ),
              )
            : const SizedBox.shrink(),
        Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            Visibility(
              visible: _hasGeneratedBitlyLink,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => QrPage(url: _bitlyLink),
                              fullscreenDialog: true),
                        ),
                    icon: const FaIcon(
                      FontAwesomeIcons.qrcode,
                      size: 14,
                    ),
                    label: const Text('QR Code')),
              ),
            ),
            Visibility(
              visible: _hasGeneratedBitlyLink,
              child: CopyButton(url: 'https://$_bitlyLink'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton.icon(
                onPressed: _waitForBitly
                    ? null
                    : _hasGeneratedBitlyLink
                        ? () => Share.share(
                            'Visit my Flutree profile on https://$_bitlyLink')
                        : () async {
                            bool? response = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      24.0, 20.0, 24.0, 8.0),
                                  content: const BitlyConsents(),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Agree to all'))
                                  ],
                                );
                              },
                            );
                            if (response ?? false) {
                              setState(() => _waitForBitly = true);
                              try {
                                BitlyShortenModel link = await BitlyApi.shorten(
                                    url: widget.uniqueLink);
                                setState(() {
                                  _bitlyLink = link.id;
                                  _hasGeneratedBitlyLink = true;
                                });
                                box.put(kHasBitlyLink, true);
                                box.put(kBitlyLink, _bitlyLink);
                              } catch (e) {
                                CustomSnack.showErrorSnack(context,
                                    message: 'Bitly error: $e');
                                rethrow;
                              }

                              setState(() => _waitForBitly = false);
                            } else {
                              return;
                            }
                          },
                label: _waitForBitly
                    ? const LoadingIndicator()
                    : Text(_hasGeneratedBitlyLink ? 'Share' : 'Shorten'),
                icon: FaIcon(
                    _hasGeneratedBitlyLink
                        ? FontAwesomeIcons.share
                        : FontAwesomeIcons.link,
                    size: 14),
              ),
            ),
            const SizedBox(width: 5),
          ],
        )
      ],
    );
  }
}

class BitlyConsents extends StatelessWidget {
  const BitlyConsents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MarkdownBody(
          data:
              'By using Bitly services, you agree to Bitly\'s [**Terms of Service**]($kBitlyTermsOfService) and [**Privacy Policy**]($kBitlyPrivacyPolicyLink).',
          onTapLink: (String text, String? href, String title) =>
              launchURL(context, href!),
          shrinkWrap: true,
        ),
      ],
    );
  }
}

class CopyButton extends StatelessWidget {
  const CopyButton({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: OutlinedButton.icon(
        onPressed: () => CopyLink.copy(url: url),
        label: const Text('Copy'),
        icon: const FaIcon(FontAwesomeIcons.copy, size: 14),
      ),
    );
  }
}
