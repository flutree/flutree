import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';
import 'package:linktree_iqfareez_flutter/views/auth/email_auth.dart';
import '../../constants.dart';
import '../../utils/url_launcher.dart';
import '../customizable/editing_page.dart';
import '../preview/ads_wrapper.dart';
import '../widgets/reuseable.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({Key key}) : super(key: key);
  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    GetStorage().erase(); //to make sure it sign in as a new user.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'dpImage',
                child: Image.asset(
                  'images/logo/applogo.png',
                  width: 100,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () {
                  // Page should slide right
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => const EmailAuth()));
                },
                icon: const FaIcon(FontAwesomeIcons.at, size: 15),
                label: const Text(
                  'Continue with email',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
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
                          final GoogleSignInAccount googleUser =
                              await GoogleSignIn().signIn();

                          // Obtain the auth details from the request
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;

                          // Create a new credential
                          final GoogleAuthCredential credential =
                              GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );

                          // Once signed in, return the UserCredential
                          await FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then(
                            (value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditPage(),
                                  ));
                            },
                          );
                        } on FirebaseAuthException catch (e) {
                          setState(() => _isGoogleLoading = false);
                          CustomSnack.showErrorSnack(context,
                              message: e.message);
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
              ),
              const SizedBox(height: 2),
              ElevatedButton.icon(
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
                  )),
              const SizedBox(height: 20),
              LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 600 && kIsWeb) {
                  return GestureDetector(
                    onTap: () => launchURL(context, kPlayStoreUrl),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Image.network(
                        'https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png',
                        width: 280,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
