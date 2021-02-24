import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/utils/social_model.dart';

class SocialLists {
  static List<SocialModel> socialList = [
    SocialModel('WhatsApp',
        icon: FontAwesomeIcons.whatsapp, colour: Colors.teal.shade800),
    SocialModel('Telegram',
        icon: FontAwesomeIcons.telegram, colour: Colors.blue.shade800),
    SocialModel('Twitter',
        icon: FontAwesomeIcons.twitter, colour: Color(0xFF1da1f2)),
    SocialModel('Instagram',
        icon: FontAwesomeIcons.instagram, colour: Colors.orange.shade700),
    SocialModel('YouTube',
        icon: FontAwesomeIcons.youtube, colour: Color(0xFFF80000)),
    SocialModel('LinkedIn',
        icon: FontAwesomeIcons.linkedin, colour: Colors.blue.shade900)
  ];

  static SocialModel getSocial(String exactName) {
    return socialList.firstWhere(
        (element) => element.name.toLowerCase() == exactName.toLowerCase());
  }
}
