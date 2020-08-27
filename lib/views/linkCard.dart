import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';

///This linkcard will be the one showing in appPage
class LinkCard extends StatelessWidget {
  LinkCard({this.icon, this.title, this.url, this.color});
  final IconData icon;
  final String title;
  final String url;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return PressableDough(
      child: Card(
        color: color,
        child: InkWell(
          splashColor: Colors.pink.withAlpha(10),
          onTap: () {
            launchURL(url);
          },
          child: ListTile(
            leading: FaIcon(
              icon,
              color: Colors.white,
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(null),
          ),
        ),
      ),
    );
  }
}
