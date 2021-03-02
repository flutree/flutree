import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HorizontalOrLine extends StatelessWidget {
  /// In auth page
  /// https://stackoverflow.com/a/61304861/13617136
  const HorizontalOrLine({
    this.label,
    this.height,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
              child: Divider(
                color: Colors.black,
                height: height,
              )),
        ),
        Text(label),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: height,
              )),
        ),
      ]),
    );
  }
}

Container buildChangeDpIcon() {
  return Container(
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
    child: FaIcon(
      FontAwesomeIcons.camera,
      color: Colors.white,
      size: 12,
    ),
  );
}

TextStyle dottedUnderlinedStyle({Color color}) => TextStyle(
    color: color,
    decorationStyle: TextDecorationStyle.dotted,
    decoration: TextDecoration.underline);

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key key,
    @required TextEditingController emailController,
  })  : _emailController = emailController,
        super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField(
      {Key key,
      @required TextEditingController nameController,
      TextInputAction keyboardAction = TextInputAction.next})
      : _nameController = nameController,
        _keyboardAction = keyboardAction,
        super(key: key);

  final TextEditingController _nameController;
  final TextInputAction _keyboardAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => value.isEmpty ? 'Please enter your name' : null,
      controller: _nameController,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Nickname',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textInputAction: _keyboardAction,
      keyboardType: TextInputType.name,
    );
  }
}

class SubtitleTextField extends StatelessWidget {
  const SubtitleTextField({
    Key key,
    @required TextEditingController subsController,
  })  : _subsController = subsController,
        super(key: key);

  final TextEditingController _subsController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _subsController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter your address, bio, etc.',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    Key key,
    @required TextEditingController passwordController,
  })  : _passwordController = passwordController,
        super(key: key);

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      validator: (value) =>
          value.length < 7 ? 'Please enter more than 7 character' : null,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 10,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );
  }
}
