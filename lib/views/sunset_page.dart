import 'package:flutter/material.dart';
import 'package:linktree_iqfareez_flutter/utils/url_launcher.dart';

class SunsetPage extends StatelessWidget {
  const SunsetPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutree has been sunsetted. Thank you for your support. Until next time ;)',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
                onPressed: () {
                  launchURL(context, 'https://flutree.web.app/');
                },
                child: const Text('Read more...'))
          ],
        ),
      ),
    );
  }
}
