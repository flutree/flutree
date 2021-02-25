import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;
import 'package:linktree_iqfareez_flutter/utils/HexToColour.dart';
import 'package:linktree_iqfareez_flutter/utils/linkcard_model.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';
import 'package:linktree_iqfareez_flutter/utils/social_list.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/add_card.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/linkCard.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseable.dart';

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

  bool _isdpLoading = false;
  String _subtitleText;
  DocumentReference userDocument;
  File _image;

  @override
  void initState() {
    super.initState();
    mode = Mode.edit;
    userDocument = _firestoreInstance
        .collection('users')
        .doc(_authInstance.currentUser.uid.substring(0, 5));

    initFirestore();
  }

  void initFirestore() async {
    var snapshot = await userDocument.get();

    if (snapshot == null || !snapshot.exists) {
      print('Document not exist. Creating...');
      // Document with id == docId doesn't exist.
      userDocument.set({
        'authUid': _authInstance.currentUser.uid,
        'dpUrl': _authInstance.currentUser.photoURL ??
            'https://picsum.photos/seed/${_authInstance.currentUser.uid.substring(1, 6)}/200',
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
      userDocument.update({'dpUrl': url}).then((_) {
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
            maxHeight: 300);
        break;
      default:
        pickedFile = await picker.getImage(
            source: ImageSource.gallery,
            imageQuality: 70,
            maxWidth: 300,
            maxHeight: 300);
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
      bottomNavigationBar: Container(
        color: Colors.blueGrey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                });
              },
              label: Text('Log out'),
              icon: FaIcon(
                FontAwesomeIcons.signOutAlt,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.black87),
              onPressed: () {
                setState(() {
                  mode = mode == Mode.edit ? Mode.preview : Mode.edit;
                });
              },
              child: Text(mode == Mode.edit ? 'EDIT MODE' : 'PREVIEW'),
            ),
            TextButton.icon(
              onPressed: () {
                //TODO: Goto preview
              },
              label: Text('Guide'),
              icon: FaIcon(
                FontAwesomeIcons.question,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: userDocument.snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.exists) {
              print('Document exist: ${snapshot.data.data()}');

              _subtitleText = snapshot.data.data()['subtitle'] ??
                  'Something about yourself';
              _isShowSubtitle = snapshot.data.data()['showSubtitle'] ?? false;

              List<dynamic> socialsList = snapshot.data.data()['socials'];
              List<LinkCard> datas = [];
              for (var item in socialsList ?? []) {
                datas.add(LinkCard(
                    isEditing: mode == Mode.edit,
                    linkcardModel: LinkcardModel(item['exactName'],
                        displayName: item['displayName'], link: item['link'])));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 25.0),
                      GestureDetector(
                        onTap: mode == Mode.edit
                            ? () async {
                                int response = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
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
                                            trailing:
                                                FaIcon(FontAwesomeIcons.camera),
                                            onTap: () =>
                                                Navigator.of(context).pop(0),
                                          ),
                                          ListTile(
                                            title: Text('Gallery'),
                                            trailing:
                                                FaIcon(FontAwesomeIcons.images),
                                            onTap: () =>
                                                Navigator.of(context).pop(1),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                if (response != null) {
                                  getImage(response);
                                }
                              }
                            : null,
                        child: PressableDough(
                          child: CircleAvatar(
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
                            backgroundImage:
                                NetworkImage(snapshot.data.data()['dpUrl']),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.0),
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
                                                await userDocument.update({
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
                        child: Text('@${snapshot.data.data()['nickname']}',
                            style: TextStyle(fontSize: 22)),
                      ), //just a plain text
                      SizedBox(height: 5),
                      Visibility(
                        visible: (mode == Mode.edit) || _isShowSubtitle,
                        child: GestureDetector(
                          child: _isShowSubtitle
                              ? Text(_subtitleText)
                              : Text(
                                  'Add subtitle',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w100,
                                      decorationStyle:
                                          TextDecorationStyle.dotted),
                                ),
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
                                              await userDocument.update({
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
                                                    userDocument.update({
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
                                                    return;
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
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Delete ${linkcard.linkcardModel.displayName} ?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: OutlinedButton.icon(
                                                  icon: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      size: 14),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  label: Text('Cancel')),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: OutlinedButton.icon(
                                                  icon: FaIcon(
                                                      FontAwesomeIcons.trashAlt,
                                                      size: 14),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Colors.redAccent),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  label: Text('Delete')),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );

                              if (response ?? false) {
                                userDocument.update({
                                  'socials': FieldValue.arrayRemove(
                                      [linkcard.linkcardModel.toMap()])
                                });
                              }
                            },
                            onTap: () async {
                              LinkcardModel temp = linkcard.linkcardModel;

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

                                await userDocument.update({
                                  'socials': FieldValue.arrayRemove(
                                      [linkcard.linkcardModel.toMap()])
                                });
                                userDocument.update({
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
                              linkcardModel: linkcard.linkcardModel,
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
                                    userDocument.update({
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
                        child: datas.isNotEmpty && (mode == Mode.edit)
                            ? Text('Tap to edit, long press to delete')
                            : Container(),
                      )
                    ],
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text(snapshot.toString()),
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
