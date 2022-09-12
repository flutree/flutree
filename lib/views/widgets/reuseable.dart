import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HorizontalOrLine extends StatelessWidget {
  /// In auth page
  /// https://stackoverflow.com/a/61304861/13617136
  const HorizontalOrLine({
    Key? key,
    this.label,
    this.height,
  }) : super(key: key);

  final String? label;
  final double? height;

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
        Text(label!),
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
    decoration:
        const BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
    child: const FaIcon(
      FontAwesomeIcons.camera,
      color: Colors.white,
      size: 12,
    ),
  );
}

TextStyle linkTextStyle =
    const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold);

TextStyle dottedUnderlinedStyle({Color? color}) => TextStyle(
    color: color,
    decorationStyle: TextDecorationStyle.dotted,
    decoration: TextDecoration.underline);

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key? key,
    required TextEditingController emailController,
  })  : _emailController = emailController,
        super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) =>
          value!.isEmpty ? 'Please enter your valid email address' : null,
      controller: _emailController,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class ReportTextField extends StatelessWidget {
  const ReportTextField(
      {Key? key,
      required TextEditingController reportController,
      this.showAnonymousMessage})
      : _reportController = reportController,
        super(key: key);

  final TextEditingController _reportController;
  final bool? showAnonymousMessage;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 4,
      controller: _reportController,
      decoration: InputDecoration(
        labelText: 'Report a bug or problem',
        helperText: showAnonymousMessage! ? 'Your message is anonymous' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      keyboardType: TextInputType.multiline,
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField(
      {Key? key,
      required TextEditingController nameController,
      TextInputAction keyboardAction = TextInputAction.next})
      : _nameController = nameController,
        _keyboardAction = keyboardAction,
        super(key: key);

  final TextEditingController _nameController;
  final TextInputAction _keyboardAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
      controller: _nameController,
      decoration: InputDecoration(
        helperText: 'Nickname must not be empty',
        isDense: true,
        labelText: 'Nickname',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textInputAction: _keyboardAction,
      autofillHints: const [AutofillHints.name],
      keyboardType: TextInputType.name,
    );
  }
}

class SubtitleTextField extends StatelessWidget {
  const SubtitleTextField({
    Key? key,
    required TextEditingController subsController,
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
    Key? key,
    required TextEditingController passwordController,
  })  : _passwordController = passwordController,
        super(key: key);

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      validator: (value) =>
          value!.length < 7 ? 'Please enter more than 7 character' : null,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 10,
      height: 10,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );
  }
}

class LinkContainer extends StatelessWidget {
  const LinkContainer({Key? key, this.child}) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.blueGrey.shade100.withAlpha(105)),
        child: child);
  }
}
