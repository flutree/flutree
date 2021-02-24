import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;
import 'package:linktree_iqfareez_flutter/utils/HexToColour.dart';
import 'package:linktree_iqfareez_flutter/utils/linkcard_model.dart';
import 'package:linktree_iqfareez_flutter/utils/social_list.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/add_card.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/linkCard.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseable.dart';

const _bottomSheetStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)));

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool _isShowSubtitle = false;
  File _image;
  final picker = ImagePicker();
  final _authInstance = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _subtitleController = TextEditingController();
  bool _isLoading = false;
  String _subtitleText;
  List<LinkCard> datas;

  @override
  void initState() {
    super.initState();
    //Get data from collection here maybe
    datas = [];
  }

  Future getImage(int option) async {
    var pickedFile;
    switch (option) {
      case 0:
        pickedFile =
            await picker.getImage(source: ImageSource.camera, imageQuality: 60);
        break;
      default:
        pickedFile = await picker.getImage(
            source: ImageSource.gallery, imageQuality: 60);
        break;
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
              icon: FaIcon(FontAwesomeIcons.signOutAlt),
            ),
            Tooltip(
              child: Text('EDIT MODE'),
              message: 'Tap to edit, long tap on element to delete.',
            ),
            TextButton.icon(
              onPressed: () {
                //TODO: Goto preview
              },
              label: Text('Preview'),
              icon: FaIcon(
                FontAwesomeIcons.play,
                size: 14,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () async {
                    int response = await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
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
                      },
                    );

                    if (response == 0) {
                      getImage(0);
                    } else if (response == 1) {
                      getImage(1);
                    }
                  },
                  child: PressableDough(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          NetworkImage(_authInstance.currentUser.photoURL),
                    ),
                  ),
                ),
                SizedBox(
                  height: 28.0,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setDialogState) {
                            return AlertDialog(
                              title: Text('Change nickname'),
                              content: NameTextField(
                                nameController: _nameController,
                                keyboardAction: TextInputAction.done,
                              ),
                              actions: [
                                _isLoading
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
                                    setDialogState(() => _isLoading = true);
                                    await _authInstance.currentUser
                                        .updateProfile(
                                            displayName: _nameController.text);

                                    setState(() {
                                      _isLoading = false;
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
                  },
                  child: Text(
                    '@${_authInstance.currentUser.displayName}',
                    style: TextStyle(fontSize: 22),
                  ),
                ), //just a plain text
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: StatefulBuilder(
                              builder: (context, setDialogState) {
                                return CheckboxListTile(
                                  title: Text('Subtitle'),
                                  value: _isShowSubtitle,
                                  onChanged: (value) => setDialogState(() {
                                    _isShowSubtitle = value;
                                  }),
                                );
                              },
                            ),
                            content: SubtitleTextField(
                              subsController: _subtitleController,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _subtitleText = _subtitleController.text;
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text('Save')),
                            ],
                          );
                        });
                  },
                  child: _isShowSubtitle
                      ? Text(
                          _subtitleText,
                        )
                      : Text(
                          'Add subtitle',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w100,
                              decorationStyle: TextDecorationStyle.dotted),
                        ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                //change or remove this part accordingliy
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: datas.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
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
                                    'Delete ${datas[index].linkcardModel.displayName} ?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlinedButton.icon(
                                            icon: FaIcon(FontAwesomeIcons.times,
                                                size: 14),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            label: Text('Cancel')),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlinedButton.icon(
                                            icon: FaIcon(
                                                FontAwesomeIcons.trashAlt,
                                                size: 14),
                                            style: OutlinedButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Colors.redAccent),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
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
                        if (response) {
                          setState(() => datas.removeAt(index));
                        }
                      },
                      onTap: () async {
                        dynamic result = await showModalBottomSheet(
                          isScrollControlled: true,
                          shape: _bottomSheetStyle,
                          context: context,
                          builder: (context) {
                            return AddCard(
                                linkcardModel: datas[index].linkcardModel);
                          },
                        );

                        if (result != null) {
                          print('Editing ${result.toMap()}');
                          setState(() =>
                              datas[index] = LinkCard(linkcardModel: result));
                        }
                      },
                      child: LinkCard(
                        linkcardModel: datas[index].linkcardModel,
                        isEditing: true,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Transform.scale(
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
                            setState(() {
                              datas.add(LinkCard(linkcardModel: result));
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: datas.isNotEmpty
                      ? Text('Tap to edit, long press to delete')
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
