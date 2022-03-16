import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/linkcard_model.dart';
import '../../utils/social_list.dart';
import '../../utils/social_model.dart';
import '../../utils/url_launcher.dart';

class LinkCard extends StatelessWidget {
  ///This linkcard will be the one showing in appPage
  const LinkCard(
      {Key? key,
      required this.linkcardModel,
      this.isSample = false,
      this.isEditing = false})
      : super(key: key);
  final LinkcardModel linkcardModel;
  final bool isSample;

  /// Block onPressed method. Enable overriding gesture from other widget. Defaulted to false
  final bool isEditing;

  final snackbar = const SnackBar(
    content: Text(
        'To fully customize the card. Register or login with Flutree now.'),
  );

  @override
  Widget build(BuildContext context) {
    SocialModel socialModel = SocialLists.getSocial(linkcardModel.exactName);
    return Card(
      color: socialModel.colour,
      child: InkWell(
        splashColor: Colors.pink.withAlpha(10),
        onTap: !isEditing
            ? () {
                !isSample
                    ? launchURL(context, linkcardModel.link!)
                    : ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            : null,
        child: ListTile(
          leading: FaIcon(
            socialModel.icon,
            color: Colors.white,
          ),
          title: Text(
            linkcardModel.displayName!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(null), //to keep the text centered
        ),
      ),
    );
  }
}
