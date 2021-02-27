import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:linktree_iqfareez_flutter/views/preview/mock_data.dart';
import '../widgets/linkCard.dart';

class PreviewAppPage extends StatefulWidget {
  @override
  _PreviewAppPageState createState() => _PreviewAppPageState();
}

class _PreviewAppPageState extends State<PreviewAppPage> {
  final bool isShowSubtitle = true;

  Future<bool> _onExitPreview() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit preview?'),
          content: Text('You will be returned to sign in page'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  // showAds
                  Navigator.pop(context, true);
                },
                child: Text('Yes, proceed.')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExitPreview,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25.0,
                ),
                PressableDough(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('images/sample.jpg'),
                  ),
                ),
                SizedBox(
                  height: 28.0,
                ),
                Text(
                  '@fareeziqmal',
                  style: TextStyle(fontSize: 20),
                ), //just a plain text
                SizedBox.shrink(),
                isShowSubtitle ? Text('IIUM') : SizedBox.shrink(),
                SizedBox(
                  height: 25.0,
                ),
                //change or remove this part accordingly
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: PreviewMockData.mockData.length,
                  itemBuilder: (context, index) {
                    return LinkCard(
                      linkcardModel: PreviewMockData.mockData[index],
                      isSample: index.isEven,
                    );
                  },
                ),

                SizedBox(height: 60.0),
                TextButton(
                  onPressed: () async {
                    if (await _onExitPreview() ?? false) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Exit preview'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
