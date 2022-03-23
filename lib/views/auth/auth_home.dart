import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutree/utils/auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';

import '../../constants.dart';
import '../../utils/snackbar.dart';
import '../../utils/url_launcher.dart';
import '../preview/ads_wrapper.dart';
import '../profilebuilder/editing_page.dart';
import '../widgets/reuseable.dart';
import 'email_auth.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({Key? key}) : super(key: key);
  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    _clearHiveData();
  }

  ///to make sure it sign in as a new user.
  Future<void> _clearHiveData() async => await Hive.box(kMainBoxName).clear();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 450) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FlutreeLogo(),
                  emailButton(context),
                  const SizedBox(height: 8),
                  googleButton(context),
                  const SizedBox(height: kIsWeb ? 10 : 2),
                  previewButton(context),
                  const SizedBox(height: 20),
                  Column(
                    children: const [
                      PlayStoreButton(),
                    ],
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  const Expanded(child: FlutreeLogo()),
                  const VerticalDivider(
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        emailButton(context),
                        const SizedBox(height: 8),
                        googleButton(context),
                        const SizedBox(height: kIsWeb ? 10 : 2),
                        previewButton(context),
                        const SizedBox(height: 20),
                        Column(
                          children: const [
                            PlayStoreButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  ElevatedButton previewButton(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[350],
          onPrimary: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PreviewPage(),
              ));
        },
        icon: const FaIcon(FontAwesomeIcons.eye, size: 15),
        label: const Text(
          'Preview only',
          style: TextStyle(fontSize: 16),
        ));
  }

  ElevatedButton emailButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      onPressed: () {
        // Page should slide right
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (_) => const EmailAuth()));
      },
      icon: const FaIcon(FontAwesomeIcons.at, size: 15),
      label: const Text(
        'Continue with email',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget googleButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      onPressed: _isGoogleLoading
          ? null
          : () async {
              setState(() => _isGoogleLoading = true);
              try {
                // Trigger the authentication flow
                AuthHelper.signInWithGoogle().then(
                  (_) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditPage(),
                        ));
                  },
                );
              } on FirebaseAuthException catch (e) {
                setState(() => _isGoogleLoading = false);
                CustomSnack.showErrorSnack(context, message: e.message!);
              } catch (e) {
                CustomSnack.showErrorSnack(context,
                    message: 'Failed to Sign in. Please try again');
                setState(() => _isGoogleLoading = false);
                rethrow;
              }
            },
      icon: const FaIcon(FontAwesomeIcons.google, size: 15),
      label: _isGoogleLoading
          ? const LoadingIndicator()
          : const Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}

class FlutreeLogo extends StatelessWidget {
  const FlutreeLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logo/applogo.png',
      width: 100,
    );
  }
}

class PlayStoreButton extends StatelessWidget {
  const PlayStoreButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? GestureDetector(
            onTap: () => launchURL(context, kPlayStoreUrl),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Image.network(
                'https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png',
                width: 280,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
