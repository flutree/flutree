import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/url_launcher.dart';

class Donate extends StatelessWidget {
  Donate({Key? key}) : super(key: key);

  final _links = {
    'buymeacoffee': 'https://www.buymeacoffee.com/iqfareez',
    'paypal': 'https://paypal.me/iqfareez',
    'patreon': 'https://patreon.com/iqfareez',
    'getapp': 'https://flutree.page.link/getapp'
  };

  void copyToClipboard(String? link) {
    Clipboard.setData(ClipboardData(text: link))
        .then((value) => Fluttertoast.showToast(msg: 'Copied link'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        actionsIconTheme: const IconThemeData(color: Colors.blueGrey),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Support Flutree',
          style: TextStyle(color: Colors.blueGrey.shade700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              children: [
                const Text(
                    'Thank you for interest in supporting Flutree. Your support could help keep Flutree running for free and provide a better experience.'),
                const Text(
                    '\nYour support can be utilized in a number of way such as site hosting and maintainance.'),
                if (kIsWeb)
                  DonateCard(
                    label: 'Paypal',
                    link: _links['paypal']!.replaceAll("https://", ""),
                    onTapFun: () => launchURL(context, _links['paypal']!),
                    onLongTapFun: () => copyToClipboard(_links['paypal']),
                    faIcon: FontAwesomeIcons.paypal,
                  ),
                DonateCard(
                  link: _links['patreon']!.replaceAll("https://", ""),
                  faIcon: FontAwesomeIcons.patreon,
                  onTapFun: () => launchURL(context, _links['patreon']!),
                  onLongTapFun: () => copyToClipboard(_links['patreon']),
                  label: 'Patreon',
                ),
                DonateCard(
                    label: 'Buy me a coffee',
                    link: _links['buymeacoffee']!.replaceAll("https://", ""),
                    faIcon: FontAwesomeIcons.mugHot,
                    onTapFun: () => launchURL(context, _links['buymeacoffee']!),
                    onLongTapFun: () =>
                        copyToClipboard(_links['buymeacoffee'])),
                const Text(
                    '\nThe least thing you can do is to share this app among your family and friends.'),
                DonateCard(
                  label: 'Share the app',
                  link: _links['getapp']!.replaceAll("https://", ""),
                  faIcon: FontAwesomeIcons.shareNodes,
                  onTapFun: () => Share.share(
                      'Get Flutree now! Available on Android and web. ${_links['getapp']}'),
                  onLongTapFun: () => copyToClipboard(
                    _links['getapp'],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DonateCard extends StatelessWidget {
  const DonateCard({
    Key? key,
    required String label,
    required String? link,
    required IconData faIcon,
    required VoidCallback onTapFun,
    required VoidCallback onLongTapFun,
  })  : _link = link,
        _label = label,
        _faIcon = faIcon,
        _onTapFun = onTapFun,
        _onLongTapFun = onLongTapFun,
        super(key: key);

  final String? _link;
  final String _label;
  final IconData _faIcon;
  final VoidCallback _onTapFun;
  final VoidCallback _onLongTapFun;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onLongPress: _onLongTapFun,
        onTap: _onTapFun,
        child: ListTile(
          leading: FaIcon(_faIcon),
          title: Text(_label),
          subtitle: Text(_link!),
        ),
      ),
    );
  }
}
