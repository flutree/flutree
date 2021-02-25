import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';

class LiveGuide extends StatelessWidget {
  LiveGuide(this.userCode);
  final String userCode;
  final containerTextColour = Colors.blueGrey.shade100.withAlpha(105);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Share your Flutree profile for others can see',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              Text(
                'Go to page:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: kWebappUrl));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.blueGrey.shade100.withAlpha(105)),
                  child: Text(
                    kWebappUrl,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Then enter code:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: userCode))
                      .then((value) {
                    CustomSnack.showSnack(context, message: 'Copied');
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: containerTextColour),
                  child: Text(
                    userCode ?? 'Error',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 10,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
