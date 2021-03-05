import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import '../../utils/linkcard_model.dart';
import '../widgets/linkCard.dart';

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

  Future<bool> popHandler() async {
    bool response = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Exit'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Yes'),
              ),
            ],
          );
        });

    return response ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: popHandler,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(34.0, 0, 34.0, 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 730) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildBasicInfo(),
                        SizedBox(height: 25.0),
                        buildSocialCardsList(),
                        SizedBox(height: 10),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(flex: 2, child: buildBasicInfo()),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 70.0),
                              child: buildSocialCardsList(),
                            ))
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView buildSocialCardsList() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: datas.isNotEmpty
          ? datas.map((linkcard) {
              return linkcard;
            }).toList()
          : [
              SelectableText(
                'Krik krik... Empty here.. 👀',
                textAlign: TextAlign.center,
              )
            ],
    );
  }

  Column buildBasicInfo() {
    return Column(
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
        SelectableText('@${widget.snapshot.data()['nickname']}',
            style: TextStyle(fontSize: 22)), //just a plain text
        SizedBox(height: 5),
        Visibility(
          visible: widget.snapshot.data()['showSubtitle'] ?? false,
          child: GestureDetector(
              child: SelectableText(widget.snapshot.data()['subtitle'] ??
                  'Something about yourself')),
        ),
      ],
    );
  }
}
