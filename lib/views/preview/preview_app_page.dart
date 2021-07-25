import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import '../../utils/linkcard_model.dart';
import '../../utils/social_list.dart';
import '../widgets/link_card.dart';

class PreviewAppPage extends StatefulWidget {
  const PreviewAppPage({Key key}) : super(key: key);
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
          padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25.0,
              ),
              const PressableDough(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/sample.jpg'),
                ),
              ),
              const SizedBox(
                height: 28.0,
              ),
              const PressableDough(
                child: Text('@fareeziqmal', style: TextStyle(fontSize: 20)),
              ), //just a plain text
              const SizedBox.shrink(),
              isShowSubtitle
                  ? const PressableDough(child: Text('IIUM'))
                  : const SizedBox.shrink(),
              const SizedBox(height: 25.0),
              //change or remove this part accordingly
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: SocialLists.socialList.length,
                itemBuilder: (context, index) {
                  return PressableDough(
                    child: LinkCard(
                      linkcardModel: LinkcardModel(
                          exactName: SocialLists.socialList[index].name,
                          displayName: SocialLists.socialList[index].name,
                          link: 'https://example.com'),
                      isSample: true,
                    ),
                  );
                },
              ),

              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
