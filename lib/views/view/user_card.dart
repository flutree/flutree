import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/firestore_users_model.dart';
import '../support.dart';
import '../../CONSTANTS.dart';
import '../../utils/url_launcher.dart';
import '../report_abuse.dart';
import '../../utils/linkcard_model.dart';
import '../widgets/link_card.dart';

class UserCard extends StatefulWidget {
  const UserCard(this.snapshot, this.code, {Key? key}) : super(key: key);
  final FirestoreUsersModel snapshot;
  final String code;
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  List<LinkCard> datas = [];
  String? _profileLink;
  @override
  void initState() {
    super.initState();
    _profileLink = 'https://$kWebappUrl/${widget.code}';

    List<Values>? socialsList =
        widget.snapshot.fields?.socials?.arrayValue?.values;

    if (socialsList != null) {
      datas.addAll(
        socialsList.map(
          (e) => LinkCard(
            linkcardModel: LinkcardModel(
              e.mapValue?.fields?.exactName?.stringValue,
              displayName: e.mapValue?.fields?.displayName?.stringValue,
              link: e.mapValue?.fields?.link?.stringValue,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(34.0, 0, 34.0, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 730) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildBasicInfo(),
                      const SizedBox(height: 25.0),
                      buildSocialCardsList(),
                      footerButtons()
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 2, child: buildBasicInfo()),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 70.0),
                              child: buildSocialCardsList(),
                            ),
                          )
                        ],
                      ),
                      footerButtons()
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  ListView buildSocialCardsList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: datas.isNotEmpty
          ? datas
          : [
              const SelectableText(
                'Krik krik... Empty here.. 👀',
                textAlign: TextAlign.center,
              )
            ],
    );
  }

  Column buildBasicInfo() {
    return Column(
      children: [
        const SizedBox(height: 30.0),
        PressableDough(
          child: CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.transparent,
            backgroundImage:
                NetworkImage(widget.snapshot.fields!.dpUrl!.stringValue!),
          ),
        ),
        const SizedBox(height: 28.0),
        SelectableText('@${widget.snapshot.fields?.nickname?.stringValue}',
            style: const TextStyle(
              fontSize: 22,
            )),
        const SizedBox(height: 5),
        Visibility(
          visible: widget.snapshot.fields?.showSubtitle?.booleanValue ?? false,
          child: GestureDetector(
              child: SelectableText(
            widget.snapshot.fields?.subtitle?.stringValue ?? 'Flutree user',
            textAlign: TextAlign.center,
          )),
        ),
      ],
    );
  }

  Widget footerButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AbuseReport(profileLink: _profileLink))),
                icon: const FaIcon(
                  FontAwesomeIcons.exclamationTriangle,
                  size: 14,
                  semanticLabel: 'Report abuse',
                ),
                label: const Text('Report Abuse'),
              ),
              const SizedBox(width: 20),
              TextButton.icon(
                onPressed: () => launchURL(context, kDynamicLink),
                icon: const FaIcon(
                  FontAwesomeIcons.heart,
                  size: 14,
                  semanticLabel: 'Create your own profile',
                ),
                label: const Text(
                  'Made with Flutree',
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Donate())),
            icon: const FaIcon(
              FontAwesomeIcons.mugHot,
              size: 14,
              semanticLabel: 'Support',
            ),
            label: const Text('Buy me a coffee'),
          ),
        ],
      ),
    );
  }
}
