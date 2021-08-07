import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/linkcard_model.dart';
import '../../utils/social_list.dart';
import '../../utils/social_model.dart';
import '../../utils/url_launcher.dart';

class LinkCard extends StatelessWidget {
  ///This linkcard will be the one showing in appPage
  const LinkCard({
    Key? key,
    required this.linkcardModel,
  }) : super(key: key);
  final LinkcardModel linkcardModel;

  @override
  Widget build(BuildContext context) {
    SocialModel socialModel = SocialLists.getSocial(linkcardModel.exactName);
    return PressableDough(
      child: Card(
        color: socialModel.colour,
        child: InkWell(
          splashColor: Colors.pink.withAlpha(10),
          onTap: () => launchURL(context, linkcardModel.link!),
          child: ListTile(
            mouseCursor: SystemMouseCursors.click,
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
      ),
    );
  }
}
