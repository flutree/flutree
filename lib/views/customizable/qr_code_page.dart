import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../utils/url_launcher.dart';
import '../widgets/reuseable.dart';

class QrPage extends StatelessWidget {
  QrPage({this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        actionsIconTheme: IconThemeData(color: Colors.blueGrey),
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
          Spacer(),
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
          SizedBox(height: 10),
          LinkContainer(
            child: GestureDetector(
                onTap: () => launchURL(context, 'https://$url'),
                child: Text(
                  'https://$url',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decorationStyle: TextDecorationStyle.dotted,
                    decoration: TextDecoration.underline,
                  ),
                )),
          ),
          Spacer()
        ],
      ),
    );
  }
}
