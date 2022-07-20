import 'package:firebase_core/firebase_core.dart';
import '../../model/my_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';
import '../../utils/auth_helper.dart';
import '../../utils/profile_builder_helper.dart';
import '../../utils/snackbar.dart';
import '../../utils/url_launcher.dart';
import '../auth/auth_home.dart';
import '../screens/donate.dart';
import '../widgets/reuseable.dart';

class ActionPopupMenu extends StatelessWidget {
  const ActionPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'Logout':
            await AuthHelper.googleSignOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AuthHome()));
            break;
          case 'dwApp':
            launchURL(context, kPlayStoreUrl);
            break;
          case 'DeleteAcc':
            var isDone = await showDialog<bool>(
              context: context,
              builder: (context) {
                bool isLoading = false;
                return StatefulBuilder(
                  builder: (context, setDialogState) {
                    return AlertDialog(
                      title: const Text('Reset all data in this account'),
                      content:
                          const Text('You\'ll be signed out automatically'),
                      actions: [
                        isLoading
                            ? const LoadingIndicator()
                            : const SizedBox.shrink(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                          onPressed: () async {
                            setDialogState(() => isLoading = true);
                            try {
                              await ProfileBuilderHelper.resetAccountData(
                                  MyUser.imageUrl!, MyUser.userDocument);
                              Navigator.pop(context, true); //pop the dialog
                            } on FirebaseException catch (e) {
                              CustomSnack.showErrorSnack(context,
                                  message: e.message ?? "Firebase Error");

                              Navigator.pop(context, false); //pop the dialog
                            }
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            );

            if (isDone ?? false) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const AuthHome()));
            }
            break;
          case 'Donate':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (builder) => Donate()));
        }
      },
      icon: const FaIcon(
        FontAwesomeIcons.ellipsisVertical,
        size: 14,
        color: Colors.blueGrey,
      ),
      tooltip: 'Your account',
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: 'Logout',
            child: Text('Log out'),
          ),
          if (kIsWeb)
            const PopupMenuItem(
              value: 'dwApp',
              child: Text('Download Android app...'),
            ),
          const PopupMenuItem(
            value: 'Donate',
            child: Text(
              'Support Flutree...',
            ),
          ),
          const PopupMenuItem(
            value: 'DeleteAcc',
            child: Text(
              'Delete account data...',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ];
      },
    );
  }
}
