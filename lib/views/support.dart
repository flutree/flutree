import 'package:flutter/material.dart';
import 'package:linktree_iqfareez_flutter/utils/url_launcher.dart';

class Donate extends StatelessWidget {
  const Donate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Thank you for interest in supporting Flutree. '),
          OutlinedButton(
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(90)),
            onPressed: () {
              launchURL(context, 'https://exmaple.com');
            },
            child: Text('PayPal'),
          ),
        ],
      ),
    );
  }
}
