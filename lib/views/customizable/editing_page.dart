import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../../CONSTANTS.dart';
import '../../utils/linkcard_model.dart';
import '../../utils/snackbar.dart';
import '../../utils/url_launcher.dart';
import '../auth/signin.dart';
import '../widgets/link_card.dart';
import '../widgets/reuseable.dart';
import 'add_edit_card.dart';
import 'share_profile.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _bottomSheetStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)));
enum Mode { edit, preview }

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool _isShowSubtitle;
  Mode mode;
  final picker = ImagePicker();
  final FirebaseStorage _storageInstance = FirebaseStorage.instance;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final _authInstance = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _reportController = TextEditingController();
  String _userCode;
  bool _isdpLoading = false;
  String _subtitleText;
  DocumentReference _userDocument;
  CollectionReference _reportCollection;
  DocumentSnapshot _documentSnapshot;

  File _image;
  String _userImageUrl;
  @override
  void initState() {
    super.initState();
    mode = Mode.edit;
    _userCode = _authInstance.currentUser.uid.substring(0, 5);
    _userDocument = _firestoreInstance.collection('users').doc(_userCode);
    _reportCollection = _firestoreInstance.collection('reports');

    initFirestore();
  }

  void initFirestore() async {
    var snapshot = await _userDocument.get();

    if (snapshot == null || !snapshot.exists) {
      print('Document not exist. Creating...');
      // Document with id == docId doesn't exist.
      _userDocument.set({
        'creationDate': FieldValue.serverTimestamp(),
        'authUid': _authInstance.currentUser.uid,
        'dpUrl': _authInstance.currentUser.photoURL ??
            'https://picsum.photos/seed/$_userCode/200',
        'nickname': _authInstance.currentUser.displayName,
      });
    }
  }

  Future updateProfilePicture() async {
    String url;
    setState(() => _isdpLoading = true);
    Reference reference =
        _storageInstance.ref('userdps').child(_authInstance.currentUser.uid);

    try {
      await reference.putFile(_image);

      url = await reference.getDownloadURL();
      print('picture url is $url');
    } on FirebaseException catch (e) {
      print('Error: $e');
      setState(() => _isdpLoading = false);
      CustomSnack.showErrorSnack(context, message: 'Error: ${e.message}');
      return;
    } catch (e) {
      setState(() => _isdpLoading = false);
      print('Unknown error: $e');
      return;
    }

    try {
      _userDocument.update({'dpUrl': url}).then((_) {
        CustomSnack.showSnack(context, message: 'Profile picture updated');
        setState(() => _isdpLoading = false);
      });
    } on FirebaseException catch (e) {
      print('Error: $e');
      CustomSnack.showErrorSnack(context, message: 'Error: ${e.message}');
      setState(() => _isdpLoading = false);
    } catch (e) {
      CustomSnack.showErrorSnack(context,
          message: 'Unexpected error. Please try again.');
      print('ERROR SETTING PICTURE: $e');
      setState(() => _isdpLoading = false);
    }
  }

  Future getImage(int option) async {
    var pickedFile;
    switch (option) {
      case 0:
        pickedFile = await picker.getImage(
            source: ImageSource.camera,
            imageQuality: 70,
            maxWidth: 300,
            maxHeight: 200);
        break;
      default:
        pickedFile = await picker.getImage(
            source: ImageSource.gallery,
            imageQuality: 70,
            maxWidth: 300,
            maxHeight: 200);
        break;
    }

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      updateProfilePicture();
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        actionsIconTheme: IconThemeData(color: Colors.blueGrey),
        elevation: 0.0,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        title: Material(
          color: Colors.transparent,
          child: CupertinoSlidingSegmentedControl(
            groupValue: mode,
            padding: EdgeInsets.zero,
            children: {
              Mode.edit: Text('EDITING'),
              Mode.preview: Text('PREVIEW'),
            },
            onValueChanged: (value) {
              setState(() => mode = value);
            },
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LiveGuide(
                            userCode: _userCode,
                            docs: _documentSnapshot,
                          )));
            },
            label: Text('Share profile'),
            icon: FaIcon(
              FontAwesomeIcons.share,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'Logout':
                  await GetStorage().erase();
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                  break;
                case 'DeleteAcc':
                  showDialog(
                    context: context,
                    builder: (context) {
                      bool isLoading = false;
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            title: Text('Reset all data in this account'),
                            content:
                                Text('You\'ll be signed out automatically'),
                            actions: [
                              isLoading
                                  ? LoadingIndicator()
                                  : SizedBox.shrink(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              TextButton(
                                onPressed: () async {
                                  setDialogState(() => isLoading = true);
                                  try {
                                    _storageInstance
                                        .refFromURL(_userImageUrl)
                                        .delete();
                                  } catch (e) {
                                    print('Err: $e');
                                  }
                                  try {
                                    await _userDocument.delete();
                                    Navigator.pop(context); //pop the dialog
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignIn()));
                                  } on FirebaseException catch (e) {
                                    print('Firebase err: $e');
                                    CustomSnack.showErrorSnack(context,
                                        message: 'Error: ${e.message}');
                                    setDialogState(() => isLoading = false);
                                  } catch (e) {
                                    print('Unknown err: $e');
                                    CustomSnack.showErrorSnack(context,
                                        message: 'Error. Please try again');
                                    setDialogState(() => isLoading = false);
                                  }
                                },
                                child: Text(
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
                  break;
                case 'ProbReport':
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();

                  showDialog(
                    context: context,
                    builder: (context) {
                      bool _isReportLoading = false;
                      bool _includeEmail = true;
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.fromLTRB(
                                24.0, 20.0, 24.0, 1.0),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ReportTextField(
                                  reportController: _reportController,
                                  showAnonymousMessage: !_includeEmail,
                                ),
                                CheckboxListTile(
                                  value: _includeEmail,
                                  onChanged: (value) => setDialogState(
                                      () => _includeEmail = value),
                                  title: Text('  Include my email'),
                                  contentPadding: EdgeInsets.zero,
                                )
                              ],
                            ),
                            actions: [
                              _isReportLoading
                                  ? LoadingIndicator()
                                  : SizedBox.shrink(),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel')),
                              TextButton(
                                onPressed: () async {
                                  if (_reportController.text.isNotEmpty) {
                                    setDialogState(
                                        () => _isReportLoading = true);
                                    try {
                                      await _reportCollection.doc().set({
                                        'date reported':
                                            FieldValue.serverTimestamp(),
                                        'App Version': packageInfo.version,
                                        'Build Number': int.parse(
                                            packageInfo.buildNumber ?? '0'),
                                        'messsage: ':
                                            _reportController.text.trim(),
                                        'email': _includeEmail
                                            ? _authInstance.currentUser.email
                                            : null
                                      });
                                      setDialogState(
                                          () => _reportController.clear());
                                      Fluttertoast.showToast(
                                          msg: 'Report sent.');
                                      Navigator.pop(context); //pop the dialog

                                    } on FirebaseException catch (e) {
                                      print('Firebase err: $e');
                                      CustomSnack.showErrorSnack(context,
                                          message: 'Error: ${e.message}');
                                      setDialogState(
                                          () => _isReportLoading = false);
                                    } catch (e) {
                                      print('Unknown err: $e');
                                      CustomSnack.showErrorSnack(context,
                                          message: 'Error. Please try again');
                                      setDialogState(
                                          () => _isReportLoading = false);
                                    }
                                  }
                                },
                                child: Text(
                                  'Send',
                                  // style: TextStyle(color: Colors.red),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                  );

                  break;
              }
            },
            icon: FaIcon(
              FontAwesomeIcons.ellipsisV,
              size: 14,
              color: Colors.blueGrey,
            ),
            tooltip: 'Your account',
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Logout'),
                  value: 'Logout',
                ),
                PopupMenuItem(
                  value: 'ProbReport',
                  child: Text('Report a problem...'),
                ),
                PopupMenuItem(
                  value: 'DeleteAcc',
                  child: Text(
                    'Delete account data...',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _userDocument.snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.exists) {
              _documentSnapshot = snapshot.data;
              print('Document exist: ${snapshot.data.data()}');

              _subtitleText = snapshot.data.data()['subtitle'] ??
                  'Something about yourself';
              _isShowSubtitle = snapshot.data.data()['showSubtitle'] ?? false;
              _userImageUrl = snapshot.data.data()['dpUrl'];

              List<dynamic> socialsList = snapshot.data.data()['socials'];
              List<LinkcardModel> datas = [];
              for (var item in socialsList ?? []) {
                datas.add(LinkcardModel(item['exactName'],
                    displayName: item['displayName'], link: item['link']));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.0),
                      GestureDetector(
                        onTap: kIsWeb
                            ? () => CustomSnack.showSnack(context,
                                message:
                                    'Change image available only in Android App',
                                barAction: SnackBarAction(
                                    textColor: Colors.blueGrey.shade200,
                                    label: 'Get the app',
                                    onPressed: () {
                                      launchURL(context, kPlayStoreUrl);
                                    }))
                            : mode == Mode.edit
                                ? () async {
                                    int response = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ChooseImageDialog();
                                      },
                                    );
                                    if (response != null) {
                                      getImage(response);
                                    }
                                  }
                                : null,
                        child: PressableDough(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50.0,
                                child: _isdpLoading
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: CircularProgressIndicator(),
                                      )
                                    : null,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(_userImageUrl),
                              ),
                              mode == Mode.edit
                                  ? buildChangeDpIcon()
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      GestureDetector(
                        onTap: mode == Mode.edit
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    bool _isNicknameLoading = false;

                                    return StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return AlertDialog(
                                          title: Text('Change nickname'),
                                          content: NameTextField(
                                            nameController: _nameController,
                                            keyboardAction:
                                                TextInputAction.done,
                                          ),
                                          actions: [
                                            _isNicknameLoading
                                                ? LoadingIndicator()
                                                : SizedBox.shrink(),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                setDialogState(() =>
                                                    _isNicknameLoading = true);
                                                await _userDocument.update({
                                                  'nickname': _nameController
                                                      .text
                                                      .trim()
                                                });

                                                setState(() {
                                                  _isNicknameLoading = false;
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text('Confirm'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            : null,
                        child: Text(
                          '${snapshot.data.data()['nickname']}',
                          style: mode == Mode.preview
                              ? TextStyle(fontSize: 22)
                              : TextStyle(
                                  fontSize: 22,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted),
                        ),
                      ), //just a plain text
                      SizedBox(height: 5),
                      Visibility(
                        visible: (mode == Mode.edit) || _isShowSubtitle,
                        child: GestureDetector(
                          child: _isShowSubtitle
                              ? Text(_subtitleText,
                                  style: mode == Mode.edit
                                      ? dottedUnderlinedStyle()
                                      : null)
                              : Text('Add subtitle',
                                  style: dottedUnderlinedStyle()),
                          onTap: mode == Mode.edit
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      bool _isSubtitleLoading = false;

                                      return StatefulBuilder(
                                          builder: (context, setDialogState) {
                                        return AlertDialog(
                                          title: CheckboxListTile(
                                            title: Text('Subtitle'),
                                            value: _isShowSubtitle,
                                            onChanged: (value) async {
                                              setState(() =>
                                                  _isShowSubtitle = value);
                                              setDialogState(() {
                                                _isSubtitleLoading = true;
                                              });
                                              await _userDocument.update({
                                                'showSubtitle': _isShowSubtitle
                                              });
                                              setDialogState(() {
                                                print('finish udating');
                                                _isSubtitleLoading = false;
                                              });
                                            },
                                          ),
                                          content: Visibility(
                                            visible: _isShowSubtitle,
                                            child: SubtitleTextField(
                                              subsController:
                                                  _subtitleController,
                                            ),
                                          ),
                                          actions: [
                                            _isSubtitleLoading
                                                ? LoadingIndicator()
                                                : SizedBox.shrink(),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel')),
                                            TextButton(
                                                onPressed: () async {
                                                  if (_subtitleController
                                                      .text.isNotEmpty) {
                                                    setDialogState(() {
                                                      _isSubtitleLoading = true;
                                                    });
                                                    _userDocument.update({
                                                      'subtitle':
                                                          _subtitleController
                                                              .text
                                                    }).then((value) {
                                                      setState(() {
                                                        _subtitleText =
                                                            _subtitleController
                                                                .text;
                                                        Navigator.pop(context);
                                                      });
                                                    }).catchError(
                                                        (Object error) {
                                                      print(error);
                                                      setDialogState(() =>
                                                          _isSubtitleLoading =
                                                              false);
                                                    });
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text('Save')),
                                          ],
                                        );
                                      });
                                    },
                                  );
                                }
                              : null,
                        ),
                      ),

                      SizedBox(height: 25.0),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: datas.map((linkcard) {
                          return GestureDetector(
                            onLongPress: () async {
                              dynamic response = await showModalBottomSheet(
                                shape: _bottomSheetStyle,
                                context: context,
                                builder: (context) {
                                  return DeleteCardWidget(linkcard);
                                },
                              );

                              if (response ?? false) {
                                _userDocument.update({
                                  'socials':
                                      FieldValue.arrayRemove([linkcard.toMap()])
                                });
                              }
                            },
                            onTap: () async {
                              LinkcardModel temp = linkcard;

                              dynamic result = await showModalBottomSheet(
                                isScrollControlled: true,
                                shape: _bottomSheetStyle,
                                context: context,
                                builder: (context) {
                                  return AddCard(linkcardModel: temp);
                                },
                              );

                              if (result != null) {
                                print('Editing ${result.toMap()}');

                                await _userDocument.update({
                                  'socials':
                                      FieldValue.arrayRemove([linkcard.toMap()])
                                });
                                _userDocument.update({
                                  'socials':
                                      FieldValue.arrayUnion([result.toMap()])
                                }).then((value) {
                                  setState(() {});
                                }).catchError((Object error) {
                                  print(error);
                                  CustomSnack.showErrorSnack(context,
                                      message: 'Unable to sync');
                                });
                              }
                            },
                            child: LinkCard(
                              linkcardModel: linkcard,
                              isEditing: mode == Mode.edit,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      Visibility(
                        visible: mode == Mode.edit,
                        child: Transform.scale(
                          scale: 0.97,
                          child: DottedBorder(
                            dashPattern: [6, 5],
                            color: Colors.black54,
                            child: Card(
                              color: Theme.of(context).canvasColor,
                              margin: EdgeInsets.zero,
                              shadowColor: Colors.transparent,
                              child: ListTile(
                                onTap: () async {
                                  dynamic result = await showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: _bottomSheetStyle,
                                    context: context,
                                    builder: (context) {
                                      return AddCard();
                                    },
                                  );

                                  if (result != null) {
                                    print('Adding ${result.toMap()}');
                                    _userDocument.update({
                                      'socials': FieldValue.arrayUnion(
                                          [result.toMap()])
                                    }).then((value) {
                                      setState(() {});
                                    }).catchError((Object error) {
                                      print(error);
                                      CustomSnack.showErrorSnack(context,
                                          message: 'Unable to sync');
                                    });
                                  }
                                },
                                leading: FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.black54,
                                ),
                                title: Text(
                                  'Add card',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black54),
                                ),
                                trailing: Icon(null),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: datas.isNotEmpty
                            ? Text(
                                (mode == Mode.edit)
                                    ? 'Tap to edit, long press to delete'
                                    : 'Tap card to test link',
                                style: TextStyle(color: Colors.black87),
                              )
                            : SizedBox.shrink(),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Loading')
                    ]),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        'We have trouble connecting....\nIf the problem still persist, try log out and log in again',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      )
                    ]),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }
}

class DeleteCardWidget extends StatelessWidget {
  const DeleteCardWidget(
    this.linkcard, {
    Key key,
  }) : super(key: key);

  final LinkcardModel linkcard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete ${linkcard.displayName} ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.times, size: 14),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text('Cancel')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.trashAlt, size: 14),
                    style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    label: Text('Delete')),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}

class ChooseImageDialog extends StatelessWidget {
  const ChooseImageDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Choose source',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            title: Text(
              'Camera',
            ),
            trailing: FaIcon(FontAwesomeIcons.camera),
            onTap: () => Navigator.of(context).pop(0),
          ),
          ListTile(
            title: Text('Gallery'),
            trailing: FaIcon(FontAwesomeIcons.images),
            onTap: () => Navigator.of(context).pop(1),
          ),
        ],
      ),
    );
  }
}
