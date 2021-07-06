import 'package:flutter/material.dart';

class HelpDialogs {
  static Widget editModehelpDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Help',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '• Tap card',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' to edit.\n'),
            TextSpan(
                text: '• Swipe right',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' to delete card.\n'),
            TextSpan(
                text:
                    '• To reoder/rearrange the card, turn on the Reoder toggle button'),
            TextSpan(
                text: ' Reoder toggle button',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text: ', then hold and drag a card to desired position.\n'),
            TextSpan(text: '• Once you\'re done. Switch to '),
            TextSpan(
                text: 'PREVIEW', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' mode to test the link (optional). Then tap on '),
            TextSpan(
                text: 'Share profile',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' to get your profile link.\n'),
            TextSpan(
                text: '\nNote: Changes are saved and synced automatically.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 2.0),
      actions: [
        TextButton(
          child: Text('Got it!\n'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  static Widget previewModehelpDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Help',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '• Tap card',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' open link.\n'),
            TextSpan(text: '• Try to play around with the '),
            TextSpan(
                text: ' Dough effect',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '.\n'),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 2.0),
      actions: [
        TextButton(
          child: Text('Got it!\n'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
