import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../CONSTANTS.dart';
import '../models/firestore_abuse_model.dart';
import '../utils/snackbar.dart';
import 'widgets/reuseable.dart';

enum AbuseType { nudity, hateViolence, spam, confidential }

const emphasisTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

class AbuseReport extends StatefulWidget {
  const AbuseReport({Key? key, this.profileLink}) : super(key: key);
  final String? profileLink;
  @override
  _AbuseReportState createState() => _AbuseReportState();
}

class _AbuseReportState extends State<AbuseReport> {
  AbuseType? _abuseType;
  late Map<String, String> _abuseMap;
  bool _isProcess = false;

  @override
  void initState() {
    super.initState();
    _abuseType = AbuseType.values.first;
    _abuseMap = {
      'Nudity':
          "We don't allow the sharing or publishing of content depicting nudity, graphic sex acts, or other sexually explicit material. We also don't allow content that drives traffic to commercial pornography sites or that promotes pedophilia, incest, or bestiality.\n\nWe have a zero tolerance policy towards content that exploits children. This means that we will terminate the accounts of any user we find sharing or publishing child sexual abuse imagery. We will also report the content and its owner to law enforcement.\n\nWe also do not allow the sharing or publishing of content that encourages or promotes sexual attraction towards children.",
      'Promotes hate, violence or illegal/offensive activities':
          "Users may not share or publish content that promotes hate or violence towards other groups based on race, ethnicity, religion, disability, gender, age, veteran status, or sexual orientation/gender identity. Please note that individuals are not considered a protected group.\n\nUsers may not share or publish crude content or violent content that is shockingly graphic.\n\nWe will also remove content that threatens, harasses or bullies other people or promotes dangerous and illegal activities.",
      'Spam, malware or "pishing" (fake login)':
          "We do not allow spamming or content that transmits viruses, causes pop-ups, attempts to install software with the user's consent, or otherwise impacts users with malicious code or scripts. Also, we do not allow phishing activity. Our products should also not be used to solicit or collect sensitive data, including but not limited to passwords, financial details, and social security numbers.",
      'Private and confidential information':
          "We do not allow the posting of another person's personal and confidential account or identification information. For example, we do not allow the sharing or publishing of another person's credit card number or account passwords."
    };
  }

  Future<void> _sendReport({
    required category,
  }) async {
    var abuseRef = Uri.parse('$kFirestoreDocRef/abuse');
    var abuseBody = FirestoreAbuseModel(
        fields: Fields(
            profileLink: ProfileLink(stringValue: widget.profileLink),
            category: Category(stringValue: category),
            timestamp: Timestamp(
                timestampValue: DateTime.now().toUtc().toIso8601String())));
    var jsonAbuseBody = jsonEncode(abuseBody);
    var response = await http.post(abuseRef, body: jsonAbuseBody);

    switch (response.statusCode) {
      case 200:
        return;
      default:
        throw response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Image.asset(
                  'images/logo/applogo.png',
                  fit: BoxFit.scaleDown,
                  width: 100,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Type of abuse',
                  style: emphasisTextStyle,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _abuseMap.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: AbuseType.values[index],
                    title: Text(
                      _abuseMap.keys.elementAt(index),
                      style: const TextStyle(fontSize: 16),
                    ),
                    groupValue: _abuseType,
                    onChanged: (AbuseType? value) =>
                        setState(() => _abuseType = value),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                  'Our policy on ${_abuseMap.keys.elementAt(_abuseType!.index).toLowerCase()}',
                  style: emphasisTextStyle),
              const SizedBox(height: 18),
              SelectableText(
                _abuseMap.values.elementAt(_abuseType!.index),
                style: const TextStyle(fontSize: 16),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'Profile link to be reported',
                  style: emphasisTextStyle,
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100),
                  child: SelectableText(widget.profileLink!)),
              const SizedBox(height: 23),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isProcess
                        ? null
                        : () async {
                            setState(() => _isProcess = true);
                            try {
                              await _sendReport(
                                  category: _abuseMap.keys
                                      .elementAt(_abuseType!.index));
                              CustomSnack.showSnack(context,
                                  message:
                                      'Thank your report. We will review your report as soon as possible',
                                  duration: const Duration(seconds: 5),
                                  barAction: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () =>
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar()));
                              setState(() => _isProcess = false);
                              Navigator.of(context).pop();
                            } catch (e) {
                              CustomSnack.showErrorSnack(context,
                                  message: 'Error: $e');
                              setState(() => _isProcess = false);
                            }
                          },
                    child: const Text(
                      'SUBMIT ABUSE REPORT',
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  _isProcess
                      ? const LoadingIndicator()
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 125),
            ],
          ),
        ),
      ),
    );
  }
}
