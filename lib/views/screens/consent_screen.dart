import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linktree_iqfareez_flutter/constants.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({Key key}) : super(key: key);

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final Map<String, String> _items = {
    "No nudity, pornographic materials":
        "We don't allow the sharing or publishing of content depicting nudity, graphic sex acts, or other sexually explicit material. We also don't allow content that drives traffic to commercial pornography sites or that promotes pedophilia, incest, or bestiality.",
    "No promotes for hate, violence or illegal/offensive activities":
        'Users may not share or publish content that promotes hate or violence towards other groups based on race, ethnicity, religion, disability, gender, age, veteran status, or sexual orientation/gender identity.',
    "No spam, malware or 'pishing' (fake login)":
        "We do not allow spamming or content that transmits viruses, causes pop-ups, attempts to install software with the user's consent, or otherwise impacts users with malicious code or scripts. Also, we do not allow phishing activity.",
    "No sharing of private and confidential information":
        "We do not allow the posting of another person's personal and confidential account or identification information.",
  };
  final List<bool> _state = List.generate(4, (index) => false);
  //TODO: ^ Takpe ke final _state ni
  bool _countinueButtonActive = false;

  bool checkIfAllAreChecked() {
    int total = _items.entries.length;
    int counter = 0;

    for (var state in _state) {
      // check the value one by one
      if (state == true) {
        counter++;
      }
    }
    return counter == total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.gpp_maybe_outlined,
                    size: 90,
                    color: Colors.orangeAccent,
                  ),
                  const Text(
                    'Attention',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(
                      6.0,
                    ),
                    child: Text(
                      'To ensure safety for all users and visitors, please make sure your Flutree profile adhere to the following conditions. Failure to do so may result in content or/and account ban.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: _state[index],
                        onChanged: (newValue) {
                          setState(() {
                            _state[index] = newValue;
                            _countinueButtonActive = checkIfAllAreChecked();
                          });
                        },
                        title: Text(
                          _items.keys.elementAt(index),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          _items.values.elementAt(index),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Back')),
                        const SizedBox(width: 3),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                            ),
                            onPressed: _countinueButtonActive
                                ? () {
                                    GetStorage().write(kHasAgreeConsent, true);
                                    Navigator.pop(context, true);
                                  }
                                : null,
                            child: const Text('Continue')),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
