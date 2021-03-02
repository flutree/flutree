import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/linkcard_model.dart';
import '../../utils/social_list.dart';
import '../../utils/social_model.dart';
import '../../utils/urlLauncher.dart';

class LinkCard extends StatelessWidget {
  ///This linkcard will be the one showing in appPage
  LinkCard(
      {@required this.linkcardModel,
      this.isSample = false,
      this.isEditing = false});
  final LinkcardModel linkcardModel;
  final bool isSample;

  /// Block onPressed method. Enable overriding gesture from other widget. Defaulted to false
  final bool isEditing;

  final snackbar = SnackBar(
    // action: SnackBarAction(
    //   label: 'Info',
    //   onPressed: () {
    //     //TODO: put guide link
    //   },
    // ),
    content: Text(
        'To fully customize the app. Get the source code on for free Gumroad.'),
    behavior: SnackBarBehavior.floating,
  );

  @override
  Widget build(BuildContext context) {
    SocialModel socialModel = SocialLists.getSocial(linkcardModel.exactName);
    return PressableDough(
      child: Card(
        color: socialModel.colour,
        child: InkWell(
          splashColor: Colors.pink.withAlpha(10),
          onTap: !isEditing
              ? () {
                  !isSample
                      ? launchURL(context, linkcardModel.link)
                      : ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              : null,
          child: ListTile(
            leading: FaIcon(
              socialModel.icon,
              color: Colors.white,
            ),
            title: Text(
              linkcardModel.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(null), //to keep the text centered
          ),
        ),
      ),
    );
  }
}
