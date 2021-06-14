import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import '../../utils/linkcard_model.dart';
import '../../utils/social_list.dart';
import '../widgets/link_card.dart';

class PreviewAppPage extends StatefulWidget {
  @override
  _PreviewAppPageState createState() => _PreviewAppPageState();
}

class _PreviewAppPageState extends State<PreviewAppPage> {
  final bool isShowSubtitle = true;

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
              PressableDough(
                child: Text('@fareeziqmal', style: TextStyle(fontSize: 20)),
              ), //just a plain text
              SizedBox.shrink(),
              isShowSubtitle
                  ? PressableDough(child: Text('IIUM'))
                  : SizedBox.shrink(),
              SizedBox(height: 25.0),
              //change or remove this part accordingly
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: SocialLists.socialList.length,
                itemBuilder: (context, index) {
                  return LinkCard(
                    linkcardModel: LinkcardModel(
                        SocialLists.socialList[index].name,
                        displayName: SocialLists.socialList[index].name,
                        link: 'https://example.com'),
                    isSample: true,
                  );
                },
              ),

              SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
