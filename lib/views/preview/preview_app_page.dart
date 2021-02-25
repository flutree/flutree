import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;
import 'package:linktree_iqfareez_flutter/utils/social_list.dart';
import 'package:linktree_iqfareez_flutter/utils/social_model.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';
import 'package:linktree_iqfareez_flutter/views/preview/mock_data.dart';

import '../widgets/linkCard.dart';

class PreviewAppPage extends StatelessWidget {
  final bool isShowSubtitle = Constants.kShowSubtitleText;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                '@${Constants.kNickname}',
                style: TextStyle(fontSize: 20),
              ), //just a plain text
              SizedBox.shrink(),
              isShowSubtitle ? Text(Constants.kSubtitle) : SizedBox.shrink(),
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
                  int response = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Exit preview?'),
                        content: Text('You will be returned to sign in page'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(0);
                              },
                              child: Text('Yes, proceed.')),
                        ],
                      );
                    },
                  );
                  if (response == 0) {
                    //TODO: Show ads
                    FirebaseAuth.instance.signOut().then((_) => {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => SignIn()))
                        });
                  }
                },
                child: Text('Exit preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
