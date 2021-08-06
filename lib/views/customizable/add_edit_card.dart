import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/linkcard_model.dart';
import '../../utils/social_list.dart';

class AddCard extends StatefulWidget {
  /// If linkcardModel is not null, edit mode is triggered
  const AddCard({Key key, this.linkcardModel}) : super(key: key);

  final LinkcardModel linkcardModel;

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final dropdownInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.zero,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  );
  bool _isNew;
  int _inputType;
  String _socialModelName;
  // bool _keyboardVisible = false;

  final Map<String, String> _urlTextBox = {
    'Profile link': 'http://example.com/',
    'Phone number': '601939xxxxx',
    'Email Address': 'name@example.com',
    'SMS': '60182xxxxxxx'
  };

  final Map<int, String> _prefixUrlText = {
    0: null,
    1: 'tel:',
    2: 'mailto:',
    3: 'sms:'
  };

  final List<String> _dropdownType = ['URL', 'Phone', 'Email', 'SMS'];
  final List<TextInputType> _keyboardType = [
    TextInputType.url,
    TextInputType.phone,
    TextInputType.emailAddress,
    TextInputType.phone
  ];

  @override
  void initState() {
    super.initState();
    _isNew = widget.linkcardModel == null; //is not editing
    // initial Value
    if (_isNew) {
      _titleController.text =
          _socialModelName = SocialLists.socialList.first.name;
      _inputType = 0; // url by default
    } else {
      _socialModelName = widget.linkcardModel.exactName;
      _titleController.text = widget.linkcardModel.displayName;
      _urlController.text = widget.linkcardModel.link;
      if (_urlController.text.contains(RegExp(r'tel:'))) {
        _inputType = 1;
        _urlController.text = _urlController.text.substring(4);
      } else if (_urlController.text.contains(RegExp(r'mailto:'))) {
        _inputType = 2;
        _urlController.text = _urlController.text.substring(7);
      } else if (_urlController.text.contains(RegExp(r'sms:'))) {
        _inputType = 3;
        _urlController.text = _urlController.text.substring(4);
      } else {
        _inputType = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isNew ? 'Add card' : 'Edit card',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _socialModelName,
                          onChanged: (value) {
                            //only change title when not editing
                            setState(() {
                              if (_isNew) {
                                _titleController.text = value;
                              }
                              _socialModelName = value;
                            });
                          },
                          selectedItemBuilder: (context) {
                            return List.generate(
                              SocialLists.socialList.length,
                              (index) => Center(
                                child: FaIcon(
                                  SocialLists.socialList[index].icon,
                                  color: SocialLists.socialList[index].colour,
                                ),
                              ),
                            );
                          },
                          decoration: dropdownInputDecoration,
                          items: SocialLists.socialList.map((element) {
                            return DropdownMenuItem<String>(
                              value: element.name,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: FaIcon(
                                      element.icon,
                                      color: element.colour,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      element.name,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: element.colour,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                            isExpanded: true,
                            value: _inputType,
                            onChanged: (value) =>
                                setState(() => _inputType = value),
                            decoration: dropdownInputDecoration,
                            items: _dropdownType.map((value) {
                              return DropdownMenuItem(
                                value: _dropdownType.indexOf(value),
                                child: Center(
                                    child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black87),
                                )),
                              );
                            }).toList()),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value.isEmpty ? 'Cannot be empty' : null,
                          controller: _urlController,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixText:
                                _prefixUrlText.values.elementAt(_inputType),
                            labelText: _urlTextBox.keys.elementAt(_inputType),
                            hintText: _urlTextBox.values.elementAt(_inputType),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: _keyboardType[_inputType],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.times, size: 14),
                    onPressed: () => Navigator.pop(context),
                    label: Text(_isNew ? 'Discard' : 'Cancel')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.check, size: 14),
                  style: OutlinedButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blueGrey),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      String inputUrl = _urlController.text.trim();
                      switch (_inputType) {
                        case 1:
                          inputUrl = 'tel:$inputUrl';
                          break;
                        case 2:
                          inputUrl = 'mailto:$inputUrl';
                          break;
                        case 3:
                          inputUrl = 'sms:$inputUrl';
                          break;
                        default:
                          inputUrl = inputUrl;
                          if (!await canLaunch(inputUrl)) {
                            inputUrl = 'http://$inputUrl';
                          }
                          break;
                      }

                      Navigator.of(context).pop(LinkcardModel(
                          exactName: _socialModelName,
                          displayName: _titleController.text.trim(),
                          link: inputUrl));
                    }
                  },
                  label: Text(_isNew ? 'Add' : 'Done'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}
