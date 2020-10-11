import 'package:dough/dough.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'appPage.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;

const firstRunKey = 'firstRun';

class BasicPage extends StatefulWidget {
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetStorage().read(firstRunKey) ?? showDialogIfFirstLoaded(context);
    });

    return Scaffold(
      body: AppPage(),
      floatingActionButton: PressableDough(
        child: FloatingActionButton(
          onPressed: openGumroadLink,
          backgroundColor: Colors.purple.shade800,
          tooltip: 'Get source code',
          mini: true,
          child: Icon(
            FontAwesomeIcons.github,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  openGumroadLink() {
    Fluttertoast.showToast(msg: 'Great!');
    launchURL(Constants.kLinkGumroad);
  }

  showDialogIfFirstLoaded(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        onlyOkButton: true,
        onOkButtonPressed: () {
          GetStorage().write(firstRunKey, false);
          Navigator.pop(context);
        },
        image: Image.asset('images/intro.gif'),
        title: Text('Try this!\nSquishable, doughy UI elements'),
      ),
      barrierDismissible: false,
    );
  }
}
