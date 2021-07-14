import 'package:flutter/material.dart';

class HelpDialogs {
  static Widget editModehelpDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Help',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UnorderedListItem(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Tap the card',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' to edit.\n'),
              ],
            ),
          ),
          UnorderedListItem(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Swipe right',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' to delete card.\n'),
              ],
            ),
          ),
          UnorderedListItem(
            TextSpan(
              children: [
                TextSpan(text: 'To reoder/rearrange the card, turn on the'),
                TextSpan(
                    text: ' Reoder toggle button',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ', then hold and drag a card to desired position.\n'),
              ],
            ),
          ),
          UnorderedListItem(
            TextSpan(
              children: [
                TextSpan(text: 'Once you\'re done. Switch to '),
                TextSpan(
                    text: 'PREVIEW',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' mode to test the link (optional). Then tap on '),
                TextSpan(
                    text: 'Share profile',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' to get your profile link.\n'),
              ],
            ),
          ),
          Text('\nNote: Changes are saved and synced automatically.',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.teal)),
        ],
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

  static Widget previewModeHelpDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Help',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UnorderedListItem(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Tap card',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        ' open link. If some of the link didn\'t work as expected, you can edit the link by switching back to '),
                TextSpan(
                    text: 'EDITING',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' page.\n')
              ],
            ),
          ),
          UnorderedListItem(
            TextSpan(
              children: [
                TextSpan(text: 'Try to play around with the'),
                TextSpan(
                    text: ' Dough effect',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
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

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final TextSpan text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• "),
        Expanded(
          child: Text.rich(text),
        ),
      ],
    );
  }
}
