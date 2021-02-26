import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;
import 'package:linktree_iqfareez_flutter/utils/linkcard_model.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';
import 'package:linktree_iqfareez_flutter/utils/social_list.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/add_card.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/live_guide.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/linkCard.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseable.dart';

class UserCard extends StatefulWidget {
  UserCard(this.snapshot);
  final DocumentSnapshot snapshot;
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  List<LinkCard> datas = [];
  @override
  void initState() {
    super.initState();
    print('Document exist: ${widget.snapshot.data()}');

    List<dynamic> socialsList = widget.snapshot.data()['socials'];

    for (var item in socialsList ?? []) {
      datas.add(LinkCard(
          linkcardModel: LinkcardModel(item['exactName'],
              displayName: item['displayName'], link: item['link'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.0),
            PressableDough(
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.snapshot.data()['dpUrl']),
              ),
            ),
            SizedBox(height: 28.0),
            Text('@${widget.snapshot.data()['nickname']}',
                style: TextStyle(fontSize: 22)), //just a plain text
            SizedBox(height: 5),
            Visibility(
              visible: widget.snapshot.data()['showSubtitle'] ?? false,
              child: GestureDetector(
                  child: Text(widget.snapshot.data()['subtitle'] ??
                      'Something about yourself')),
            ),

            SizedBox(height: 25.0),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: datas.map((linkcard) {
                return LinkCard(
                  linkcardModel: linkcard.linkcardModel,
                );
              }).toList(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    )));
  }
}
