import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:share_plus/share_plus.dart';
import '../../CONSTANTS.dart';
import '../../utils/urlLauncher.dart';
import '../widgets/reuseable.dart';

class LiveGuide extends StatefulWidget {
  LiveGuide(this.userCode);
  final String userCode;

  @override
  _LiveGuideState createState() => _LiveGuideState();
}

class _LiveGuideState extends State<LiveGuide> {
  final containerTextColour = Colors.blueGrey.shade100.withAlpha(105);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //to dismiss selectable text
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.blueGrey),
          actionsIconTheme: IconThemeData(color: Colors.blueGrey),
          elevation: 0.0,
          title: Text(
            'Share your Flutree profile',
            style: TextStyle(color: Colors.blueGrey.shade700),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                icon: FaIcon(FontAwesomeIcons.shareAlt),
                onPressed: () {
                  Share.share(
                      'Open http://$kWebappUrl on browser and enter the code: ${widget.userCode}',
                      subject: 'My Flutree code');
                })
          ],
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      infoWidget(),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 36),
                        child: buildDevicesImage(),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(child: infoWidget()),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: buildDevicesImage(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Image buildDevicesImage() {
    return Image.asset(
      'images/devices.png',
    );
  }

  Widget infoWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Go to page:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.blueGrey.shade100.withAlpha(105)),
          child: SelectableText(
            kWebappUrl,
            onTap: () => launchURL(context, 'http://$kWebappUrl'),
            style: TextStyle(fontSize: 32),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Then enter code:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: containerTextColour),
          child: SelectableText(
            widget.userCode ?? 'Error',
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.userCode))
                  .then((value) {
                Fluttertoast.showToast(msg: 'Copied');
              });
            },
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              letterSpacing: 10,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AssetGiffyDialog(
                    onlyOkButton: true,
                    onOkButtonPressed: () {
                      Navigator.pop(context);
                    },
                    image: Image.asset(
                      'images/intro.gif',
                    ),
                    title: Text(
                        'Try this out!\nSquishable (or dough effect) UI elements'),
                  );
                },
              );
            },
            child: Text(
              'Ask others to squish the cards 👀',
              style: dottedUnderlinedStyle(),
            ),
          ),
        ),
      ],
    );
  }
}
