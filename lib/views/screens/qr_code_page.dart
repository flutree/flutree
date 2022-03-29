import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/url_launcher.dart';
import '../widgets/reuseable.dart';

class QrPage extends StatelessWidget {
  const QrPage({Key? key, this.url}) : super(key: key);
  final String? url;

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
          'QR Code',
          style: TextStyle(color: Colors.blueGrey.shade700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: QrImage(
                  data: 'https://$url',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LinkContainer(
              child: GestureDetector(
                  onTap: () => launchURL(context, 'https://$url'),
                  child: Text(
                    'https://$url',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      decorationStyle: TextDecorationStyle.dotted,
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
