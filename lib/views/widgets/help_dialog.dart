import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpDialogs {
  static Widget editModehelpDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Help',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          UnorderedListItem('**Tap the card** to edit.'),
          UnorderedListItem('**Swipe right** to delete card.'),
          UnorderedListItem(
              'To reoder/rearrange the card, turn on the **Reoder toggle button**, then hold and drag a card to desired position.'),
          UnorderedListItem(
              'Once you\'re done. Switch to **PREVIEW** mode to test the link (optional). Then tap on **Share profile** to get your profile link.'),
          Text('\nNote: Changes are saved and synced automatically.',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.teal)),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 2.0),
      actions: [
        TextButton(
          child: const Text('Got it!\n'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  static Widget previewModeHelpDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Help',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          UnorderedListItem(
              '**Tap card** open link. If some of the link didn\'t work as expected, you can edit the link by switching back to **EDITING** page.\n'),
          UnorderedListItem('Try to play around with the **Dough effect**'),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 2.0),
      actions: [
        TextButton(
          child: const Text('Got it!\n'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.data, {Key? key}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("• "),
          Expanded(
            child: MarkdownBody(data: data),
          ),
        ],
      ),
    );
  }
}
